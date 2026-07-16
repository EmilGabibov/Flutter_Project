import 'dart:js_interop';

@JS('hablePushSubscribe')
external JSPromise<JSAny?> _hablePushSubscribe(JSString publicKey);

class WebPushService {
  bool get supported => true;

  Future<Map<String, dynamic>?> subscribe(String publicKey) async {
    try {
      final result = (await _hablePushSubscribe(
        publicKey.toJS,
      ).toDart).dartify();
      if (result is Map) return Map<String, dynamic>.from(result);
    } catch (_) {
      return null;
    }
    return null;
  }
}
