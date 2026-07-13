import 'package:flutter_test/flutter_test.dart';
import 'package:hable/screens/habit_dashboard_screen.dart';

void main() {
  group('HabitDashboardScreen.columnsForWidth', () {
    test('uses one column on narrow mobile widths', () {
      expect(HabitDashboardScreen.columnsForWidth(480), 1);
      expect(HabitDashboardScreen.columnsForWidth(759), 1);
    });

    test('uses two columns on medium tablet widths', () {
      expect(HabitDashboardScreen.columnsForWidth(760), 2);
      expect(HabitDashboardScreen.columnsForWidth(1099), 2);
    });

    test('uses three columns on standard desktop widths', () {
      expect(HabitDashboardScreen.columnsForWidth(1100), 3);
      expect(HabitDashboardScreen.columnsForWidth(1439), 3);
    });

    test('uses four columns on very wide layouts', () {
      expect(HabitDashboardScreen.columnsForWidth(1440), 4);
      expect(HabitDashboardScreen.columnsForWidth(1800), 4);
    });
  });
}
