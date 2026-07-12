import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import 'providers/database_provider.dart';
import 'providers/habit_providers.dart';
import 'providers/usage_diagnostics_provider.dart';
import 'providers/sync_provider.dart';
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
class _AppGate extends ConsumerStatefulWidget {
  const _AppGate();

  @override
  ConsumerState<_AppGate> createState() => _AppGateState();
}

class _AppGateState extends ConsumerState<_AppGate> with WidgetsBindingObserver {
  bool _initialSyncCompleted = false;
  String? _lastSyncedUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // On first load, wait for build to finish then trigger sync if logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStartSync();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkAndStartSync() async {
    final authState = ref.read(authProvider);
    if (authState.isAuthenticated && authState.userId != null) {
      if (_lastSyncedUserId != authState.userId) {
        if (mounted) {
          setState(() {
            _initialSyncCompleted = false;
          });
        }
      }
      ref.read(databaseProvider).removeSelfFromSocialCaches(authState.userId!);
      ref.read(foregroundSyncControllerProvider.notifier).startPolling(authState.userId!);
      await ref.read(foregroundSyncControllerProvider.notifier).syncNow(authState.userId!);
      
      if (mounted) {
        setState(() {
          _initialSyncCompleted = true;
          _lastSyncedUserId = authState.userId;
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndStartSync();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      ref.read(foregroundSyncControllerProvider.notifier).stopPolling();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (!authState.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!authState.isAuthenticated || authState.userId == null) {
      return const AuthScreen();
    }

    // Ensure polling is active when authState updates from unauthenticated to authenticated
    ref.listen(authProvider, (previous, next) {
      if ((previous == null || !previous.isAuthenticated) && next.isAuthenticated && next.userId != null) {
         _checkAndStartSync();
      } else if ((previous != null && previous.isAuthenticated) && !next.isAuthenticated) {
         ref.read(foregroundSyncControllerProvider.notifier).stopPolling();
         if (mounted) {
           setState(() {
             _initialSyncCompleted = false;
             _lastSyncedUserId = null;
           });
         }
      }
    });

    if (!_initialSyncCompleted) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
