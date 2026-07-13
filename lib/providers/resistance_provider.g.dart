// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resistance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Isolates the "Mud" physics math from the UI thread.
/// Input: currentDay, totalDuration
/// Output: resistanceCoefficient [0.0–1.0], calculatedDurationMs [400–1500]

@ProviderFor(Resistance)
final resistanceProvider = ResistanceFamily._();

/// Isolates the "Mud" physics math from the UI thread.
/// Input: currentDay, totalDuration
/// Output: resistanceCoefficient [0.0–1.0], calculatedDurationMs [400–1500]
final class ResistanceProvider
    extends $NotifierProvider<Resistance, ResistanceState> {
  /// Isolates the "Mud" physics math from the UI thread.
  /// Input: currentDay, totalDuration
  /// Output: resistanceCoefficient [0.0–1.0], calculatedDurationMs [400–1500]
  ResistanceProvider._({
    required ResistanceFamily super.from,
    required ResistanceParams super.argument,
  }) : super(
         retry: null,
         name: r'resistanceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$resistanceHash();

  @override
  String toString() {
    return r'resistanceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Resistance create() => Resistance();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResistanceState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResistanceState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ResistanceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$resistanceHash() => r'aa453f37fccc62b8022a7e0b04e8924d70995d67';

/// Isolates the "Mud" physics math from the UI thread.
/// Input: currentDay, totalDuration
/// Output: resistanceCoefficient [0.0–1.0], calculatedDurationMs [400–1500]

final class ResistanceFamily extends $Family
    with
        $ClassFamilyOverride<
          Resistance,
          ResistanceState,
          ResistanceState,
          ResistanceState,
          ResistanceParams
        > {
  ResistanceFamily._()
    : super(
        retry: null,
        name: r'resistanceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Isolates the "Mud" physics math from the UI thread.
  /// Input: currentDay, totalDuration
  /// Output: resistanceCoefficient [0.0–1.0], calculatedDurationMs [400–1500]

  ResistanceProvider call(ResistanceParams params) =>
      ResistanceProvider._(argument: params, from: this);

  @override
  String toString() => r'resistanceProvider';
}

/// Isolates the "Mud" physics math from the UI thread.
/// Input: currentDay, totalDuration
/// Output: resistanceCoefficient [0.0–1.0], calculatedDurationMs [400–1500]

abstract class _$Resistance extends $Notifier<ResistanceState> {
  late final _$args = ref.$arg as ResistanceParams;
  ResistanceParams get params => _$args;

  ResistanceState build(ResistanceParams params);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ResistanceState, ResistanceState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ResistanceState, ResistanceState>,
              ResistanceState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
