import 'package:flutter/material.dart';
import 'package:hable/l10n/app_localizations.dart';

MaterialApp buildHableTestApp({required Widget home, ThemeData? theme}) {
  return MaterialApp(
    theme: theme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}
