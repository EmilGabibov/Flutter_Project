import 'package:flutter_riverpod/flutter_riverpod.dart';

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
final resistanceProvider = Provider.family<ResistanceState, ResistanceParams>((ref, params) {
  const maxDurationMs = 1500;
  const minDurationMs = 400;

  if (params.totalDuration <= 0) {
    return ResistanceState.initial;
  }

  final r = (1.0 - (params.currentDay / params.totalDuration)).clamp(0.0, 1.0);
  final durationMs =
      (minDurationMs + ((maxDurationMs - minDurationMs) * r)).toInt();

  return ResistanceState(
    resistanceCoefficient: r,
    calculatedDurationMs: durationMs,
  );
});
