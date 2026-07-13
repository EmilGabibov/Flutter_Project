import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_provider.dart';

enum MudTuningPreset { gentle, standard, intense }

enum MudHapticProfile { soft, standard, strong }

class MudTuningSettings {
  const MudTuningSettings({required this.preset, required this.hapticsEnabled});

  final MudTuningPreset preset;
  final bool hapticsEnabled;

  static const standard = MudTuningSettings(
    preset: MudTuningPreset.standard,
    hapticsEnabled: true,
  );

  double get coefficientDelta {
    return switch (preset) {
      MudTuningPreset.gentle => -0.15,
      MudTuningPreset.standard => 0.0,
      MudTuningPreset.intense => 0.15,
    };
  }

  double get durationMultiplier {
    return switch (preset) {
      MudTuningPreset.gentle => 0.85,
      MudTuningPreset.standard => 1.0,
      MudTuningPreset.intense => 1.15,
    };
  }

  MudHapticProfile get hapticProfile {
    return switch (preset) {
      MudTuningPreset.gentle => MudHapticProfile.soft,
      MudTuningPreset.standard => MudHapticProfile.standard,
      MudTuningPreset.intense => MudHapticProfile.strong,
    };
  }

  MudTuningSettings copyWith({MudTuningPreset? preset, bool? hapticsEnabled}) {
    return MudTuningSettings(
      preset: preset ?? this.preset,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
    );
  }
}

class MudTuningNotifier extends Notifier<MudTuningSettings> {
  String? _loadedUserId;
  int _revision = 0;

  @override
  MudTuningSettings build() {
    final userId = ref.watch(authProvider.select((auth) => auth.userId));
    if (userId == null) {
      _loadedUserId = null;
      return MudTuningSettings.standard;
    }
    if (_loadedUserId != userId) {
      _loadedUserId = userId;
      unawaited(_load(userId));
    }
    return stateOrDefault;
  }

  MudTuningSettings get stateOrDefault {
    return stateOrNull ?? MudTuningSettings.standard;
  }

  MudTuningSettings? get stateOrNull {
    try {
      return state;
    } catch (_) {
      return null;
    }
  }

  Future<void> updatePreset(MudTuningPreset preset) async {
    _revision++;
    state = stateOrDefault.copyWith(preset: preset);
    await _persist();
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    _revision++;
    state = stateOrDefault.copyWith(hapticsEnabled: enabled);
    await _persist();
  }

  Future<void> _load(String userId) async {
    final revision = _revision;
    final prefs = await SharedPreferences.getInstance();
    if (ref.read(authProvider).userId != userId || revision != _revision) {
      return;
    }

    final presetIndex = prefs.getInt(_presetKey(userId));
    final hapticsEnabled = prefs.getBool(_hapticsKey(userId));
    state = MudTuningSettings(
      preset: presetIndex == null
          ? MudTuningPreset.standard
          : MudTuningPreset.values[presetIndex.clamp(
              0,
              MudTuningPreset.values.length - 1,
            )],
      hapticsEnabled: hapticsEnabled ?? true,
    );
  }

  Future<void> _persist() async {
    final userId = ref.read(authProvider).userId;
    if (userId == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_presetKey(userId), state.preset.index);
    await prefs.setBool(_hapticsKey(userId), state.hapticsEnabled);
  }

  String _presetKey(String userId) => 'mud_tuning_preset_$userId';
  String _hapticsKey(String userId) => 'mud_tuning_haptics_$userId';
}

final mudTuningProvider =
    NotifierProvider<MudTuningNotifier, MudTuningSettings>(
      MudTuningNotifier.new,
    );
