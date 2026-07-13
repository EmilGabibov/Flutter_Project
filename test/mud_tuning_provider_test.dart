import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/providers/auth_provider.dart';
import 'package:hable/providers/mud_tuning_provider.dart';
import 'package:hable/providers/resistance_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(this._authState);

  final AuthState _authState;

  @override
  AuthState build() => _authState;
}

class FixedMudTuningNotifier extends MudTuningNotifier {
  FixedMudTuningNotifier(this._settings);

  final MudTuningSettings _settings;

  @override
  MudTuningSettings build() => _settings;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ProviderContainer buildContainer() {
    return ProviderContainer(
      overrides: [
        authProvider.overrideWith(
          () => FakeAuthNotifier(
            AuthState(
              isInitialized: true,
              token: 'token',
              userId: 'user-1',
              username: 'Alice',
            ),
          ),
        ),
      ],
    );
  }

  test('mud tuning preferences persist per signed-in user', () async {
    final container = buildContainer();
    addTearDown(container.dispose);

    expect(container.read(mudTuningProvider).preset, MudTuningPreset.standard);
    await container
        .read(mudTuningProvider.notifier)
        .updatePreset(MudTuningPreset.gentle);
    await container.read(mudTuningProvider.notifier).setHapticsEnabled(false);

    final reloaded = buildContainer();
    addTearDown(reloaded.dispose);
    reloaded.read(mudTuningProvider);
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    expect(reloaded.read(mudTuningProvider).preset, MudTuningPreset.gentle);
    expect(reloaded.read(mudTuningProvider).hapticsEnabled, isFalse);
  });

  test('resistance provider applies tuning preset deltas', () {
    final container = ProviderContainer(
      overrides: [
        mudTuningProvider.overrideWith(
          () => FixedMudTuningNotifier(
            const MudTuningSettings(
              preset: MudTuningPreset.intense,
              hapticsEnabled: true,
            ),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);

    final state = container.read(
      resistanceProvider((currentDay: 1, totalDuration: 10)),
    );
    expect(state.resistanceCoefficient, closeTo(0.95, 0.000001));
    expect(state.calculatedDurationMs, greaterThan(1280));
  });
}
