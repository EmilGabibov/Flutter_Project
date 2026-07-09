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
