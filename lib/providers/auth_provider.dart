import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart' hide Column;
import '../config/api_config.dart';
import '../database/database.dart';
import '../services/local_reminder_service.dart';
import 'database_provider.dart';
import 'package:flutter/foundation.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

class AuthState {
  final bool isLoading;
  final bool isInitialized;
  final String? error;
  final String? token;
  final String? userId;
  final String? username;

  AuthState({
    this.isLoading = false,
    this.isInitialized = false,
    this.error,
    this.token,
    this.userId,
    this.username,
  });

  bool get isAuthenticated => token != null && userId != null;

  AuthState copyWith({
    bool? isLoading,
    bool? isInitialized,
    String? error,
    String? token,
    String? userId,
    String? username,
    bool clearError = false,
    bool clearCredentials = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isInitialized: isInitialized ?? this.isInitialized,
      error: clearError ? null : (error ?? this.error),
      token: clearCredentials ? null : (token ?? this.token),
      userId: clearCredentials ? null : (userId ?? this.userId),
      username: clearCredentials ? null : (username ?? this.username),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  FlutterSecureStorage get _storage => ref.read(secureStorageProvider);
  AppDatabase get _db => ref.read(databaseProvider);
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';

  String _networkErrorMessage(Object error) {
    final message = error.toString();
    if (message.contains('SocketException')) {
      return 'Cannot reach the backend at $apiBaseUrl. Start the backend or check the API base URL.';
    }
    if (message.contains('XMLHttpRequest') ||
        message.contains('ClientException') ||
        message.contains('Failed to fetch')) {
      return 'Cannot reach the backend at $apiBaseUrl. Start the backend, check CORS, or set HABLE_API_BASE_URL.';
    }
    if (message.contains('HandshakeException')) {
      return 'Unable to establish a secure connection to the backend.';
    }
    if (message.contains('FormatException')) {
      return 'Unexpected response from the backend.';
    }
    return message;
  }

  String _errorFromResponse(http.Response response, String fallback) {
    final body = response.body.trim();
    if (body.isNotEmpty) {
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          final error = decoded['error'] ?? decoded['message'];
          if (error is String && error.trim().isNotEmpty) {
            return error.trim();
          }
        }
      } catch (_) {
        if (kDebugMode) {
          debugPrint(
            'Auth endpoint returned non-JSON ${response.statusCode}: '
            '${body.length > 240 ? '${body.substring(0, 240)}...' : body}',
          );
        }
      }
    }

    return '$fallback (${response.statusCode})';
  }

  DateTime? _parseOptionalDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  @override
  AuthState build() {
    _loadStoredAuth();
    return AuthState();
  }

  Future<void> _loadStoredAuth() async {
    final token = await _storage.read(key: _tokenKey);
    final userId = await _storage.read(key: _userIdKey);
    final username = await _storage.read(key: _usernameKey);

    if (token != null && userId != null) {
      state = state.copyWith(
        token: token,
        userId: userId,
        username: username,
        isInitialized: true,
      );
      unawaited(_restoreReminderForUser(userId));
      return;
    }

    state = state.copyWith(isInitialized: true);
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/api/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveAuth(data['token'], data['user_id'], data['username']);
        await _ensureUserInDb(
          data['user_id'],
          data['username'],
          data['avatar_url'],
          email: data['email'],
          emailVerifiedAt: _parseOptionalDate(data['email_verified_at']),
        );
        await _restoreReminderForUser(data['user_id'].toString());
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: _errorFromResponse(response, 'Login failed'),
        );
        return false;
      }
    } on TimeoutException {
      state = state.copyWith(isLoading: false, error: 'Request timed out');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _networkErrorMessage(e));
      return false;
    }
  }

  Future<bool> testLogin(String userId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/api/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'user_id': userId}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveAuth(data['token'], data['user_id'], data['username']);
        await _ensureUserInDb(
          data['user_id'],
          data['username'],
          data['avatar_url'],
          email: data['email'],
          emailVerifiedAt: _parseOptionalDate(data['email_verified_at']),
        );
        await _restoreReminderForUser(data['user_id'].toString());
        state = state.copyWith(isLoading: false);
        return true;
      }
      state = state.copyWith(
        isLoading: false,
        error: _errorFromResponse(response, 'Test login failed'),
      );
      return false;
    } on TimeoutException {
      state = state.copyWith(isLoading: false, error: 'Request timed out');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _networkErrorMessage(e));
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/api/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveAuth(data['token'], data['user_id'], data['username']);
        await _ensureUserInDb(
          data['user_id'],
          data['username'],
          data['avatar_url'],
          email: data['email'],
          emailVerifiedAt: _parseOptionalDate(data['email_verified_at']),
        );
        await _restoreReminderForUser(data['user_id'].toString());
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: _errorFromResponse(response, 'Registration failed'),
        );
        return false;
      }
    } on TimeoutException {
      state = state.copyWith(isLoading: false, error: 'Request timed out');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _networkErrorMessage(e));
      return false;
    }
  }

  Future<bool> requestPin(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/api/auth/request-pin'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        state = state.copyWith(isLoading: false);
        return true;
      }
      state = state.copyWith(
        isLoading: false,
        error: _errorFromResponse(response, 'Failed to request PIN'),
      );
      return false;
    } on TimeoutException {
      state = state.copyWith(isLoading: false, error: 'Request timed out');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _networkErrorMessage(e));
      return false;
    }
  }

  Future<bool> resetPassword(
    String email,
    String pin,
    String newPassword,
  ) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/api/auth/reset-password'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'pin': pin,
              'new_password': newPassword,
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        state = state.copyWith(isLoading: false);
        return true;
      }
      state = state.copyWith(
        isLoading: false,
        error: _errorFromResponse(response, 'Reset failed'),
      );
      return false;
    } on TimeoutException {
      state = state.copyWith(isLoading: false, error: 'Request timed out');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _networkErrorMessage(e));
      return false;
    }
  }

  Future<bool> requestProfileActivationPin(String email) async {
    final token = state.token;
    if (token == null) {
      state = state.copyWith(error: 'Log in before activating cloud sync');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/api/user/email/request-pin'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'email': email}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        state = state.copyWith(isLoading: false);
        return true;
      }

      state = state.copyWith(
        isLoading: false,
        error: _errorFromResponse(response, 'Failed to request activation PIN'),
      );
      return false;
    } on TimeoutException {
      state = state.copyWith(isLoading: false, error: 'Request timed out');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _networkErrorMessage(e));
      return false;
    }
  }

  Future<bool> verifyProfileActivationPin(String email, String pin) async {
    final token = state.token;
    final userId = state.userId;
    if (token == null || userId == null) {
      state = state.copyWith(error: 'Log in before activating cloud sync');
      return false;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await http
          .post(
            Uri.parse('$apiBaseUrl/api/user/email/verify-pin'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'email': email, 'pin': pin}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final verifiedAt =
            _parseOptionalDate(data['email_verified_at']) ?? DateTime.now();
        await _db.updateUserEmailVerification(
          userId,
          email: data['email']?.toString() ?? email,
          emailVerifiedAt: verifiedAt,
        );
        state = state.copyWith(isLoading: false);
        return true;
      }

      state = state.copyWith(
        isLoading: false,
        error: _errorFromResponse(response, 'Failed to verify activation PIN'),
      );
      return false;
    } on TimeoutException {
      state = state.copyWith(isLoading: false, error: 'Request timed out');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: _networkErrorMessage(e));
      return false;
    }
  }

  Future<bool> updateAvatar(String avatarUrl) async {
    final token = state.token;
    final userId = state.userId;
    if (token == null || userId == null) {
      state = state.copyWith(error: 'Log in before updating avatar');
      return false;
    }

    state = state.copyWith(clearError: true);
    try {
      final response = await http
          .put(
            Uri.parse('$apiBaseUrl/api/user/avatar'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode({'avatar_url': avatarUrl}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final updated = await (_db.update(
          _db.users,
        )..where((user) => user.userId.equals(userId))).write(
          UsersCompanion(
            avatarUrl: Value(avatarUrl),
            updatedAt: Value(DateTime.now()),
            isSynced: const Value(true),
          ),
        );

        if (updated == 0) {
          await _ensureUserInDb(
            userId,
            state.username ?? 'User',
            avatarUrl,
          );
        }
        return true;
      }
      state = state.copyWith(
        error: _errorFromResponse(response, 'Failed to update avatar'),
      );
      return false;
    } on TimeoutException {
      state = state.copyWith(error: 'Request timed out');
      return false;
    } catch (e) {
      state = state.copyWith(error: _networkErrorMessage(e));
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final userId = state.userId;
    if (userId != null) {
      await _cancelReminderForUser(userId);
    }
    await _storage.deleteAll();
    state = state.copyWith(
      isLoading: false,
      isInitialized: true,
      clearCredentials: true,
    );
  }

  Future<void> _saveAuth(String token, String userId, String username) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _usernameKey, value: username);
    state = state.copyWith(
      token: token,
      userId: userId,
      username: username,
      isInitialized: true,
    );
  }

  Future<void> _ensureUserInDb(
    String userId,
    String username,
    String? avatarUrl, {
    Object? email,
    DateTime? emailVerifiedAt,
  }) async {
    // Upsert user into local Drift DB so the app can function offline
    await _db
        .into(_db.users)
        .insertOnConflictUpdate(
          UsersCompanion(
            userId: Value(userId),
            username: Value(username),
            email: Value(email?.toString()),
            emailVerifiedAt: Value(emailVerifiedAt),
            avatarUrl: Value(avatarUrl),
            createdAt: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
            isSynced: const Value(true),
          ),
        );
  }

  Future<void> _restoreReminderForUser(String userId) async {
    final setting = await _db.getReminderSetting(userId);
    if (setting == null || !setting.isEnabled) return;

    try {
      await ref.read(localReminderServiceProvider).scheduleDailyReminder(
        userId: userId,
        hour: setting.hour,
        minute: setting.minute,
        title: 'Hable reminder',
        body: 'Open Hable and check today\'s habits.',
      );
    } catch (error) {
      debugPrint('Failed to restore reminder schedule: $error');
    }
  }

  Future<void> _cancelReminderForUser(String userId) async {
    try {
      await ref.read(localReminderServiceProvider).cancelReminder(userId);
    } catch (error) {
      debugPrint('Failed to cancel reminder schedule: $error');
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
