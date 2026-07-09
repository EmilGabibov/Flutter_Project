import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart' hide Column;
import '../database/database.dart';
import 'database_provider.dart';
import 'package:flutter/foundation.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

class AuthState {
  final bool isLoading;
  final String? error;
  final String? token;
  final String? userId;
  final String? username;

  AuthState({
    this.isLoading = false,
    this.error,
    this.token,
    this.userId,
    this.username,
  });

  bool get isAuthenticated => token != null && userId != null;

  AuthState copyWith({
    bool? isLoading,
    String? error,
    String? token,
    String? userId,
    String? username,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      token: token ?? this.token,
      userId: userId ?? this.userId,
      username: username ?? this.username,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  FlutterSecureStorage get _storage => ref.read(secureStorageProvider);
  AppDatabase get _db => ref.read(databaseProvider);
  static String get _localhostUrl {
    if (kIsWeb) return 'http://127.0.0.1:8787';
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:8787';
    return 'http://127.0.0.1:8787';
  }
  static final String _baseUrl = kDebugMode ? _localhostUrl : 'https://hable.pages.dev';
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _usernameKey = 'username';

  @override
  AuthState build() {
    if (kDebugMode) {
      _storage.deleteAll();
      _db.delete(_db.users).go();
    }
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
      );
    }
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveAuth(data['token'], data['user_id'], data['username']);
        await _ensureUserInDb(data['user_id'], data['username'], data['avatar_url']);
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        final data = jsonDecode(response.body);
        state = state.copyWith(
          isLoading: false,
          error: data['error'] ?? 'Login failed',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error');
      return false;
    }
  }

  Future<bool> testLogin(String userId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveAuth(data['token'], data['user_id'], data['username']);
        await _ensureUserInDb(data['user_id'], data['username'], data['avatar_url']);
        state = state.copyWith(isLoading: false);
        return true;
      }
      state = state.copyWith(isLoading: false, error: 'Test login failed');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error');
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveAuth(data['token'], data['user_id'], data['username']);
        await _ensureUserInDb(data['user_id'], data['username'], data['avatar_url']);
        state = state.copyWith(isLoading: false);
        return true;
      } else {
        final data = jsonDecode(response.body);
        state = state.copyWith(
          isLoading: false,
          error: data['error'] ?? 'Registration failed',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error');
      return false;
    }
  }

  Future<bool> requestPin(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/request-pin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode == 200) {
        state = state.copyWith(isLoading: false);
        return true;
      }
      final data = jsonDecode(response.body);
      state = state.copyWith(isLoading: false, error: data['error'] ?? 'Failed to request PIN');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error');
      return false;
    }
  }

  Future<bool> resetPassword(String email, String pin, String newPassword) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'pin': pin,
          'new_password': newPassword,
        }),
      );
      if (response.statusCode == 200) {
        state = state.copyWith(isLoading: false);
        return true;
      }
      final data = jsonDecode(response.body);
      state = state.copyWith(isLoading: false, error: data['error'] ?? 'Reset failed');
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Network error');
      return false;
    }
  }

  Future<bool> updateAvatar(String avatarUrl) async {
    final token = state.token;
    final userId = state.userId;
    if (token == null || userId == null) return false;

    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/api/user/avatar'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'avatar_url': avatarUrl}),
      );

      if (response.statusCode == 200) {
        // Update local database
        await _db.into(_db.users).insertOnConflictUpdate(
          UsersCompanion(
            userId: Value(userId),
            avatarUrl: Value(avatarUrl),
          ),
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating avatar: $e');
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<void> _saveAuth(String token, String userId, String username) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _usernameKey, value: username);
    state = state.copyWith(
      token: token,
      userId: userId,
      username: username,
    );
  }

  Future<void> _ensureUserInDb(String userId, String username, String? avatarUrl) async {
    // Upsert user into local Drift DB so the app can function offline
    await _db.into(_db.users).insertOnConflictUpdate(UsersCompanion(
      userId: Value(userId),
      username: Value(username),
      avatarUrl: Value(avatarUrl),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
      isSynced: const Value(true),
    ));
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
