import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilitySettings {
  final bool reducedMotion;
  final bool highContrast;
  final bool largerText;

  const AccessibilitySettings({
    this.reducedMotion = false,
    this.highContrast = false,
    this.largerText = false,
  });

  AccessibilitySettings copyWith({
    bool? reducedMotion,
    bool? highContrast,
    bool? largerText,
  }) {
    return AccessibilitySettings(
      reducedMotion: reducedMotion ?? this.reducedMotion,
      highContrast: highContrast ?? this.highContrast,
      largerText: largerText ?? this.largerText,
    );
  }
}

final accessibilityProvider =
    NotifierProvider<AccessibilityNotifier, AccessibilitySettings>(() {
  return AccessibilityNotifier();
});

class AccessibilityNotifier extends Notifier<AccessibilitySettings> {
  static const _reducedMotionKey = 'hable_reduced_motion';
  static const _highContrastKey = 'hable_high_contrast';
  static const _largerTextKey = 'hable_larger_text';

  @override
  AccessibilitySettings build() {
    _loadSettings();
    return const AccessibilitySettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final reducedMotion = prefs.getBool(_reducedMotionKey) ?? false;
    final highContrast = prefs.getBool(_highContrastKey) ?? false;
    final largerText = prefs.getBool(_largerTextKey) ?? false;
    
    state = AccessibilitySettings(
      reducedMotion: reducedMotion,
      highContrast: highContrast,
      largerText: largerText,
    );
  }

  Future<void> toggleReducedMotion(bool value) async {
    state = state.copyWith(reducedMotion: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_reducedMotionKey, value);
  }

  Future<void> toggleHighContrast(bool value) async {
    state = state.copyWith(highContrast: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_highContrastKey, value);
  }

  Future<void> toggleLargerText(bool value) async {
    state = state.copyWith(largerText: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_largerTextKey, value);
  }
}
