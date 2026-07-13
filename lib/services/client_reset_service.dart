import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../database/database.dart';
import '../providers/auth_provider.dart';

const _appliedResetTokenKey = 'hable_applied_force_reset_token';

class ForcedClientResetStatus {
  const ForcedClientResetStatus({required this.token, required this.reason});

  final String? token;
  final String? reason;
}

class ForcedClientResetResult {
  const ForcedClientResetResult({required this.didReset, this.message});

  final bool didReset;
  final String? message;
}

Future<ForcedClientResetStatus?> fetchForcedClientResetStatus() async {
  try {
    final uri = Uri.parse('$apiBaseUrl/api/app/version-status').replace(
      queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()},
    );

    final response = await http
        .get(
          uri,
          headers: const {'Cache-Control': 'no-cache', 'Pragma': 'no-cache'},
        )
        .timeout(const Duration(seconds: 3));
    if (response.statusCode != 200) return null;

    final data = jsonDecode(response.body);
    if (data is! Map<String, dynamic>) return null;

    return ForcedClientResetStatus(
      token: data['force_client_reset_token']?.toString(),
      reason: data['force_client_reset_reason']?.toString(),
    );
  } catch (_) {
    // Fail open at startup when the backend is unavailable.
    return null;
  }
}

Future<ForcedClientResetResult> _resetLocalState({
  required AppDatabase database,
  required AuthNotifier authNotifier,
  String? token,
  String? reason,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await database.clearAllLocalData();
  await prefs.clear();
  if (token != null && token.trim().isNotEmpty) {
    await prefs.setString(_appliedResetTokenKey, token.trim());
  }

  final message = reason?.trim().isNotEmpty == true
      ? reason!.trim()
      : 'We temporarily cleared local Hable data. Please sign in again.';
  await authNotifier.forceLogoutWithMessage(message);

  return ForcedClientResetResult(didReset: true, message: message);
}

Future<ForcedClientResetResult> applyForcedClientResetIfNeeded({
  required AppDatabase database,
  required AuthNotifier authNotifier,
}) async {
  final status = await fetchForcedClientResetStatus();
  final token = status?.token?.trim();
  if (token == null || token.isEmpty) {
    return const ForcedClientResetResult(didReset: false);
  }

  final prefs = await SharedPreferences.getInstance();
  final appliedToken = prefs.getString(_appliedResetTokenKey)?.trim();
  if (appliedToken == token) {
    return const ForcedClientResetResult(didReset: false);
  }

  return _resetLocalState(
    database: database,
    authNotifier: authNotifier,
    token: token,
    reason: status?.reason,
  );
}

Future<ForcedClientResetResult> performManualRecoveryReset({
  required AppDatabase database,
  required AuthNotifier authNotifier,
}) async {
  final status = await fetchForcedClientResetStatus();
  return _resetLocalState(
    database: database,
    authNotifier: authNotifier,
    token: status?.token,
    reason:
        status?.reason ??
        'We cleared local Hable data on this device. Please sign in again.',
  );
}
