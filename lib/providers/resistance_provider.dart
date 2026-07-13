import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'mud_tuning_provider.dart';

part 'resistance_provider.g.dart';

/// Immutable output of the resistance calculation.
/// The UI widget only receives these pre-computed scalars.
class ResistanceState {
  final double resistanceCoefficient;
  final int calculatedDurationMs;

  const ResistanceState({
    required this.resistanceCoefficient,
    required this.calculatedDurationMs,
  });

  static const initial = ResistanceState(
    resistanceCoefficient: 1.0,
    calculatedDurationMs: 1500,
  );
}

typedef ResistanceParams = ({int currentDay, int totalDuration});

/// Isolates the "Mud" physics math from the UI thread.
/// Input: currentDay, totalDuration
/// Output: resistanceCoefficient [0.0–1.0], calculatedDurationMs [400–1500]
@riverpod
class Resistance extends _$Resistance {
  @override
  ResistanceState build(ResistanceParams params) {
    final tuning = ref.watch(mudTuningProvider);
    const maxDurationMs = 1500;
    const minDurationMs = 400;

    if (params.totalDuration <= 0) {
      return ResistanceState.initial;
    }

    double r;
    final int remaining = params.totalDuration - params.currentDay;

    if (params.totalDuration <= 3) {
      // Short duration habits are always in the mastery band
      r = 1.0;
    } else if (remaining <= 3) {
      // Final 3 check-ins are explicitly the mastery band
      r = 1.0;
    } else {
      // Tiered progression for earlier days
      final int nonMasteryDays = params.totalDuration - 3;
      final double progress = (params.currentDay / nonMasteryDays).clamp(
        0.0,
        1.0,
      );

      if (progress < 0.33) {
        // Tier 1: Initial resistance (hard, but not mastery)
        r = 0.8;
      } else if (progress < 0.66) {
        // Tier 2: Developing (moderate)
        r = 0.5;
      } else {
        // Tier 3: Proficient (easiest, just before the mastery spike)
        r = 0.2;
      }
    }

    final tunedResistance = (r + tuning.coefficientDelta).clamp(0.0, 1.0);
    final baseDurationMs =
        (minDurationMs + ((maxDurationMs - minDurationMs) * tunedResistance))
            .toInt();
    final durationMs = (baseDurationMs * tuning.durationMultiplier)
        .round()
        .clamp(minDurationMs, 1800);

    return ResistanceState(
      resistanceCoefficient: tunedResistance,
      calculatedDurationMs: durationMs,
    );
  }
}
