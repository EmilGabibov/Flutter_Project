import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/providers/mud_tuning_provider.dart';
import 'package:hable/providers/resistance_provider.dart';

class _FixedMudTuningNotifier extends MudTuningNotifier {
  _FixedMudTuningNotifier(this._settings);

  final MudTuningSettings _settings;

  @override
  MudTuningSettings build() => _settings;
}

void main() {
  ProviderContainer buildContainer() {
    return ProviderContainer(
      overrides: [
        mudTuningProvider.overrideWith(
          () => _FixedMudTuningNotifier(MudTuningSettings.standard),
        ),
      ],
    );
  }

  test(
    'resistanceProvider computes initial state for invalid totalDuration',
    () {
      final container = buildContainer();
      addTearDown(container.dispose);

      final state = container.read(
        resistanceProvider((currentDay: 1, totalDuration: 0)),
      );
      expect(state.resistanceCoefficient, 1.0);
      expect(state.calculatedDurationMs, 1500);
    },
  );

  test('resistanceProvider computes correct duration for early day', () {
    final container = buildContainer();
    addTearDown(container.dispose);

    final state = container.read(
      resistanceProvider((currentDay: 1, totalDuration: 10)),
    );
    // Tier 1: 0.8
    expect(state.resistanceCoefficient, 0.8);
    expect(state.calculatedDurationMs, 1280);
  });

  test('resistanceProvider computes correct duration for mid journey', () {
    final container = buildContainer();
    addTearDown(container.dispose);

    final state = container.read(
      resistanceProvider((currentDay: 5, totalDuration: 10)),
    );
    // Tier 3: 0.2
    expect(state.resistanceCoefficient, 0.2);
    expect(state.calculatedDurationMs, 620);
  });

  test('resistanceProvider computes correct duration for final day', () {
    final container = buildContainer();
    addTearDown(container.dispose);

    final state = container.read(
      resistanceProvider((currentDay: 10, totalDuration: 10)),
    );
    // Mastery: 1.0
    expect(state.resistanceCoefficient, 1.0);
    expect(state.calculatedDurationMs, 1500);
  });

  test('resistanceProvider clamps currentDay exceeding totalDuration', () {
    final container = buildContainer();
    addTearDown(container.dispose);

    final state = container.read(
      resistanceProvider((currentDay: 15, totalDuration: 10)),
    );
    // Mastery: 1.0
    expect(state.resistanceCoefficient, 1.0);
    expect(state.calculatedDurationMs, 1500);
  });

  test('resistanceProvider clamps negative currentDay', () {
    final container = buildContainer();
    addTearDown(container.dispose);

    final state = container.read(
      resistanceProvider((currentDay: -5, totalDuration: 10)),
    );
    // Tier 1: 0.8
    expect(state.resistanceCoefficient, 0.8);
    expect(state.calculatedDurationMs, 1280);
  });
}
