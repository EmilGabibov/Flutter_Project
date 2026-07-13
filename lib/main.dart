import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hable/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers/auth_provider.dart';
import 'providers/database_provider.dart';
import 'providers/habit_providers.dart';
import 'providers/usage_diagnostics_provider.dart';
import 'providers/sync_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/first_run_quote_screen.dart';
import 'screens/main_navigation_shell.dart';
import 'theme/app_theme.dart';
import 'widgets/usage_tracked_screen.dart';
import 'dart:async';
import 'services/background_sync_service.dart';
import 'services/app_error.dart';
import 'services/client_reset_service.dart';
import 'services/first_run_quote_gate.dart';
import 'services/local_reminder_service.dart';
import 'services/web_version_gate_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BackgroundSyncService().initialize();

  runApp(const ProviderScope(child: HableApp()));
}

class HableApp extends ConsumerWidget {
  const HableApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(usageDiagnosticsProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      title: 'Hable',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('de', ''), // German
        Locale('ur', ''), // Urdu
        Locale('ru', ''), // Russian
        Locale('ta', ''), // Tamil
        Locale('fa', ''), // Persian
      ],
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

class _AppGateState extends ConsumerState<_AppGate>
    with WidgetsBindingObserver {
  String? _lastSyncedUserId;
  final GlobalKey<MainNavigationShellState> _shellKey =
      GlobalKey<MainNavigationShellState>();
  StreamSubscription<String?>? _payloadSub;
  WebVersionGateAction _webVersionGateAction = WebVersionGateAction.allow;
  String? _webVersionGateMessage;
  bool _isCheckingFirstRunQuote = false;
  bool _showFirstRunQuoteSplash = false;
  String? _firstRunQuoteUserId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // On first load, wait for build to finish then trigger sync if logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runStartupGuards();
    });
  }

  Future<void> _runStartupGuards() async {
    final resetResult = await applyForcedClientResetIfNeeded(
      database: ref.read(databaseProvider),
      authNotifier: ref.read(authProvider.notifier),
    );
    if (!mounted) return;
    if (resetResult.didReset) {
      setState(() {
        _lastSyncedUserId = null;
      });
      return;
    }

    await _checkWebVersionGate();
    if (!mounted ||
        _webVersionGateAction == WebVersionGateAction.refreshing ||
        _webVersionGateAction == WebVersionGateAction.blocked) {
      return;
    }
    await _checkAndStartSync();
    await _setupNotificationTapHandling();
  }

  Future<void> _setupNotificationTapHandling() async {
    if (_payloadSub != null) return;
    final localReminder = ref.read(localReminderServiceProvider);

    // Handle initial payload from a cold start
    final initialPayload = await localReminder.getInitialPayload();
    if (initialPayload != null) {
      _handlePayload(initialPayload);
    }

    // Listen to foreground/background taps
    _payloadSub = localReminder.onPayloadTapped.listen((payload) {
      if (payload != null) _handlePayload(payload);
    });
  }

  void _handlePayload(String payloadStr) {
    _shellKey.currentState?.handleNotificationPayload(payloadStr);
  }

  @override
  void dispose() {
    _payloadSub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkAndStartSync() async {
    final authState = ref.read(authProvider);
    final userId = authState.userId;
    if (authState.isAuthenticated && userId != null) {
      if (_lastSyncedUserId != userId) {
        ref.read(databaseProvider).removeSelfFromSocialCaches(userId);
      }
      ref.read(foregroundSyncControllerProvider.notifier).startPolling(userId);
      ref.read(foregroundSyncControllerProvider.notifier).syncNow(userId);

      if (mounted) {
        setState(() {
          _lastSyncedUserId = userId;
        });
      }
    }
  }

  Future<void> _resolveFirstRunQuoteSplash(String userId) async {
    if (_isCheckingFirstRunQuote || _firstRunQuoteUserId == userId) return;
    _isCheckingFirstRunQuote = true;
    final shouldShow = await shouldShowFirstRunQuoteSplash(
      storage: ref.read(secureStorageProvider),
      userId: userId,
    );
    if (!mounted) return;
    setState(() {
      _firstRunQuoteUserId = userId;
      _showFirstRunQuoteSplash = shouldShow;
    });
    _isCheckingFirstRunQuote = false;
  }

  Future<void> _dismissFirstRunQuoteSplash(String userId) async {
    await markFirstRunQuoteSplashSeen(
      storage: ref.read(secureStorageProvider),
      userId: userId,
    );
    if (!mounted) return;
    setState(() {
      _showFirstRunQuoteSplash = false;
    });
  }

  Future<void> _checkWebVersionGate() async {
    final result = await checkWebVersionGate();
    if (!mounted) return;
    setState(() {
      _webVersionGateAction = result.action;
      _webVersionGateMessage = result.message;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runStartupGuards();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      ref.read(foregroundSyncControllerProvider.notifier).stopPolling();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (_webVersionGateAction != WebVersionGateAction.allow) {
      final isBlocking = _webVersionGateAction == WebVersionGateAction.blocked;
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isBlocking) const CircularProgressIndicator(),
                if (!isBlocking) const SizedBox(height: 16),
                Text(
                  _webVersionGateMessage ?? 'Updating Hable...',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!authState.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!authState.isAuthenticated || authState.userId == null) {
      return const AuthScreen();
    }

    // Ensure polling is active when authState updates from unauthenticated to authenticated
    ref.listen(authProvider, (previous, next) {
      if ((previous == null || !previous.isAuthenticated) &&
          next.isAuthenticated &&
          next.userId != null) {
        _checkAndStartSync();
      } else if ((previous != null && previous.isAuthenticated) &&
          !next.isAuthenticated) {
        ref.read(foregroundSyncControllerProvider.notifier).stopPolling();
        if (mounted) {
          setState(() {
            _lastSyncedUserId = null;
            _firstRunQuoteUserId = null;
            _showFirstRunQuoteSplash = false;
          });
        }
      }
    });

    final userAsync = ref.watch(currentUserProvider);
    final userId = authState.userId;
    if (userId == null) {
      return const AuthScreen();
    }

    return userAsync.when(
      data: (_) {
        if (_firstRunQuoteUserId != userId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _resolveFirstRunQuoteSplash(userId);
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (_showFirstRunQuoteSplash) {
          return FirstRunQuoteScreen(
            onContinue: () => _dismissFirstRunQuoteSplash(userId),
          );
        }
        return MainNavigationShell(key: _shellKey, userId: userId);
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              AppError.fromAny(
                err,
                fallbackCode: 'app_gate_load_failed',
                fallbackMessage:
                    'Hable could not finish opening this session just yet.',
                fallbackKind: AppErrorKind.fullscreen,
              ).message,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
