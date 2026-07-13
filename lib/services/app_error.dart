import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum AppErrorKind {
  inline,
  snackbar,
  banner,
  fullscreen,
  retryable,
  auth,
  validation,
}

class AppError {
  final String code;
  final String message;
  final AppErrorKind kind;
  final int? statusCode;

  const AppError({
    required this.code,
    required this.message,
    required this.kind,
    this.statusCode,
  });

  static AppError fromResponse(
    http.Response response, {
    required String fallbackCode,
    required String fallbackMessage,
    AppErrorKind? fallbackKind,
  }) {
    final decoded = _decodeErrorEnvelope(response.body);
    final message = _sanitizeMessage(decoded.message ?? fallbackMessage);
    final code = decoded.code ?? fallbackCode;
    return AppError(
      code: code,
      message: message,
      kind: fallbackKind ?? _kindForStatus(response.statusCode),
      statusCode: response.statusCode,
    );
  }

  static AppError fromException(
    Object error, {
    String fallbackCode = 'unknown_error',
    String fallbackMessage = 'Hable hit a bump. Please try again.',
    AppErrorKind fallbackKind = AppErrorKind.snackbar,
  }) {
    if (error is AppException) {
      return error.error;
    }

    if (error is TimeoutException) {
      return const AppError(
        code: 'request_timeout',
        message: 'That took too long. Give it another try.',
        kind: AppErrorKind.retryable,
      );
    }

    final raw = error.toString();
    final lower = raw.toLowerCase();
    if (lower.contains('socketexception') ||
        lower.contains('failed host lookup') ||
        lower.contains('network is unreachable')) {
      return const AppError(
        code: 'network_unreachable',
        message:
            'Hable could not reach the internet. Check your connection and try again.',
        kind: AppErrorKind.retryable,
      );
    }

    if (lower.contains('xmlhttprequest') ||
        lower.contains('failed to fetch') ||
        lower.contains('clientexception') ||
        lower.contains('cors')) {
      return const AppError(
        code: 'network_request_failed',
        message:
            'Hable could not reach the server right now. Please try again in a moment.',
        kind: AppErrorKind.retryable,
      );
    }

    if (lower.contains('handshakeexception') || lower.contains('certificate')) {
      return const AppError(
        code: 'secure_connection_failed',
        message:
            'Hable could not make a secure connection right now. Please try again later.',
        kind: AppErrorKind.retryable,
      );
    }

    if (lower.contains('formatexception') ||
        lower.contains('unexpected character') ||
        lower.contains('typeerror')) {
      return const AppError(
        code: 'invalid_response',
        message:
            'Hable received a response it could not use. Please try again.',
        kind: AppErrorKind.retryable,
      );
    }

    return AppError(
      code: fallbackCode,
      message: _sanitizeMessage(fallbackMessage),
      kind: fallbackKind,
    );
  }

  static AppError fromAny(
    Object error, {
    String fallbackCode = 'unknown_error',
    String fallbackMessage = 'Hable hit a bump. Please try again.',
    AppErrorKind fallbackKind = AppErrorKind.snackbar,
  }) {
    if (error is AppException) {
      return error.error;
    }
    return fromException(
      error,
      fallbackCode: fallbackCode,
      fallbackMessage: fallbackMessage,
      fallbackKind: fallbackKind,
    );
  }

  static AppErrorKind _kindForStatus(int statusCode) {
    if (statusCode == 400 || statusCode == 409 || statusCode == 422) {
      return AppErrorKind.validation;
    }
    if (statusCode == 401) return AppErrorKind.auth;
    if (statusCode == 403 || statusCode == 404) {
      return AppErrorKind.inline;
    }
    if (statusCode >= 500) return AppErrorKind.banner;
    return AppErrorKind.snackbar;
  }

  static _DecodedErrorEnvelope _decodeErrorEnvelope(String body) {
    final trimmed = body.trim();
    if (trimmed.isEmpty) return const _DecodedErrorEnvelope();

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is Map<String, dynamic>) {
        final errorField = decoded['error'];
        if (errorField is Map<String, dynamic>) {
          return _DecodedErrorEnvelope(
            code: _normalizeCode(errorField['code']),
            message: _normalizeMessage(errorField['message']),
          );
        }
        if (errorField is String) {
          return _DecodedErrorEnvelope(message: errorField.trim());
        }
        final messageField = decoded['message'];
        if (messageField is String) {
          return _DecodedErrorEnvelope(message: messageField.trim());
        }
      }
    } catch (_) {
      if (kDebugMode) {
        debugPrint(
          '[AppError] Non-JSON error body ignored: '
          '${trimmed.length > 180 ? '${trimmed.substring(0, 180)}...' : trimmed}',
        );
      }
    }

    return const _DecodedErrorEnvelope();
  }

  static String? _normalizeCode(Object? code) {
    final value = code?.toString().trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static String? _normalizeMessage(Object? message) {
    final value = message?.toString().trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static String _sanitizeMessage(String message) {
    final normalized = message.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.isEmpty) {
      return 'Hable hit a bump. Please try again.';
    }
    return normalized.length > 220
        ? '${normalized.substring(0, 217).trimRight()}...'
        : normalized;
  }
}

class AppException implements Exception {
  final AppError error;

  const AppException(this.error);

  @override
  String toString() => error.message;
}

class _DecodedErrorEnvelope {
  final String? code;
  final String? message;

  const _DecodedErrorEnvelope({this.code, this.message});
}
