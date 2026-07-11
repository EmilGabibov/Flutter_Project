/// Reusable habit visual state model for UI rendering and animations.
/// Encodes parameters used by difficulty, level, completion, and habit establishment.
enum HabitVisualState {
  idle,           // At rest, unestablished
  pressing,       // During hold/press
  checkInComplete, // Brief confirmation after check-in
  established,    // After successful check-in, stable established state
  skipped,        // When habit is skipped for the day
  missed,         // When habit deadline passed without completion
  nudged,         // When habit owner/partner sends a nudge
}

/// Encapsulates reusable visual parameters for habit icon and ring rendering.
class HabitVisualParameters {
  /// Icon scale at the start of a hold (larger, more transparent)
  final double idleIconScale;

  /// Icon opacity at idle/start
  final double idleIconOpacity;

  /// Icon scale during/after completion (smaller, fully visible)
  final double completedIconScale;

  /// Icon opacity when fully established
  final double completedIconOpacity;

  /// Duration of icon animation from idle to completed (milliseconds)
  final int iconAnimationMs;

  /// Duration of brief done/confirmation state (milliseconds)
  final int completionFlashMs;

  /// Ring thickness at idle
  final double idleRingThickness;

  /// Ring thickness when progressing
  final double progressingRingThickness;

  /// Whether the ring color should change to green on completion
  final bool useGreenOnCompletion;

  const HabitVisualParameters({
    this.idleIconScale = 1.0,
    this.idleIconOpacity = 0.4,
    this.completedIconScale = 0.7,
    this.completedIconOpacity = 1.0,
    this.iconAnimationMs = 400,
    this.completionFlashMs = 200,
    this.idleRingThickness = 6.0,
    this.progressingRingThickness = 12.0,
    this.useGreenOnCompletion = false,
  });

  /// Default parameters for most habits
  static const HabitVisualParameters standard = HabitVisualParameters();

  /// Parameters for high-difficulty habits (thicker ring, faster icon transition)
  static const HabitVisualParameters highDifficulty = HabitVisualParameters(
    idleRingThickness: 8.0,
    progressingRingThickness: 14.0,
    iconAnimationMs: 300,
  );

  /// Parameters for low-difficulty habits (thinner ring, slower animation)
  static const HabitVisualParameters lowDifficulty = HabitVisualParameters(
    idleRingThickness: 4.0,
    progressingRingThickness: 10.0,
    iconAnimationMs: 500,
  );
}


