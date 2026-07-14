import 'package:drift/drift.dart';

/// Habit status enum stored as text in SQLite.
enum HabitStatus { active, finished, abandoned }

/// Log action status enum stored as text in SQLite.
enum LogStatus { completed, skipped }

/// Participant role for a shared habit.
enum PartnershipRole { owner, partner, supporter }

/// Local notification center event types.
enum NotificationEventType {
  nudge,
  privateMessage,
  habitInvitation,
  friendRequest,
  friendAccepted,
  reminderSetting,
}

/// Reminder types for the local slot-based reminder system.
enum ReminderType { dailyHabit }

/// Sync queue action types for outbound mutations.
enum SyncAction {
  createHabit,
  logHabit,
  updateHabit,
  sendNudge,
  sendPrivateMessage,
  acceptInvitation,
  declineInvitation,
  syncScore,
  sendHabitInvitation,
}

// ---------------------------------------------------------------------------
// Table Definitions — Mirror the Cloudflare D1 schema (spec 01)
// Each table adds `isSynced` and `updatedAt` for offline-first conflict
// resolution via "Last Write Wins".
// ---------------------------------------------------------------------------

/// Core user profile table.
class Users extends Table {
  TextColumn get userId => text()();
  TextColumn get username => text().withLength(min: 1, max: 50)();
  TextColumn get email => text().nullable()();
  DateTimeColumn get emailVerifiedAt => dateTime().nullable()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get levelName => text().withDefault(const Constant('Newbie'))();
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
  TextColumn get description => text().nullable()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  IntColumn get targetDuration => integer()();
  IntColumn get currentDuration => integer()();
  TextColumn get status => textEnum<HabitStatus>()();

  /// Hex color string (e.g. 'FF9CAF88') for ring/avatar tinting. Assigned on
  /// creation from a fixed pastel palette; never null after migration.
  TextColumn get colorHex => text().withDefault(const Constant('FF9CAF88'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
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
  IntColumn get pointsAwarded => integer().withDefault(const Constant(0))();
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
  TextColumn get role =>
      textEnum<PartnershipRole>().withDefault(const Constant('partner'))();
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
  BoolColumn get isProcessed => boolean().withDefault(const Constant(false))();
}

/// Cached daily quotes pulled from the server.
class CachedQuotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get quoteText => text()();
  TextColumn get author => text().nullable()();
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

/// Local cache of partner habit snapshots pulled from /api/sync/daily.
/// Offline-first: UI reads ONLY from this table, never directly from network.
class PartnerSnapshots extends Table {
  TextColumn get habitId => text()();
  TextColumn get partnerUserId => text()();
  TextColumn get username => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get role =>
      textEnum<PartnershipRole>().withDefault(const Constant('partner'))();
  IntColumn get currentDuration => integer().withDefault(const Constant(0))();
  BoolColumn get hasCompletedToday =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastNudgeAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {habitId, partnerUserId};
}

/// Private messages and wishes sent between users based on milestones.
class PrivateMessages extends Table {
  TextColumn get messageId => text()();
  TextColumn get senderId => text()();
  TextColumn get recipientId => text()();
  TextColumn get message => text()();
  TextColumn get milestoneType => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {messageId};
}

/// Invitations to become a habit partner.
class HabitInvitations extends Table {
  TextColumn get invitationId => text()();
  TextColumn get requesterId => text()();
  TextColumn get recipientId => text()();
  TextColumn get habitId => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {invitationId};
}

/// Milestone events used to trigger wish suggestions.
class MilestoneEvents extends Table {
  TextColumn get eventId => text()();
  TextColumn get userId => text()();
  TextColumn get habitId => text()();
  TextColumn get milestoneType => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {eventId};
}

/// Local cache of accepted friends.
class AcceptedFriends extends Table {
  TextColumn get friendUserId => text()();
  TextColumn get username => text()();
  TextColumn get avatarUrl => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {friendUserId};
}

/// Local cache of friend/search relationship state.
class FriendRelationships extends Table {
  TextColumn get userId => text()();
  TextColumn get username => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get relationshipState =>
      text().withDefault(const Constant('none'))();
  TextColumn get requestId => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {userId};
}

/// Server-owned achievement unlock cache from /api/sync/daily.
class AchievementUnlocks extends Table {
  TextColumn get achievementId => text()();
  TextColumn get userId => text()();
  TextColumn get sourceEventId => text()();
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isSynced => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {userId, achievementId};
}

/// Offline-first notification center events for the current user.
class NotificationEvents extends Table {
  TextColumn get notificationId => text()();
  TextColumn get userId => text()();
  TextColumn get type => textEnum<NotificationEventType>()();
  TextColumn get sourceType => text()();
  TextColumn get sourceId => text().nullable()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get actionRoute => text().nullable()();
  TextColumn get actionPayloadJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get expiresAt => dateTime().nullable()();
  DateTimeColumn get readAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {notificationId};
}

/// Per-user local reminder preference for different types of reminders.
class ReminderSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userId => text()();
  TextColumn get type =>
      textEnum<ReminderType>().withDefault(const Constant('dailyHabit'))();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(false))();
  IntColumn get hour => integer().withDefault(const Constant(20))();
  IntColumn get minute => integer().withDefault(const Constant(0))();
  BoolColumn get isPermissionDenied =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Coarse anonymous diagnostics buckets for development-only usage reporting.
class UsageAggregateBuckets extends Table {
  TextColumn get bucketDate => text()();
  TextColumn get platform => text()();
  TextColumn get buildChannel => text()();
  TextColumn get screenName => text()();
  TextColumn get metricName => text()();
  IntColumn get count => integer().withDefault(const Constant(0))();
  IntColumn get totalDurationMs => integer().withDefault(const Constant(0))();
  IntColumn get uploadedCount => integer().withDefault(const Constant(0))();
  IntColumn get uploadedTotalDurationMs =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {
    bucketDate,
    platform,
    buildChannel,
    screenName,
    metricName,
  };
}
