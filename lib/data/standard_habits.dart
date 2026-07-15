class StandardHabit {
  final String emoji;
  final String title;
  final String subtitle;
  final int defaultDurationDays;
  final bool isCustom;
  final String? colorHex;

  const StandardHabit({
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.defaultDurationDays = 21,
    this.isCustom = false,
    this.colorHex,
  });
}

const standardHabits = [
  StandardHabit(
    emoji: '💧',
    title: 'Hydration',
    subtitle: 'Drink 8 glasses of water daily',
    colorHex: 'FF67E8F9',
  ),
  StandardHabit(
    emoji: '📖',
    title: 'Reading',
    subtitle: 'Read for 20 minutes every day',
    colorHex: 'FFA5B4FC',
  ),
  StandardHabit(
    emoji: '🧘',
    title: 'Meditation',
    subtitle: '10 minutes of mindfulness',
    colorHex: 'FF9CAF88',
  ),
  StandardHabit(
    emoji: '🏃',
    title: 'Exercise',
    subtitle: '30 minutes of movement',
    colorHex: 'FFFB7185',
  ),
  StandardHabit(
    emoji: '😴',
    title: 'Sleep Routine',
    subtitle: 'In bed by 10:30 PM',
    colorHex: 'FFC4B5D4',
  ),
  StandardHabit(
    emoji: '📝',
    title: 'Journaling',
    subtitle: 'Write 3 things you\'re grateful for',
    colorHex: 'FFFBBF24',
  ),
];

StandardHabit? standardHabitForTitle(String title) {
  final normalized = _normalizeHabitTitle(title);
  for (final habit in standardHabits) {
    if (_normalizeHabitTitle(habit.title) == normalized) {
      return habit;
    }
  }
  return null;
}

/// Returns the emoji prefix Hable persists for a custom habit title.
///
/// The form stores custom emoji with the title so the existing Drift and sync
/// payloads can round-trip it without a separate field. Keep parsing here so
/// every surface interprets that persisted representation identically.
String? leadingHabitEmoji(String title) {
  final match = _leadingHabitEmoji.firstMatch(title);
  return match?.group(1);
}

/// Removes a persisted custom-habit emoji prefix from a user-facing title.
String stripLeadingHabitEmoji(String title) {
  return title.replaceFirst(_leadingHabitEmoji, '').trim();
}

String _normalizeHabitTitle(String title) {
  return stripLeadingHabitEmoji(title).toLowerCase();
}

// Supports the picker’s regular, keycap, flag, skin-tone, and ZWJ emoji
// sequences while remaining deliberately limited to a leading title prefix.
final _leadingHabitEmoji = RegExp(
  r'^\s*((?:[#*0-9]\u{FE0F}?\u{20E3}|[\u{1F1E6}-\u{1F1FF}]{2}|[\u{1F000}-\u{1FAFF}\u{2600}-\u{27BF}]\u{FE0F}?[\u{1F3FB}-\u{1F3FF}]?(?:\u{200D}[\u{1F000}-\u{1FAFF}\u{2600}-\u{27BF}]\u{FE0F}?[\u{1F3FB}-\u{1F3FF}]?)*))\s*',
  unicode: true,
);

String? standardHabitDescriptionForTitle(String title) {
  return standardHabitForTitle(title)?.subtitle;
}
