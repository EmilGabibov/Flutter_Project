// ignore_for_file: prefer_initializing_formals

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../database/database.dart';

const allowedUsageScreenNames = <String>{
  'app',
  'auth',
  'main_shell',
  'home',
  'profile',
  'settings',
  'social_hub',
  'notification_center',
  'habit_form',
  'onboarding',
};

const allowedUsageMetricNames = <String>{
  'app_open',
  'screen_visit',
  'screen_visible_ms',
};

class UsageDiagnosticsService {
  UsageDiagnosticsService({
    required AppDatabase db,
    required http.Client client,
    required String apiBaseUrl,
    required bool localCollectionEnabled,
    required bool remoteUploadEnabled,
    required String buildChannel,
    DateTime Function()? now,
    this.durationBucket = const Duration(seconds: 5),
  }) : _db = db,
       _client = client,
       _apiBaseUrl = apiBaseUrl,
       _localCollectionEnabled = localCollectionEnabled,
       _remoteUploadEnabled = remoteUploadEnabled,
       _buildChannel = buildChannel,
       _now = now ?? DateTime.now;

  final AppDatabase _db;
  final http.Client _client;
  final String _apiBaseUrl;
  final bool _localCollectionEnabled;
  final bool _remoteUploadEnabled;
  final String _buildChannel;
  final DateTime Function() _now;
  final Duration durationBucket;

  bool _hasRecordedAppOpen = false;
  bool _disposed = false;
  bool _uploadInFlight = false;
  String? _activeScreenName;
  DateTime? _screenVisibleSince;

  bool get isLocalCollectionEnabled => _localCollectionEnabled;
  bool get isRemoteUploadEnabled => _remoteUploadEnabled;

  void init() {
    unawaited(recordAppOpen());
  }

  Future<void> recordAppOpen() async {
    if (_disposed || !_localCollectionEnabled || _hasRecordedAppOpen) return;
    _hasRecordedAppOpen = true;
    await _incrementBucket(
      screenName: 'app',
      metricName: 'app_open',
      countDelta: 1,
    );
    await uploadPendingBuckets();
  }

  Future<void> screenBecameVisible(String screenName) async {
    if (_disposed || !_localCollectionEnabled) return;
    if (!allowedUsageScreenNames.contains(screenName)) return;
    if (_activeScreenName == screenName && _screenVisibleSince != null) return;

    await _flushActiveScreen();
    _activeScreenName = screenName;
    _screenVisibleSince = _now();
    await _incrementBucket(
      screenName: screenName,
      metricName: 'screen_visit',
      countDelta: 1,
    );
    await uploadPendingBuckets();
  }

  Future<void> screenBecameHidden(String screenName) async {
    if (_disposed || !_localCollectionEnabled) return;
    if (_activeScreenName != screenName) return;
    await _flushActiveScreen();
    await uploadPendingBuckets();
  }

  Future<void> flushActiveScreen() => _flushActiveScreen();

  int roundDurationMs(int rawDurationMs) {
    if (rawDurationMs <= 0) return 0;
    final bucketMs = durationBucket.inMilliseconds;
    return ((rawDurationMs + bucketMs - 1) ~/ bucketMs) * bucketMs;
  }

  Map<String, Object?> buildUploadPayload(List<UsageAggregateBucket> rows) {
    return {
      'buckets': rows
          .map(
            (row) => <String, Object?>{
              'bucket_date': row.bucketDate,
              'platform': row.platform,
              'build_channel': row.buildChannel,
              'screen_name': row.screenName,
              'metric_name': row.metricName,
              'count': row.count - row.uploadedCount,
              'total_duration_ms':
                  row.totalDurationMs - row.uploadedTotalDurationMs,
            },
          )
          .where(
            (row) =>
                ((row['count'] as int?) ?? 0) > 0 ||
                ((row['total_duration_ms'] as int?) ?? 0) > 0,
          )
          .toList(growable: false),
    };
  }

  Future<void> uploadPendingBuckets() async {
    if (_disposed || !_remoteUploadEnabled || _uploadInFlight) return;
    _uploadInFlight = true;
    try {
      final rows = await _db.getPendingUsageAggregateBuckets();
      if (rows.isEmpty) return;

      final payload = buildUploadPayload(rows);
      final buckets = payload['buckets'] as List<Object?>;
      if (buckets.isEmpty) return;

      final response = await _client.post(
        Uri.parse('$_apiBaseUrl/api/dev/usage-aggregate'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Usage aggregate upload failed: ${response.statusCode} ${response.body}',
        );
      }

      for (final row in rows) {
        await _db.markUsageAggregateBucketUploaded(row);
      }
    } catch (error) {
      debugPrint('[UsageDiagnostics] Upload skipped: $error');
    } finally {
      _uploadInFlight = false;
    }
  }

  void dispose() {
    if (_disposed) return;
    _disposed = true;
    unawaited(_flushActiveScreen());
    _client.close();
  }

  Future<void> _flushActiveScreen() async {
    final activeScreenName = _activeScreenName;
    final visibleSince = _screenVisibleSince;
    if (activeScreenName == null || visibleSince == null) return;

    _activeScreenName = null;
    _screenVisibleSince = null;

    final elapsed = _now().difference(visibleSince).inMilliseconds;
    final roundedDuration = roundDurationMs(elapsed);
    if (roundedDuration <= 0) return;

    await _incrementBucket(
      screenName: activeScreenName,
      metricName: 'screen_visible_ms',
      durationMsDelta: roundedDuration,
    );
  }

  Future<void> _incrementBucket({
    required String screenName,
    required String metricName,
    int countDelta = 0,
    int durationMsDelta = 0,
  }) async {
    if (!allowedUsageScreenNames.contains(screenName)) return;
    if (!allowedUsageMetricNames.contains(metricName)) return;
    if (countDelta <= 0 && durationMsDelta <= 0) return;

    final now = _now().toUtc();
    await _db.incrementUsageAggregateBucket(
      bucketDate: _bucketDate(now),
      platform: _platformLabel(),
      buildChannel: _buildChannel,
      screenName: screenName,
      metricName: metricName,
      countDelta: countDelta,
      durationMsDelta: durationMsDelta,
      updatedAt: now,
    );
  }

  String _bucketDate(DateTime value) {
    final normalized = value.toUtc();
    final month = normalized.month.toString().padLeft(2, '0');
    final day = normalized.day.toString().padLeft(2, '0');
    return '${normalized.year}-$month-$day';
  }

  String _platformLabel() {
    if (kIsWeb) return 'web';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
    }
  }
}
