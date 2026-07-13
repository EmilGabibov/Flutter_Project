import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hable/l10n/app_localizations.dart';
import 'package:hable/l10n/app_localizations.dart';

import '../theme/app_theme.dart';
import '../widgets/usage_tracked_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'social/social_hub_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_reminder_service.dart';

class NotificationNavigationDecision {
  const NotificationNavigationDecision({
    required this.tabIndex,
    this.socialSubTab,
    this.homeHabitId,
  });

  final int tabIndex;
  final int? socialSubTab;
  final String? homeHabitId;
}

NotificationNavigationDecision? resolveNotificationNavigation({
  String? actionRoute,
  String? actionPayloadJson,
  Map<String, dynamic>? actionPayload,
}) {
  Map<String, dynamic>? payload = actionPayload;
  if (payload == null &&
      actionPayloadJson != null &&
      actionPayloadJson.isNotEmpty) {
    try {
      final decoded = jsonDecode(actionPayloadJson);
      if (decoded is Map<String, dynamic>) {
        payload = decoded;
      }
    } catch (_) {
      payload = null;
    }
  }

  switch (actionRoute) {
    case 'profile':
      return const NotificationNavigationDecision(tabIndex: 2);
    case 'social_friends':
    case 'social_requests':
      return const NotificationNavigationDecision(tabIndex: 1, socialSubTab: 0);
    case 'social_inbox':
    case 'social':
      final subTab = payload?['subTab'];
      return NotificationNavigationDecision(
        tabIndex: 1,
        socialSubTab: subTab is int ? subTab : 1,
      );
    case 'home':
      return NotificationNavigationDecision(
        tabIndex: 0,
        homeHabitId: payload?['habit_id']?.toString(),
      );
    default:
      if (payload?['route']?.toString() == 'social') {
        final subTab = payload?['subTab'];
        return NotificationNavigationDecision(
          tabIndex: 1,
          socialSubTab: subTab is int ? subTab : 1,
        );
      }
      if (payload?['route']?.toString() == 'home') {
        return NotificationNavigationDecision(
          tabIndex: 0,
          homeHabitId: payload?['habit_id']?.toString(),
        );
      }
      return null;
  }
}

/// Authenticated three-tab navigation shell for Hable.
///
/// Destinations: Home (daily habits), Social (friends/partners),
/// Profile (identity/history/management).
/// Uses lazy [Offstage] + [TickerMode] to preserve tab state
/// without rebuilding inactive destinations on every switch.
class MainNavigationShell extends ConsumerStatefulWidget {
  final String userId;

  const MainNavigationShell({super.key, required this.userId});

  @override
  ConsumerState<MainNavigationShell> createState() =>
      MainNavigationShellState();
}

class MainNavigationShellState extends ConsumerState<MainNavigationShell> {
  int _selectedIndex = 0;
  late final PageController _pageController;
  late final List<Widget?> _destinations = List<Widget?>.filled(3, null);
  StreamSubscription<String?>? _payloadSubscription;
  String? _homeFocusHabitId;
  int _homeFocusRequestId = 0;

  String? get debugHomeFocusHabitId => _homeFocusHabitId;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);

    _payloadSubscription = ref
        .read(localReminderServiceProvider)
        .onPayloadTapped
        .listen((payload) {
          if (!mounted || payload == null) return;
          handleNotificationPayload(payload);
        });
  }

  @override
  void dispose() {
    _payloadSubscription?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  /// Key for the Social tab so the shell can request an internal tab switch.
  final _socialKey = GlobalKey<SocialHubScreenState>();

  void switchToTab(int index, {int? socialSubTab, String? homeHabitId}) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
    if (index == 1 && socialSubTab != null) {
      // Post-frame to ensure the Social tab is built before switching.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _socialKey.currentState?.switchToTab(socialSubTab);
      });
    }
    if (index == 0 && homeHabitId != null) {
      setState(() {
        _homeFocusHabitId = homeHabitId;
        _homeFocusRequestId += 1;
      });
    }
  }

  void handleNotificationPayload(String payload) {
    if (payload == 'profile') {
      switchToTab(2);
      return;
    }
    if (payload == 'home') {
      switchToTab(0);
      return;
    }
    if (payload == 'social') {
      switchToTab(1, socialSubTab: 1);
      return;
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) return;
      handleNotificationRoute(
        actionRoute: decoded['route']?.toString(),
        actionPayload: decoded,
      );
    } catch (_) {
      // Ignore malformed payloads.
    }
  }

  void handleNotificationRoute({
    String? actionRoute,
    String? actionPayloadJson,
    Map<String, dynamic>? actionPayload,
  }) {
    final decision = resolveNotificationNavigation(
      actionRoute: actionRoute,
      actionPayloadJson: actionPayloadJson,
      actionPayload: actionPayload,
    );
    if (decision == null) return;
    switchToTab(
      decision.tabIndex,
      socialSubTab: decision.socialSubTab,
      homeHabitId: decision.homeHabitId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return UsageTrackedScreen(
      screenName: 'main_shell',
      child: PopScope(
        canPop: _selectedIndex == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && _selectedIndex != 0) {
            switchToTab(0);
          }
        },
        child: Scaffold(
          backgroundColor: AppTheme.surface,
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _KeepAlivePage(
                child: _destinations[0] ??= HomeScreen(
                  userId: widget.userId,
                  onOpenActivity: () => switchToTab(1, socialSubTab: 1),
                  focusedHabitId: _homeFocusHabitId,
                  focusRequestId: _homeFocusRequestId,
                ),
              ),
              _KeepAlivePage(
                child: _destinations[1] ??= SocialHubScreen(key: _socialKey),
              ),
              _KeepAlivePage(
                child: _destinations[2] ??= ProfileScreen(
                  userId: widget.userId,
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.surfaceVariant)),
            ),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.sageGreen,
                    );
                  }
                  return Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppTheme.warmGray,
                  );
                }),
              ),
              child: NavigationBar(
                selectedIndex: _selectedIndex,
                onDestinationSelected: switchToTab,
                backgroundColor: Colors.white,
                indicatorColor: AppTheme.sageGreen.withValues(alpha: 0.15),
                elevation: 0,
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(
                      Icons.home_rounded,
                      color: AppTheme.sageGreen,
                    ),
                    label: loc?.homeTabTitle ?? 'Home',
                    tooltip: loc?.homeTabTitle ?? 'Home',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.people_outline_rounded),
                    selectedIcon: const Icon(
                      Icons.people_rounded,
                      color: AppTheme.sageGreen,
                    ),
                    label: loc?.socialTabTitle ?? 'Social',
                    tooltip: loc?.socialTabTooltip ?? 'Social — friends & partners',
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.person_outline_rounded),
                    selectedIcon: const Icon(
                      Icons.person_rounded,
                      color: AppTheme.sageGreen,
                    ),
                    label: loc?.profileTabTitle ?? 'Profile',
                    tooltip: loc?.profileTabTooltip ?? 'Profile — history & settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KeepAlivePage extends StatefulWidget {
  final Widget child;

  const _KeepAlivePage({required this.child});

  @override
  State<_KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<_KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
