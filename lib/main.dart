import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import 'providers/habit_providers.dart';
import 'providers/usage_diagnostics_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/main_navigation_shell.dart';
import 'theme/app_theme.dart';
import 'widgets/usage_tracked_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: HableApp()));
}

class HableApp extends ConsumerWidget {
  const HableApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(usageDiagnosticsProvider);
    return MaterialApp(
      title: 'Hable',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorObservers: [usageRouteObserver],
      home: const _AppGate(),
    );
  }
}

/// Routes to AuthScreen if no user exists, otherwise to the three-tab app shell.
class _AppGate extends ConsumerWidget {
  const _AppGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (!authState.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!authState.isAuthenticated || authState.userId == null) {
      return const AuthScreen();
    }

    final userAsync = ref.watch(currentUserProvider);
    return userAsync.when(
      data: (_) => MainNavigationShell(userId: authState.userId!),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}
