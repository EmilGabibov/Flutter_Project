import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import 'web_runtime_version_stub.dart'
    if (dart.library.html) 'web_runtime_version_web.dart';

enum WebVersionGateAction { allow, refreshing, blocked }

class WebVersionGateResult {
  const WebVersionGateResult({required this.action, this.message});

  final WebVersionGateAction action;
  final String? message;
}

class DeployedWebVersionStatus {
  const DeployedWebVersionStatus({
    required this.currentServiceWorkerVersion,
    required this.minSupportedServiceWorkerVersion,
  });

  final String? currentServiceWorkerVersion;
  final String? minSupportedServiceWorkerVersion;
}

int compareBuildIdentifiers(String left, String right) {
  final leftInt = int.tryParse(left);
  final rightInt = int.tryParse(right);
  if (leftInt != null && rightInt != null) {
    return leftInt.compareTo(rightInt);
  }
  return left.compareTo(right);
}

Future<DeployedWebVersionStatus?> _fetchDeployedWebVersionStatus() async {
  final uri = Uri.parse('$apiBaseUrl/api/app/version-status').replace(
    queryParameters: {'t': DateTime.now().millisecondsSinceEpoch.toString()},
  );

  final response = await http.get(uri);
  if (response.statusCode != 200) return null;

  final data = jsonDecode(response.body);
  if (data is! Map<String, dynamic>) return null;

  return DeployedWebVersionStatus(
    currentServiceWorkerVersion: data['current_service_worker_version']
        ?.toString(),
    minSupportedServiceWorkerVersion:
        data['min_supported_service_worker_version']?.toString(),
  );
}

Future<WebVersionGateResult> checkWebVersionGate() async {
  if (!kIsWeb) {
    return const WebVersionGateResult(action: WebVersionGateAction.allow);
  }

  try {
    final loadedVersion = await getLoadedServiceWorkerVersion();
    if (loadedVersion == null || loadedVersion.isEmpty) {
      return const WebVersionGateResult(action: WebVersionGateAction.allow);
    }

    final deployed = await _fetchDeployedWebVersionStatus();
    final latestVersion = deployed?.currentServiceWorkerVersion?.trim();
    final minSupportedVersion = deployed?.minSupportedServiceWorkerVersion
        ?.trim();

    if (latestVersion == null || latestVersion.isEmpty) {
      return const WebVersionGateResult(action: WebVersionGateAction.allow);
    }

    if (minSupportedVersion != null &&
        minSupportedVersion.isNotEmpty &&
        compareBuildIdentifiers(loadedVersion, minSupportedVersion) < 0) {
      final alreadyAttempted = await hasReloadAttemptForVersion(latestVersion);
      if (!alreadyAttempted) {
        await rememberReloadAttemptForVersion(latestVersion);
        await hardReloadToVersion(latestVersion);
        return const WebVersionGateResult(
          action: WebVersionGateAction.refreshing,
          message: 'Applying a required web update...',
        );
      }

      return const WebVersionGateResult(
        action: WebVersionGateAction.blocked,
        message:
            'This browser tab is running an older unsupported Hable web build. Hard refresh the page or reopen Hable.',
      );
    }

    if (loadedVersion != latestVersion) {
      final alreadyAttempted = await hasReloadAttemptForVersion(latestVersion);
      if (!alreadyAttempted) {
        await rememberReloadAttemptForVersion(latestVersion);
        await hardReloadToVersion(latestVersion);
        return const WebVersionGateResult(
          action: WebVersionGateAction.refreshing,
          message: 'Refreshing to the latest Hable web build...',
        );
      }

      return const WebVersionGateResult(
        action: WebVersionGateAction.blocked,
        message:
            'A newer Hable web build is available, but this tab is still serving an older cached copy. Hard refresh the page or reopen Hable.',
      );
    }

    await clearReloadAttempt();
    return const WebVersionGateResult(action: WebVersionGateAction.allow);
  } catch (error) {
    debugPrint('Web version gate check failed: $error');
    return const WebVersionGateResult(action: WebVersionGateAction.allow);
  }
}
