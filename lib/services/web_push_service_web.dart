// ignore_for_file: deprecated_member_use

import 'dart:js' as js;
import 'dart:js_util' as js_util;

class WebPushService {
  bool get supported => true;

  Future<Map<String, dynamic>?> subscribe(String publicKey) async {
    try {
      final promise = js.context.callMethod('hablePushSubscribe', [publicKey]);
      final result = await js_util.promiseToFuture<dynamic>(promise);
      if (result is Map) return Map<String, dynamic>.from(result);
    } catch (_) {
      return null;
    }
    return null;
  }
}
