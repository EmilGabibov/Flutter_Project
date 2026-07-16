import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'web_push_service.dart';

class WebPushClient {
  WebPushClient({http.Client? client, WebPushService? service})
    : _client = client ?? http.Client(),
      _service = service ?? WebPushService();

  final http.Client _client;
  final WebPushService _service;

  bool get supported => _service.supported;

  Future<bool> subscribe({required String token}) async {
    if (!supported) return false;
    final headers = {'Authorization': 'Bearer $token'};
    final configResponse = await _client.get(
      Uri.parse('$apiBaseUrl/api/push/config'),
      headers: headers,
    );
    if (configResponse.statusCode != 200) return false;
    final publicKey = (jsonDecode(configResponse.body) as Map)['public_key'];
    if (publicKey is! String || publicKey.isEmpty) return false;

    final subscription = await _service.subscribe(publicKey);
    if (subscription == null) return false;
    final response = await _client.post(
      Uri.parse('$apiBaseUrl/api/push/subscribe'),
      headers: {...headers, 'Content-Type': 'application/json'},
      body: jsonEncode({'subscription': subscription}),
    );
    return response.statusCode == 200;
  }
}
