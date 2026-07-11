import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/usage_tracked_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'social/social_hub_screen.dart';

/// Authenticated three-tab navigation shell for Hable.
///
/// Destinations: Home (daily habits), Social (friends/partners),
/// Profile (identity/history/management).
/// Uses lazy [Offstage] + [TickerMode] to preserve tab state
/// without rebuilding inactive destinations on every switch.
class MainNavigationShell extends StatefulWidget {
  final String userId;

  const MainNavigationShell({super.key, required this.userId});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;
  late final List<Widget?> _destinations = List<Widget?>.filled(3, null);

  /// Key for the Social tab so the shell can request an internal tab switch.
  final _socialKey = GlobalKey<SocialHubScreenState>();

  void _switchToTab(int index, {int? socialSubTab}) {
    setState(() => _selectedIndex = index);
    if (index == 1 && socialSubTab != null) {
      // Post-frame to ensure the Social tab is built before switching.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _socialKey.currentState?.switchToTab(socialSubTab);
      });
    }
  }

  Widget _destinationFor(int index) {
    return _destinations[index] ??= switch (index) {
      0 => HomeScreen(
          userId: widget.userId,
          onOpenActivity: () => _switchToTab(1, socialSubTab: 1),
        ),
      1 => SocialHubScreen(key: _socialKey),
      2 => ProfileScreen(userId: widget.userId),
      _ => HomeScreen(userId: widget.userId),
    };
  }

  @override
  Widget build(BuildContext context) {
    return UsageTrackedScreen(
      screenName: 'main_shell',
      child: PopScope(
        canPop: _selectedIndex == 0,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && _selectedIndex != 0) {
            setState(() => _selectedIndex = 0);
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              for (var index = 0; index < 3; index++)
                Offstage(
                  offstage: _selectedIndex != index,
                  child: TickerMode(
                    enabled: _selectedIndex == index,
                    child: _destinationFor(index),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            backgroundColor: AppTheme.surface,
            indicatorColor: AppTheme.sageGreen.withValues(alpha: 0.18),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.today_outlined),
                selectedIcon: Icon(
                  Icons.today_rounded,
                  color: AppTheme.sageGreen,
                ),
                label: 'Home',
                tooltip: 'Home — today\'s habits',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_alt_outlined),
                selectedIcon: Icon(
                  Icons.people_alt_rounded,
                  color: AppTheme.sageGreen,
                ),
                label: 'Social',
                tooltip: 'Social — friends & partners',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(
                  Icons.person_rounded,
                  color: AppTheme.sageGreen,
                ),
                label: 'Profile',
                tooltip: 'Profile — history & settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
