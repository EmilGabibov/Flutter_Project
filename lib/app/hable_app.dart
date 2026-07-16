import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hable/l10n/app_localizations.dart';

import '../providers/accessibility_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/usage_diagnostics_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/usage_tracked_screen.dart';
import 'app_gate.dart';

class HableApp extends ConsumerWidget {
  const HableApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(usageDiagnosticsProvider);
    final locale = ref.watch(localeProvider);
    final accessibility = ref.watch(accessibilityProvider);
    return MaterialApp(
      title: 'Hable',
      debugShowCheckedModeBanner: false,
      theme: accessibility.highContrast
          ? AppTheme.highContrastTheme
          : AppTheme.lightTheme,
      locale: locale,
      builder: (context, child) {
        final data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaler: accessibility.largerText
                ? const TextScaler.linear(1.3)
                : data.textScaler,
            highContrast: accessibility.highContrast ? true : data.highContrast,
            disableAnimations: accessibility.reducedMotion
                ? true
                : data.disableAnimations,
          ),
          child: child!,
        );
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('de', ''),
        Locale('ur', ''),
        Locale('ru', ''),
        Locale('ta', ''),
        Locale('fa', ''),
      ],
      navigatorObservers: [usageRouteObserver],
      home: const AppGate(),
    );
  }
}
