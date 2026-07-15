import 'package:flutter_test/flutter_test.dart';
import 'package:hable/data/standard_habits.dart';

void main() {
  test('custom habit emoji prefixes round-trip, including ZWJ emoji', () {
    expect(leadingHabitEmoji('🎨 Sketching'), '🎨');
    expect(stripLeadingHabitEmoji('🎨 Sketching'), 'Sketching');
    expect(leadingHabitEmoji('👩‍💻 Sketching'), '👩‍💻');
    expect(stripLeadingHabitEmoji('👩‍💻 Sketching'), 'Sketching');
  });

  test(
    'standard titles still resolve when their stored title has an emoji',
    () {
      expect(standardHabitForTitle('Hydration')?.title, 'Hydration');
      expect(standardHabitForTitle('💧 Hydration')?.title, 'Hydration');
      expect(standardHabitForTitle('Reading')?.emoji, '📖');
    },
  );
}
