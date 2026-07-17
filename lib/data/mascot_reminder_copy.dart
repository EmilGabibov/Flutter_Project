import '../database/tables.dart';
import '../models/daily_quote.dart';
import 'fallback_quotes.dart';

class ReminderCopy {
  final String title;
  final String body;

  const ReminderCopy(this.title, this.body);
}

class CopyPersonalizationContext {
  final bool hasActiveHabits;
  final bool hasRecentSkip;
  final int longestStreak;
  final int recentNudgeCount;
  final int partnerCompletionsToday;
  final int completedTodayCount;

  const CopyPersonalizationContext({
    this.hasActiveHabits = false,
    this.hasRecentSkip = false,
    this.longestStreak = 0,
    this.recentNudgeCount = 0,
    this.partnerCompletionsToday = 0,
    this.completedTodayCount = 0,
  });

  bool get hasSocialMomentum =>
      recentNudgeCount > 0 || partnerCompletionsToday > 0;
}

class MascotReminderCopyHelper {
  static ReminderCopy getCopyForType(
    ReminderType type, {
    DateTime? now,
    CopyPersonalizationContext context = const CopyPersonalizationContext(),
  }) {
    final date = now ?? DateTime.now();
    final seed = date.year * 1000 + date.month * 100 + date.day;

    switch (type) {
      case ReminderType.dailyHabit:
        return _dailyHabitCopyForContext(context, date, seed);
    }
  }

  static DailyQuote quoteForContext(
    CopyPersonalizationContext context, {
    DateTime? now,
  }) {
    final date = now ?? DateTime.now();
    final seed = date.year * 1000 + date.month * 100 + date.day;

    if (context.hasRecentSkip) {
      return DailyQuote(
        text: _recentSkipQuotes[seed % _recentSkipQuotes.length],
      );
    }
    if (context.hasSocialMomentum) {
      return DailyQuote(
        text: _socialMomentumQuotes[seed % _socialMomentumQuotes.length],
      );
    }
    if (context.longestStreak >= 7) {
      return DailyQuote(text: _streakQuotes[seed % _streakQuotes.length]);
    }
    if (!context.hasActiveHabits) {
      return DailyQuote(
        text: _freshStartQuotes[seed % _freshStartQuotes.length],
      );
    }

    return fallbackQuoteForSeed(seed);
  }

  static ReminderCopy _dailyHabitCopyForContext(
    CopyPersonalizationContext context,
    DateTime date,
    int seed,
  ) {
    if (context.hasRecentSkip) {
      return _recentSkipReminderCopies[seed % _recentSkipReminderCopies.length];
    }
    if (context.hasSocialMomentum) {
      return _socialReminderCopies[seed % _socialReminderCopies.length];
    }
    if (context.longestStreak >= 7) {
      return _streakReminderCopies[seed % _streakReminderCopies.length];
    }
    if (date.hour < 9) {
      return _earlyReminderCopies[seed % _earlyReminderCopies.length];
    }
    if (date.hour >= 21) {
      return _lateReminderCopies[seed % _lateReminderCopies.length];
    }
    return _dailyHabitCopies[seed % _dailyHabitCopies.length];
  }

  static const _dailyHabitCopies = [
    ReminderCopy('Hable time!', 'Open Hable and check today\'s habits.'),
    ReminderCopy('Your daily check-in', 'Take a moment for your habits.'),
    ReminderCopy('Stay on track', 'Don\'t forget your daily habits!'),
    ReminderCopy('Habit time!', 'Let\'s get those habits done.'),
    ReminderCopy('A gentle nudge', 'Time to review your daily goals.'),
  ];

  static const _earlyReminderCopies = [
    ReminderCopy(
      'Start softly',
      'A small morning check-in can steady the day.',
    ),
    ReminderCopy('Before the rush', 'Take a quiet moment for today\'s habit.'),
  ];

  static const _lateReminderCopies = [
    ReminderCopy('Close the loop', 'There is still time to land today well.'),
    ReminderCopy(
      'One calm check-in',
      'A quick habit review can finish the day.',
    ),
  ];

  static const _recentSkipReminderCopies = [
    ReminderCopy('Pick it back up', 'Yesterday slipped. Today still counts.'),
    ReminderCopy(
      'Reset the rhythm',
      'One check-in is enough to restart momentum.',
    ),
  ];

  static const _socialReminderCopies = [
    ReminderCopy(
      'Your circle is moving',
      'A partner touched base. Meet them in today\'s check-in.',
    ),
    ReminderCopy(
      'Shared momentum',
      'Someone around you is active. Add your check-in too.',
    ),
  ];

  static const _streakReminderCopies = [
    ReminderCopy(
      'Keep the streak warm',
      'You have momentum. Protect it with today\'s check-in.',
    ),
    ReminderCopy('Streak in motion', 'A quick check-in keeps your run alive.'),
  ];

  static const _recentSkipQuotes = [
    'I have not failed. I\'ve just found 10,000 ways that won\'t work. - Thomas Edison',
    'If we all did the things we are capable of doing, we would literally astound ourselves. - Thomas Edison',
    'Genius is one per cent inspiration, ninety-nine per cent perspiration. - Thomas Edison',
    'I am bound to be true, and to live by the light that I have. - Abraham Lincoln',
    'To improve is to change; to be perfect is to change often. - Winston Churchill',
    'It is no use saying, \'We are doing our best.\' You have got to succeed in doing what is necessary. - Winston Churchill',
    'If you\'re going through hell, keep going. - Winston Churchill',
    'There\'s power in looking silly and not caring that you do. - Amy Poehler',
    'If you\'re changing the world, you\'re working on important things. You\'re excited to get up in the morning. - Larry Page',
    'In times of change, learners inherit the earth, while the learned find themselves beautifully equipped to deal with a world that no longer exists. - Eric Hoffer',
    'Whether you think you can or you think you can\'t, you are right. - Henry Ford',
    'The one thing nobody else has is you: your voice, your mind, your story, and your vision. Live as only you can. - Neil Gaiman',
    'The biggest room in the world is room for improvement. - Helmut Schmidt',
    'In the middle of every difficulty lies opportunity. - Albert Einstein',
    'Every great dream begins with a dreamer. You have the strength, patience, and passion to reach for the stars and change the world. - Harriet Tubman',
    'Creative people are the luckiest people on earth. Do what you love, and you will find the way to get it out to the world. - Judy Collins',
    'Obstacles don\'t have to stop you. Figure out how to climb the wall, go through it, or work around it. - Michael Jordan',
    'It always seems impossible until it\'s done. - Nelson Mandela',
  ];

  static const _socialMomentumQuotes = [
    'Optimism is the faith that leads to achievement. Nothing can be done without hope and confidence. - Helen Keller',
    'Good, better, best. Never let it rest. ‘Til your good is better and your better is best. - Jerome',
    'Accept the challenges so that you can feel the exhilaration of victory. - George S. Patton',
    'We should not give up and we should not allow the problem to defeat us. - A. P. J. Abdul Kalam',
    'Difficulties increase the nearer we get to the goal. - Johann Wolfgang von Goethe',
    'Only I can change my life. No one can do it for me. - Carol Burnett',
    'If you want to succeed you should strike out on new paths, rather than travel the worn paths of accepted success. - John Locke',
    'There is nothing impossible to him who will try. - Alexander the Great',
    'I\'ll prepare and someday my chance will come. - Abraham Lincoln',
    'A person who never made a mistake never tried anything new. - Albert Einstein',
    'With the new day comes new strength and new thoughts. - Eleanor Roosevelt',
    'The dream was always running ahead of me. To catch up, to live for a moment in unison with it, that was the miracle. - Anaïs Nin',
    'If you aren\'t going all the way, why go at all? - Joe Namath',
    'Let us sacrifice our today so that our children can have a better tomorrow. - A. P. J. Abdul Kalam',
    'The more man meditates upon good thoughts, the better will be his world and the world at large. - Confucius',
    'Keep your eyes on the stars and your feet on the ground. - Theodore Roosevelt',
    'By failing to prepare, you are preparing to fail. - Benjamin Franklin',
    'Learning is the beginning of wealth, health, and spirituality. Searching and learning is where the miracle process begins. - Jim Rohn',
  ];

  static const _streakQuotes = [
    'Do the difficult things while they are easy and do the great things while they are small. A journey of a thousand miles must begin with a single step. - Laozi',
    'Our greatest weakness lies in giving up. The most certain way to succeed is always to try just one more time. - Thomas Edison',
    'Without hard work, nothing grows but weeds. - Gordon Hinckley',
    'Life is 10% what happens to you and 90% how you react to it. - Chuck Swindoll',
    'Quality is not an act; it is a habit. - Aristotle',
    'Difficulties are meant to rouse, not discourage. The human spirit is to grow strong by conflict. - William Ellery Channing',
    'Treat everyone you meet with care, kindness, and understanding, expecting no reward. Your life will never be the same. - Og Mandino',
    'Go for it now. The future is promised to no one. - Wayne Dyer',
    'Mountains cannot be surmounted except by winding paths. - Johann Wolfgang von Goethe',
    'The will to win, the desire to succeed, the urge to reach your full potential... these are the keys that will unlock the door to personal excellence. - Confucius',
    'I\'d rather attempt to do something great and fail than to attempt to do nothing and succeed. - Robert Schuller',
    'If you can dream it, you can do it. - Walt Disney',
    'I can, therefore I am. - Simone Weil',
    'You can\'t cross the sea merely by standing and staring at the water. - Rabindranath Tagore',
    'Failure will never overtake me if my determination to succeed is strong enough. - Og Mandino',
    'The secret of getting ahead is getting started. - Mark Twain',
    'Motivation is the art of getting people to do what you want them to do because they want to do it. - Dwight D. Eisenhower',
    'There is no passion to be found playing small - in settling for a life that is less than the one you are capable of living. - Nelson Mandela',
  ];

  static const _freshStartQuotes = [
    'I know not age, nor weariness nor defeat. - Rose Kennedy',
    'Do not wait; the time will never be \'just right.\' Start where you stand, and better tools will be found as you go along. - George Herbert',
    'Believe in yourself! Have faith in your abilities! Without a humble but reasonable confidence in your own powers you cannot be successful or happy. - Norman Vincent Peale',
    'Set your goals high, and don\'t stop till you get there. - Bo Jackson',
    'Do the one thing you think you cannot do. Fail, try again, and do better the second time. This is your moment. Own it. - Oprah Winfrey',
    'There is only one corner of the universe you can be certain of improving, and that\'s your own self. - Aldous Huxley',
    'You are here to enrich the world, and you impoverish yourself if you forget the errand. - Woodrow Wilson',
    'Knowing is not enough; we must apply! - Johann Wolfgang von Goethe',
    'One who gains strength by overcoming obstacles possesses the only strength which can overcome adversity. - Albert Schweitzer',
    'The best way to predict your future is to create it. - Peter Drucker',
    'Start where you are. Use what you have. Do what you can. - Arthur Ashe',
    'I will prepare and someday my chance will come. - Abraham Lincoln',
    'Setting goals is the first step in turning the invisible into the visible. - Tony Robbins',
    'Learn from yesterday, live for today, hope for tomorrow. - Albert Einstein',
    'Always do your best. What you plant now, you will harvest later. - Og Mandino',
    'To accomplish great things, we must not only act, but also dream; not only plan, but also believe. - Anatole France',
    'Believe deep down in your heart that you\'re destined to do great things. - Joe Paterno',
    'Be impeccable with your word. Speak with integrity. Say only what you mean. Use your words in the direction of truth and love. - Don Miguel Ruiz',
    'The future depends on what you do today. - Mahatma Gandhi',
    'Act as if what you do makes a difference. It does. - William James',
    'Great things are done by a series of small things brought together. - Vincent van Gogh',
    'Success is the sum of small efforts, repeated day in and day out. - Robert Collier',
    'You do not have to be great to start, but you have to start to be great. - Zig Ziglar',
    'The only limit to tomorrow is our doubts of today. - Franklin D. Roosevelt',
    'Start by doing what is necessary; then do what is possible; and suddenly you are doing the impossible. - Francis of Assisi',
    'It is never too late to be what you might have been. - George Eliot',
    'Everything you\'ve ever wanted is on the other side of fear. - George Addair',
    'Success is not final, failure is not fatal: it is the courage to continue that counts. - Winston Churchill',
    'The way to get started is to quit talking and begin doing. - Walt Disney',
    'Don\'t count the days; make the days count. - Muhammad Ali',
    'A small beginning is still a beginning.',
    'Your pace is still progress. Keep going.',
    'Consistency turns intention into change.',
    'You can begin again without becoming someone new.',
    'The next step does not need to be perfect; it only needs to be yours.',
    'Give today one honest effort. That is enough to move forward.',
    'Progress grows wherever you return with patience.',
    'You are capable of more than you know, and worthy of the effort.',
    'A quiet start can still become a strong day.',
    'Hope is a powerful place to start.',
    'One brave step can change the direction of a day.',
    'You do not need a perfect plan to make a meaningful start.',
    'Begin with what is in front of you, then let momentum teach you the rest.',
  ];
}

DailyQuote fallbackQuoteForSeed(int seed) {
  if (fallbackQuotes.isEmpty) {
    return const DailyQuote(text: 'Small steps every day.');
  }
  return DailyQuote(text: fallbackQuotes[seed % fallbackQuotes.length]);
}
