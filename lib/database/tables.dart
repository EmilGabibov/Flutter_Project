import 'package:drift/drift.dart';

/// Habit status enum stored as text in SQLite.
enum HabitStatus { active, completed, abandoned }

/// Log action status enum stored as text in SQLite.
enum LogStatus { completed, skipped }

/// Sync queue action types for outbound mutations.
enum SyncAction { createHabit, logHabit, sendNudge }

// ---------------------------------------------------------------------------
// Table Definitions — Mirror the Cloudflare D1 schema (spec 01)
// Each table adds `isSynced` and `updatedAt` for offline-first conflict
// resolution via "Last Write Wins".
// ---------------------------------------------------------------------------

/// Core user profile table.
class Users extends Table {
  TextColumn get userId => text()();
  TextColumn get username => text().withLength(min: 1, max: 50)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get totalScore => integer().withDefault(const Constant(0))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {userId};
}

/// Habit tracking table with penalty-aware duration fields.
class Habits extends Table {
  TextColumn get habitId => text()();
  TextColumn get userId => text().references(Users, #userId)();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  IntColumn get targetDuration => integer()();
  IntColumn get currentDuration => integer()();
  TextColumn get status => textEnum<HabitStatus>()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {habitId};
}

/// Daily action logs — one per habit per day.
class Logs extends Table {
  TextColumn get logId => text()();
  TextColumn get habitId => text().references(Habits, #habitId)();
  DateTimeColumn get actionDate => dateTime()();
  TextColumn get status => textEnum<LogStatus>()();
  TextColumn get journalNote => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {logId};
}

/// Partnership junction — maps which friends can see which habit.
class Partnerships extends Table {
  TextColumn get partnershipId => text()();
  TextColumn get habitId => text().references(Habits, #habitId)();
  TextColumn get partnerUserId => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {partnershipId};
}

/// Local outbound sync queue for offline mutations.
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get action => textEnum<SyncAction>()();
  TextColumn get payload => text()(); // JSON-encoded payload
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isProcessed =>
      boolean().withDefault(const Constant(false))();
}

/// Cached daily quotes pulled from the server.
class CachedQuotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get quoteText => text()();
  DateTimeColumn get fetchedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Metadata for documents that are indexed in the local search engine.
class SearchDocuments extends Table {
  TextColumn get documentId => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get author => text().nullable()();
  DateTimeColumn get publicationDate => dateTime().nullable()();
  TextColumn get source => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {documentId};
}
