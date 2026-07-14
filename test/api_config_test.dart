import 'package:flutter_test/flutter_test.dart';
import 'package:hable/config/api_config.dart';

void main() {
  group('resolveAppEnvironment', () {
    test('uses provided local aliases', () {
      expect(
        resolveAppEnvironment(
          rawEnvironment: 'local',
          defaultEnvironment: HableAppEnvironment.production,
        ),
        HableAppEnvironment.local,
      );
      expect(
        resolveAppEnvironment(
          rawEnvironment: 'development',
          defaultEnvironment: HableAppEnvironment.production,
        ),
        HableAppEnvironment.local,
      );
    });

    test('uses provided staging and production aliases', () {
      expect(
        resolveAppEnvironment(
          rawEnvironment: 'staging',
          defaultEnvironment: HableAppEnvironment.local,
        ),
        HableAppEnvironment.staging,
      );
      expect(
        resolveAppEnvironment(
          rawEnvironment: 'prod',
          defaultEnvironment: HableAppEnvironment.local,
        ),
        HableAppEnvironment.production,
      );
    });

    test('falls back to the supplied default for empty or invalid values', () {
      expect(
        resolveAppEnvironment(
          rawEnvironment: '',
          defaultEnvironment: HableAppEnvironment.local,
        ),
        HableAppEnvironment.local,
      );
      expect(
        resolveAppEnvironment(
          rawEnvironment: 'qa',
          defaultEnvironment: HableAppEnvironment.production,
        ),
        HableAppEnvironment.production,
      );
    });
  });

  group('resolveApiBaseUrl', () {
    test('manual api override takes precedence over environment presets', () {
      expect(
        resolveApiBaseUrl(
          apiBaseOverride: 'https://custom.example.com',
          environment: HableAppEnvironment.local,
          stagingApiBaseUrl: 'https://staging.example.com',
        ),
        'https://custom.example.com',
      );
    });

    test('local and production environments resolve to canonical urls', () {
      expect(
        resolveApiBaseUrl(
          apiBaseOverride: '',
          environment: HableAppEnvironment.local,
        ),
        localApiBaseUrl,
      );
      expect(
        resolveApiBaseUrl(
          apiBaseOverride: '',
          environment: HableAppEnvironment.production,
        ),
        productionApiBaseUrl,
      );
    });

    test('web production prefers the current hable pages origin', () {
      expect(
        resolveApiBaseUrl(
          apiBaseOverride: '',
          environment: HableAppEnvironment.production,
          currentWebOrigin: 'https://preview-123.hable.pages.dev',
        ),
        'https://preview-123.hable.pages.dev',
      );
    });

    test('web production ignores non-hable or non-https origins', () {
      expect(
        resolveApiBaseUrl(
          apiBaseOverride: '',
          environment: HableAppEnvironment.production,
          currentWebOrigin: 'http://localhost:8080',
        ),
        productionApiBaseUrl,
      );
      expect(
        resolveApiBaseUrl(
          apiBaseOverride: '',
          environment: HableAppEnvironment.production,
          currentWebOrigin: 'https://example.com',
        ),
        productionApiBaseUrl,
      );
    });

    test('production presentation builds never resolve to localhost', () {
      final url = resolveApiBaseUrl(
        apiBaseOverride: '',
        environment: HableAppEnvironment.production,
      );

      expect(url, startsWith('https://'));
      expect(url, isNot(contains('localhost')));
      expect(url, isNot(contains('127.0.0.1')));
      expect(url, isNot(contains('10.0.2.2')));
    });

    test('staging uses the staging override when provided', () {
      expect(
        resolveApiBaseUrl(
          apiBaseOverride: '',
          environment: HableAppEnvironment.staging,
          stagingApiBaseUrl: 'https://staging.example.com',
        ),
        'https://staging.example.com',
      );
    });

    test(
      'staging falls back to production when no staging url is configured',
      () {
        expect(
          resolveApiBaseUrl(
            apiBaseOverride: '',
            environment: HableAppEnvironment.staging,
          ),
          productionApiBaseUrl,
        );
      },
    );
  });
}
