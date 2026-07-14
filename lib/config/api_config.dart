import 'package:flutter/foundation.dart';

import 'web_origin_stub.dart' if (dart.library.html) 'web_origin_web.dart';

const _apiBaseOverride = String.fromEnvironment('HABLE_API_BASE_URL');
const _appEnvironmentOverride = String.fromEnvironment('HABLE_APP_ENV');
const _stagingApiBaseOverride = String.fromEnvironment(
  'HABLE_STAGING_API_BASE_URL',
);

const String localApiBaseUrl = 'http://127.0.0.1:8787';
const String productionApiBaseUrl = 'https://hable.pages.dev';

enum HableAppEnvironment { local, staging, production }

HableAppEnvironment get appEnvironment => resolveAppEnvironment(
  rawEnvironment: _appEnvironmentOverride,
  defaultEnvironment: kReleaseMode
      ? HableAppEnvironment.production
      : HableAppEnvironment.local,
);

String get apiBaseUrl => resolveApiBaseUrl(
  apiBaseOverride: _apiBaseOverride,
  environment: appEnvironment,
  stagingApiBaseUrl: _stagingApiBaseOverride,
  currentWebOrigin: getCurrentWebOrigin(),
);

HableAppEnvironment resolveAppEnvironment({
  required String rawEnvironment,
  required HableAppEnvironment defaultEnvironment,
}) {
  final normalized = rawEnvironment.trim().toLowerCase();
  switch (normalized) {
    case '':
      return defaultEnvironment;
    case 'local':
    case 'dev':
    case 'development':
      return HableAppEnvironment.local;
    case 'staging':
    case 'stage':
      return HableAppEnvironment.staging;
    case 'production':
    case 'prod':
      return HableAppEnvironment.production;
    default:
      return defaultEnvironment;
  }
}

String resolveApiBaseUrl({
  required String apiBaseOverride,
  required HableAppEnvironment environment,
  String stagingApiBaseUrl = '',
  String? currentWebOrigin,
}) {
  final normalizedOverride = apiBaseOverride.trim();
  if (normalizedOverride.isNotEmpty) {
    return normalizedOverride;
  }

  final normalizedWebOrigin = _normalizePreferredWebOrigin(currentWebOrigin);
  if (normalizedWebOrigin != null && environment != HableAppEnvironment.local) {
    return normalizedWebOrigin;
  }

  switch (environment) {
    case HableAppEnvironment.local:
      return localApiBaseUrl;
    case HableAppEnvironment.staging:
      final normalizedStagingUrl = stagingApiBaseUrl.trim();
      if (normalizedStagingUrl.isNotEmpty) {
        return normalizedStagingUrl;
      }
      return productionApiBaseUrl;
    case HableAppEnvironment.production:
      return productionApiBaseUrl;
  }
}

String? _normalizePreferredWebOrigin(String? currentWebOrigin) {
  final raw = currentWebOrigin?.trim();
  if (raw == null || raw.isEmpty) return null;

  try {
    final url = Uri.parse(raw);
    if (!url.hasScheme || url.host.isEmpty) return null;
    if (url.scheme != 'https') return null;

    final hostname = url.host.toLowerCase();
    if (hostname == 'hable.pages.dev' ||
        hostname.endsWith('.hable.pages.dev')) {
      return '${url.scheme}://${url.host}${url.hasPort ? ':${url.port}' : ''}';
    }
  } catch (_) {
    return null;
  }

  return null;
}
