import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hable/l10n/app_localizations.dart';

import '../providers/auth_provider.dart';
import '../providers/database_provider.dart';
import '../providers/habit_providers.dart';
import '../providers/sync_provider.dart';
import '../screens/auth_screen.dart';
import '../screens/first_run_quote_screen.dart';
import '../screens/main_navigation_shell.dart';
import '../services/app_error.dart';
import '../services/client_reset_service.dart';
import '../services/first_run_quote_gate.dart';
import '../services/local_reminder_service.dart';
import '../services/web_version_gate_service.dart';

/// Routes to AuthScreen if no user exists, otherwise to the three-tab app shell.
class AppGate extends ConsumerStatefulWidget {
  const AppGate({super.key, this.onStartupReady});

  final VoidCallback? onStartupReady;

  @override
  ConsumerState<AppGate> createState() => _AppGateState();
}

class _AppGateState extends ConsumerState<AppGate> with WidgetsBindingObserver {
  String? _lastSyncedUserId;
  final GlobalKey<MainNavigationShellState> _shellKey =
      GlobalKey<MainNavigationShellState>();
  StreamSubscription<String?>? _payloadSub;
  String? _pendingPayload;
  String? _lastPayloadKey;
  DateTime? _lastPayloadAt;
  bool _pendingPayloadFlushScheduled = false;
  WebVersionGateAction _webVersionGateAction = WebVersionGateAction.allow;
  String? _webVersionGateMessage;
  bool _isCheckingFirstRunQuote = false;
  bool _showFirstRunQuoteSplash = false;
  String? _firstRunQuoteUserId;
  bool _startupGuardsResolved = false;
  bool _startupReadySignaled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (kIsWeb) {
      final pathSegments = Uri.base.pathSegments;
      if (pathSegments.isNotEmpty && pathSegments.last == 'social') {
        _pendingPayload = 'social';
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_runStartupGuards());
    });
  }

  Future<void> _runStartupGuards() async {
    var shouldSetUpNotificationHandling = false;
    try {
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
      shouldSetUpNotificationHandling = true;
    } catch (error, stackTrace) {
      debugPrint('Startup guards failed safely: $error\n$stackTrace');
    } finally {
      if (mounted) {
        _startupGuardsResolved = true;
        _signalStartupReadyIfPossible();
      }
    }

    if (shouldSetUpNotificationHandling) {
      try {
        await _setupNotificationTapHandling();
      } catch (error, stackTrace) {
        debugPrint(
          'Notification startup handling failed safely: $error\n$stackTrace',
        );
      }
    }
  }

  void _signalStartupReadyIfPossible([AuthState? authState]) {
    final isAuthInitialized =
        authState?.isInitialized ?? ref.read(authProvider).isInitialized;
    if (_startupReadySignaled ||
        !_startupGuardsResolved ||
        !isAuthInitialized) {
      return;
    }
    _startupReadySignaled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onStartupReady?.call();
    });
  }

  Future<void> _setupNotificationTapHandling() async {
    if (_payloadSub != null) return;
    final localReminder = ref.read(localReminderServiceProvider);

    final initialPayload = await localReminder.getInitialPayload();
    if (initialPayload != null) {
      _queueOrDeliverPayload(initialPayload);
    }

    _payloadSub = localReminder.onPayloadTapped.listen((payload) {
      if (payload != null) _queueOrDeliverPayload(payload);
    });
  }

  bool _isSupportedPayload(String payload) {
    final trimmed = payload.trim();
    if (trimmed == 'home' || trimmed == 'social' || trimmed == 'profile') {
      return true;
    }
    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is! Map<String, dynamic>) return false;
      return resolveNotificationNavigation(actionPayload: decoded) != null;
    } catch (_) {
      return false;
    }
  }

  void _queueOrDeliverPayload(String payload) {
    final trimmed = payload.trim();
    if (trimmed.isEmpty || !_isSupportedPayload(trimmed)) return;

    final now = DateTime.now();
    if (_lastPayloadKey == trimmed &&
        _lastPayloadAt != null &&
        now.difference(_lastPayloadAt!) < const Duration(seconds: 2)) {
      return;
    }
    _lastPayloadKey = trimmed;
    _lastPayloadAt = now;

    final shell = _shellKey.currentState;
    if (shell == null) {
      _pendingPayload ??= trimmed;
      return;
    }
    shell.handleNotificationPayload(trimmed);
  }

  void _schedulePendingPayloadFlush() {
    if (_pendingPayload == null || _pendingPayloadFlushScheduled) return;
    _pendingPayloadFlushScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pendingPayloadFlushScheduled = false;
      if (!mounted || _pendingPayload == null) return;
      final shell = _shellKey.currentState;
      if (shell == null) return;
      final payload = _pendingPayload;
      _pendingPayload = null;
      if (payload != null) shell.handleNotificationPayload(payload);
    });
  }

  void _clearPendingNotificationRoute() {
    _pendingPayload = null;
    _lastPayloadKey = null;
    _lastPayloadAt = null;
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
    final loc = AppLocalizations.of(context);
    _signalStartupReadyIfPossible(authState);

    ref.listen(authProvider, (previous, next) {
      if (previous != null && previous.userId != next.userId) {
        _clearPendingNotificationRoute();
      }
      if ((previous == null || !previous.isAuthenticated) &&
          next.isAuthenticated &&
          next.userId != null) {
        _checkAndStartSync();
      } else if ((previous != null && previous.isAuthenticated) &&
          !next.isAuthenticated) {
        _clearPendingNotificationRoute();
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
                  _webVersionGateMessage ??
                      loc?.appGateUpdatingHable ??
                      'Updating Hable...',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!authState.isInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                loc?.appGateRestoringSession ?? 'Restoring session...',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    if (!authState.isAuthenticated || authState.userId == null) {
      return const AuthScreen();
    }

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
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    loc?.appGatePreparingHabits ?? 'Preparing your habits...',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
        if (_showFirstRunQuoteSplash) {
          return FirstRunQuoteScreen(
            onContinue: () => _dismissFirstRunQuoteSplash(userId),
          );
        }
        _schedulePendingPayloadFlush();
        return MainNavigationShell(key: _shellKey, userId: userId);
      },
      loading: () => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                loc?.appGateLoadingProfileState ?? 'Loading profile state...',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
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
