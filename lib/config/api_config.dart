import 'package:flutter/foundation.dart';

const _apiBaseOverride = String.fromEnvironment('HABLE_API_BASE_URL');

String get apiBaseUrl {
  if (_apiBaseOverride.isNotEmpty) {
    return _apiBaseOverride;
  }

  if (!kDebugMode) {
    return 'https://hable.pages.dev';
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://127.0.0.1:8787';
  }

  return 'http://127.0.0.1:8787';
}
