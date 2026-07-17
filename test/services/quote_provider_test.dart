import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hable/database/database.dart';
import 'package:hable/models/daily_quote.dart';
import 'package:hable/data/mascot_reminder_copy.dart';
import 'package:hable/providers/auth_provider.dart';
import 'package:hable/providers/database_provider.dart';
import 'package:hable/providers/quote_provider.dart';

class _SignedOutAuthNotifier extends AuthNotifier {
  @override
  AuthState build() => AuthState(isInitialized: true);
}

void main() {
  test(
    'fresh-start quote pool is broad and stays within the display limit',
    () {
      final quotes = <String>{};

      for (var day = 0; day < 365; day++) {
        final quote = MascotReminderCopyHelper.quoteForContext(
          const CopyPersonalizationContext(),
          now: DateTime.utc(2026, 1, 1).add(Duration(days: day)),
        );
        quotes.add(quote.text);
        expect(
          quote.text.runes.length,
          lessThanOrEqualTo(maxDailyQuoteTextLength),
        );
      }

      expect(quotes.length, greaterThanOrEqualTo(40));
      expect(quotes.any((quote) => quote.contains('Woodrow Wilson')), isTrue);
    },
  );

  test(
    'quote provider uses today\'s synced Drift quote without network work',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      await db.cacheQuote('A synced quote', author: 'Hable Worker');

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          authProvider.overrideWith(_SignedOutAuthNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(quoteProvider.future),
        completion(
          const DailyQuote(text: 'A synced quote', author: 'Hable Worker'),
        ),
      );
    },
  );

  test(
    'quote provider resolves first-party fallback when sync has no quote',
    () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      final container = ProviderContainer(
        overrides: [
          databaseProvider.overrideWithValue(db),
          authProvider.overrideWith(_SignedOutAuthNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      final quote = await container.read(quoteProvider.future);
      expect(quote.text, isNotEmpty);
    },
  );
}
