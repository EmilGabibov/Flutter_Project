import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart' hide Column;
import '../config/api_config.dart';
import '../database/database.dart';
import 'notification_providers.dart';
import 'database_provider.dart';
import '../services/app_error.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    mOptions: MacOsOptions(usesDataProtectionKeychain: false),
  );
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

  String _networkErrorMessage(
    Object error, {
    String fallbackMessage =
        'Hable could not finish that right now. Please try again.',
  }) {
    return AppError.fromException(
      error,
      fallbackCode: 'auth_network_error',
      fallbackMessage: fallbackMessage,
      fallbackKind: AppErrorKind.inline,
    ).message;
  }

  String _errorFromResponse(
    http.Response response,
    String fallbackMessage, {
    String fallbackCode = 'auth_request_failed',
  }) {
    return AppError.fromResponse(
      response,
      fallbackCode: fallbackCode,
      fallbackMessage: fallbackMessage,
      fallbackKind: AppErrorKind.inline,
    ).message;
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
        unawaited(_restoreReminderForUser(data['user_id'].toString()));
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: _errorFromResponse(
            response,
            'Hable could not log you in just yet.',
            fallbackCode: 'auth_login_failed',
          ),
        );
        return false;
      }
    } on TimeoutException catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          error,
          fallbackMessage: 'Logging in took too long. Please try again.',
        ),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          e,
          fallbackMessage:
              'Hable could not log you in just now. Please try again.',
        ),
      );
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
        unawaited(_restoreReminderForUser(data['user_id'].toString()));
        state = state.copyWith(isLoading: false);
        return true;
      }
      state = state.copyWith(
        isLoading: false,
        error: _errorFromResponse(
          response,
          'Hable could not start the test session.',
          fallbackCode: 'auth_test_login_failed',
        ),
      );
      return false;
    } on TimeoutException catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          error,
          fallbackMessage:
              'Starting the test session took too long. Please try again.',
        ),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          e,
          fallbackMessage: 'Hable could not start the test session right now.',
        ),
      );
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
          error: _errorFromResponse(
            response,
            'Hable could not create that account yet.',
            fallbackCode: 'auth_registration_failed',
          ),
        );
        return false;
      }
    } on TimeoutException catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          error,
          fallbackMessage: 'Sign up took too long. Please try again.',
        ),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          e,
          fallbackMessage: 'Hable could not finish sign up right now.',
        ),
      );
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
        error: _errorFromResponse(
          response,
          'Hable could not send that PIN yet.',
          fallbackCode: 'auth_request_pin_failed',
        ),
      );
      return false;
    } on TimeoutException catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          error,
          fallbackMessage: 'Sending the PIN took too long. Please try again.',
        ),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          e,
          fallbackMessage: 'Hable could not send that PIN right now.',
        ),
      );
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
        error: _errorFromResponse(
          response,
          'Hable could not reset that password yet.',
          fallbackCode: 'auth_reset_failed',
        ),
      );
      return false;
    } on TimeoutException catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          error,
          fallbackMessage:
              'Resetting the password took too long. Please try again.',
        ),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          e,
          fallbackMessage: 'Hable could not reset that password right now.',
        ),
      );
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
        error: _errorFromResponse(
          response,
          'Hable could not send the activation PIN yet.',
          fallbackCode: 'auth_activation_pin_request_failed',
        ),
      );
      return false;
    } on TimeoutException catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          error,
          fallbackMessage:
              'Sending the activation PIN took too long. Please try again.',
        ),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          e,
          fallbackMessage: 'Hable could not send the activation PIN right now.',
        ),
      );
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
        error: _errorFromResponse(
          response,
          'Hable could not verify that PIN yet.',
          fallbackCode: 'auth_activation_pin_verify_failed',
        ),
      );
      return false;
    } on TimeoutException catch (error) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          error,
          fallbackMessage:
              'Verifying that PIN took too long. Please try again.',
        ),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _networkErrorMessage(
          e,
          fallbackMessage: 'Hable could not verify that PIN right now.',
        ),
      );
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

    // 1. Fetch current avatar and make optimistic write
    final currentUserRow = await (_db.select(
      _db.users,
    )..where((u) => u.userId.equals(userId))).getSingleOrNull();
    final oldAvatarUrl = currentUserRow?.avatarUrl;

    if (currentUserRow != null) {
      await (_db.update(
        _db.users,
      )..where((u) => u.userId.equals(userId))).write(
        UsersCompanion(
          avatarUrl: Value(avatarUrl),
          updatedAt: Value(DateTime.now()),
          isSynced: const Value(false),
        ),
      );
    } else {
      await _ensureUserInDb(userId, state.username ?? 'User', avatarUrl);
    }

    // 2. Perform network request
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
        // Confirm sync status
        await (_db.update(_db.users)..where((u) => u.userId.equals(userId)))
            .write(const UsersCompanion(isSynced: Value(true)));
        return true;
      }

      // Rollback on HTTP error
      if (currentUserRow != null) {
        await (_db.update(
          _db.users,
        )..where((u) => u.userId.equals(userId))).write(
          UsersCompanion(
            avatarUrl: Value(oldAvatarUrl),
            isSynced: const Value(true),
          ),
        );
      }
      state = state.copyWith(
        error: _errorFromResponse(
          response,
          'Hable could not save that avatar yet.',
          fallbackCode: 'auth_avatar_update_failed',
        ),
      );
      return false;
    } on TimeoutException catch (error) {
      if (currentUserRow != null) {
        await (_db.update(
          _db.users,
        )..where((u) => u.userId.equals(userId))).write(
          UsersCompanion(
            avatarUrl: Value(oldAvatarUrl),
            isSynced: const Value(true),
          ),
        );
      }
      state = state.copyWith(
        error: _networkErrorMessage(
          error,
          fallbackMessage:
              'Saving that avatar took too long. Please try again.',
        ),
      );
      return false;
    } catch (e) {
      if (currentUserRow != null) {
        await (_db.update(
          _db.users,
        )..where((u) => u.userId.equals(userId))).write(
          UsersCompanion(
            avatarUrl: Value(oldAvatarUrl),
            isSynced: const Value(true),
          ),
        );
      }
      state = state.copyWith(
        error: _networkErrorMessage(
          e,
          fallbackMessage: 'Hable could not save that avatar right now.',
        ),
      );
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> forceLogoutWithMessage(String message) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final userId = state.userId;
    if (userId != null) {
      await _cancelReminderForUser(userId);
    }
    await _storage.deleteAll();
    state = state.copyWith(
      isLoading: false,
      isInitialized: true,
      error: message,
      clearCredentials: true,
    );
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
    try {
      await ref
          .read(notificationActionsProvider)
          .restoreRemindersForUser(userId);
    } catch (error) {
      debugPrint('Failed to restore reminder schedule: $error');
    }
  }

  Future<void> _cancelReminderForUser(String userId) async {
    try {
      await ref
          .read(notificationActionsProvider)
          .cancelRemindersForUser(userId);
    } catch (error) {
      debugPrint('Failed to cancel reminder schedule: $error');
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
