import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hable/widgets/leaderboard_card.dart';

void main() {
  test('LeaderboardEntry parses API rows', () {
    final entry = LeaderboardEntry.fromJson({
      'id': 'u-1',
      'username': 'Ava',
      'avatar_url': '🏆',
      'level_name': 'Gold',
      'total_score': '289400',
    }, 1);

    expect(entry.userId, 'u-1');
    expect(entry.userName, 'Ava');
    expect(entry.avatarUrl, '🏆');
    expect(entry.levelName, 'Gold');
    expect(entry.rank, 1);
    expect(entry.score, 289400);
    expect(entry.scoreLabel, '289,400');
  });

  testWidgets('LeaderboardCard renders podium, current user, and more rows', (
    tester,
  ) async {
    final entries = List.generate(
      11,
      (index) => LeaderboardEntry(
        userId: 'u-${index + 1}',
        userName: 'User ${index + 1}',
        avatarUrl: '🏆',
        rank: index + 1,
        score: 300000 - (index * 10000),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(splashFactory: NoSplash.splashFactory),
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LeaderboardCard(
                title: 'Points Leaderboard',
                scopeLabel: 'Friends',
                rankings: entries,
                currentUserId: 'u-5',
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Points Leaderboard'), findsOneWidget);
    expect(find.text('Friends'), findsOneWidget);
    expect(find.text('#1'), findsWidgets);
    expect(find.text('User 1'), findsWidgets);
    expect(find.text('You'), findsOneWidget);
    expect(find.text('Show 1 more'), findsOneWidget);
    expect(find.text('User 11'), findsNothing);

    await tester.ensureVisible(find.text('Show 1 more'));
    await tester.tap(find.text('Show 1 more'));
    await tester.pump();

    expect(find.text('User 11'), findsOneWidget);
    expect(find.text('Showing all 11'), findsOneWidget);
  });
}
