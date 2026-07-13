import 'package:flutter_test/flutter_test.dart';
import 'package:hable/services/app_error.dart';
import 'package:http/http.dart' as http;

void main() {
  test('parses structured backend error envelopes safely', () {
    final response = http.Response(
      '{"error":{"code":"friend_request_self","message":"You can\'t send a friend request to yourself."}}',
      400,
      headers: {'content-type': 'application/json'},
    );

    final appError = AppError.fromResponse(
      response,
      fallbackCode: 'fallback',
      fallbackMessage: 'Fallback message',
    );

    expect(appError.code, 'friend_request_self');
    expect(appError.message, "You can't send a friend request to yourself.");
    expect(appError.kind, AppErrorKind.validation);
  });

  test('parses legacy string error responses during migration', () {
    final response = http.Response(
      '{"error":"Invalid username or password"}',
      401,
      headers: {'content-type': 'application/json'},
    );

    final appError = AppError.fromResponse(
      response,
      fallbackCode: 'auth_login_failed',
      fallbackMessage: 'Fallback message',
    );

    expect(appError.code, 'auth_login_failed');
    expect(appError.message, 'Invalid username or password');
    expect(appError.kind, AppErrorKind.auth);
  });

  test('normalizes browser-style fetch failures into safe copy', () {
    final appError = AppError.fromException(
      Exception('ClientException: Failed to fetch'),
      fallbackCode: 'network_failed',
      fallbackMessage: 'Fallback message',
    );

    expect(appError.code, 'network_request_failed');
    expect(
      appError.message,
      'Hable could not reach the server right now. Please try again in a moment.',
    );
  });

  test(
    'passes through wrapped app exceptions without leaking wrapper text',
    () {
      const appException = AppException(
        AppError(
          code: 'notification_center_load_failed',
          message: 'Hable could not load your notifications right now.',
          kind: AppErrorKind.inline,
        ),
      );

      final appError = AppError.fromAny(
        appException,
        fallbackCode: 'fallback',
        fallbackMessage: 'Fallback message',
      );

      expect(appError.code, 'notification_center_load_failed');
      expect(
        appError.message,
        'Hable could not load your notifications right now.',
      );
      expect(appError.kind, AppErrorKind.inline);
      expect(appError.message.contains('Exception'), isFalse);
      expect(appError.message.contains('Error:'), isFalse);
    },
  );
}
