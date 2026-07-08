// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _totalScoreMeta = const VerificationMeta(
    'totalScore',
  );
  @override
  late final GeneratedColumn<int> totalScore = GeneratedColumn<int>(
    'total_score',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    username,
    createdAt,
    updatedAt,
    totalScore,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('total_score')) {
      context.handle(
        _totalScoreMeta,
        totalScore.isAcceptableOrUnknown(data['total_score']!, _totalScoreMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      totalScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_score'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String userId;
  final String username;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalScore;
  final bool isSynced;
  const User({
    required this.userId,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    required this.totalScore,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['username'] = Variable<String>(username);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['total_score'] = Variable<int>(totalScore);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      userId: Value(userId),
      username: Value(username),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      totalScore: Value(totalScore),
      isSynced: Value(isSynced),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      userId: serializer.fromJson<String>(json['userId']),
      username: serializer.fromJson<String>(json['username']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      totalScore: serializer.fromJson<int>(json['totalScore']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'username': serializer.toJson<String>(username),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'totalScore': serializer.toJson<int>(totalScore),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  User copyWith({
    String? userId,
    String? username,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalScore,
    bool? isSynced,
  }) => User(
    userId: userId ?? this.userId,
    username: username ?? this.username,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    totalScore: totalScore ?? this.totalScore,
    isSynced: isSynced ?? this.isSynced,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      userId: data.userId.present ? data.userId.value : this.userId,
      username: data.username.present ? data.username.value : this.username,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      totalScore: data.totalScore.present
          ? data.totalScore.value
          : this.totalScore,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('userId: $userId, ')
          ..write('username: $username, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('totalScore: $totalScore, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(userId, username, createdAt, updatedAt, totalScore, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.userId == this.userId &&
          other.username == this.username &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.totalScore == this.totalScore &&
          other.isSynced == this.isSynced);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> userId;
  final Value<String> username;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> totalScore;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const UsersCompanion({
    this.userId = const Value.absent(),
    this.username = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String userId,
    required String username,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       username = Value(username);
  static Insertable<User> custom({
    Expression<String>? userId,
    Expression<String>? username,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? totalScore,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (username != null) 'username': username,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (totalScore != null) 'total_score': totalScore,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? userId,
    Value<String>? username,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? totalScore,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalScore: totalScore ?? this.totalScore,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (totalScore.present) {
      map['total_score'] = Variable<int>(totalScore.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('userId: $userId, ')
          ..write('username: $username, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('totalScore: $totalScore, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (user_id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _targetDurationMeta = const VerificationMeta(
    'targetDuration',
  );
  @override
  late final GeneratedColumn<int> targetDuration = GeneratedColumn<int>(
    'target_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentDurationMeta = const VerificationMeta(
    'currentDuration',
  );
  @override
  late final GeneratedColumn<int> currentDuration = GeneratedColumn<int>(
    'current_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<HabitStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HabitStatus>($HabitsTable.$converterstatus);
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('FF9CAF88'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    habitId,
    userId,
    title,
    isCustom,
    targetDuration,
    currentDuration,
    status,
    colorHex,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<Habit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('target_duration')) {
      context.handle(
        _targetDurationMeta,
        targetDuration.isAcceptableOrUnknown(
          data['target_duration']!,
          _targetDurationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetDurationMeta);
    }
    if (data.containsKey('current_duration')) {
      context.handle(
        _currentDurationMeta,
        currentDuration.isAcceptableOrUnknown(
          data['current_duration']!,
          _currentDurationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentDurationMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {habitId};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      targetDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_duration'],
      )!,
      currentDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_duration'],
      )!,
      status: $HabitsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<HabitStatus, String, String> $converterstatus =
      const EnumNameConverter<HabitStatus>(HabitStatus.values);
}

class Habit extends DataClass implements Insertable<Habit> {
  final String habitId;
  final String userId;
  final String title;
  final bool isCustom;
  final int targetDuration;
  final int currentDuration;
  final HabitStatus status;

  /// Hex color string (e.g. 'FF9CAF88') for ring/avatar tinting. Assigned on
  /// creation from a fixed pastel palette; never null after migration.
  final String colorHex;
  final DateTime updatedAt;
  final bool isSynced;
  const Habit({
    required this.habitId,
    required this.userId,
    required this.title,
    required this.isCustom,
    required this.targetDuration,
    required this.currentDuration,
    required this.status,
    required this.colorHex,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['habit_id'] = Variable<String>(habitId);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['is_custom'] = Variable<bool>(isCustom);
    map['target_duration'] = Variable<int>(targetDuration);
    map['current_duration'] = Variable<int>(currentDuration);
    {
      map['status'] = Variable<String>(
        $HabitsTable.$converterstatus.toSql(status),
      );
    }
    map['color_hex'] = Variable<String>(colorHex);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      habitId: Value(habitId),
      userId: Value(userId),
      title: Value(title),
      isCustom: Value(isCustom),
      targetDuration: Value(targetDuration),
      currentDuration: Value(currentDuration),
      status: Value(status),
      colorHex: Value(colorHex),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory Habit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      habitId: serializer.fromJson<String>(json['habitId']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      targetDuration: serializer.fromJson<int>(json['targetDuration']),
      currentDuration: serializer.fromJson<int>(json['currentDuration']),
      status: $HabitsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'habitId': serializer.toJson<String>(habitId),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'isCustom': serializer.toJson<bool>(isCustom),
      'targetDuration': serializer.toJson<int>(targetDuration),
      'currentDuration': serializer.toJson<int>(currentDuration),
      'status': serializer.toJson<String>(
        $HabitsTable.$converterstatus.toJson(status),
      ),
      'colorHex': serializer.toJson<String>(colorHex),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Habit copyWith({
    String? habitId,
    String? userId,
    String? title,
    bool? isCustom,
    int? targetDuration,
    int? currentDuration,
    HabitStatus? status,
    String? colorHex,
    DateTime? updatedAt,
    bool? isSynced,
  }) => Habit(
    habitId: habitId ?? this.habitId,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    isCustom: isCustom ?? this.isCustom,
    targetDuration: targetDuration ?? this.targetDuration,
    currentDuration: currentDuration ?? this.currentDuration,
    status: status ?? this.status,
    colorHex: colorHex ?? this.colorHex,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      targetDuration: data.targetDuration.present
          ? data.targetDuration.value
          : this.targetDuration,
      currentDuration: data.currentDuration.present
          ? data.currentDuration.value
          : this.currentDuration,
      status: data.status.present ? data.status.value : this.status,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('habitId: $habitId, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('isCustom: $isCustom, ')
          ..write('targetDuration: $targetDuration, ')
          ..write('currentDuration: $currentDuration, ')
          ..write('status: $status, ')
          ..write('colorHex: $colorHex, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    habitId,
    userId,
    title,
    isCustom,
    targetDuration,
    currentDuration,
    status,
    colorHex,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.habitId == this.habitId &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.isCustom == this.isCustom &&
          other.targetDuration == this.targetDuration &&
          other.currentDuration == this.currentDuration &&
          other.status == this.status &&
          other.colorHex == this.colorHex &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<String> habitId;
  final Value<String> userId;
  final Value<String> title;
  final Value<bool> isCustom;
  final Value<int> targetDuration;
  final Value<int> currentDuration;
  final Value<HabitStatus> status;
  final Value<String> colorHex;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const HabitsCompanion({
    this.habitId = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.targetDuration = const Value.absent(),
    this.currentDuration = const Value.absent(),
    this.status = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String habitId,
    required String userId,
    required String title,
    this.isCustom = const Value.absent(),
    required int targetDuration,
    required int currentDuration,
    required HabitStatus status,
    this.colorHex = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : habitId = Value(habitId),
       userId = Value(userId),
       title = Value(title),
       targetDuration = Value(targetDuration),
       currentDuration = Value(currentDuration),
       status = Value(status);
  static Insertable<Habit> custom({
    Expression<String>? habitId,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<bool>? isCustom,
    Expression<int>? targetDuration,
    Expression<int>? currentDuration,
    Expression<String>? status,
    Expression<String>? colorHex,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (habitId != null) 'habit_id': habitId,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (isCustom != null) 'is_custom': isCustom,
      if (targetDuration != null) 'target_duration': targetDuration,
      if (currentDuration != null) 'current_duration': currentDuration,
      if (status != null) 'status': status,
      if (colorHex != null) 'color_hex': colorHex,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? habitId,
    Value<String>? userId,
    Value<String>? title,
    Value<bool>? isCustom,
    Value<int>? targetDuration,
    Value<int>? currentDuration,
    Value<HabitStatus>? status,
    Value<String>? colorHex,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      habitId: habitId ?? this.habitId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      isCustom: isCustom ?? this.isCustom,
      targetDuration: targetDuration ?? this.targetDuration,
      currentDuration: currentDuration ?? this.currentDuration,
      status: status ?? this.status,
      colorHex: colorHex ?? this.colorHex,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (targetDuration.present) {
      map['target_duration'] = Variable<int>(targetDuration.value);
    }
    if (currentDuration.present) {
      map['current_duration'] = Variable<int>(currentDuration.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $HabitsTable.$converterstatus.toSql(status.value),
      );
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('habitId: $habitId, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('isCustom: $isCustom, ')
          ..write('targetDuration: $targetDuration, ')
          ..write('currentDuration: $currentDuration, ')
          ..write('status: $status, ')
          ..write('colorHex: $colorHex, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LogsTable extends Logs with TableInfo<$LogsTable, Log> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _logIdMeta = const VerificationMeta('logId');
  @override
  late final GeneratedColumn<String> logId = GeneratedColumn<String>(
    'log_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (habit_id)',
    ),
  );
  static const VerificationMeta _actionDateMeta = const VerificationMeta(
    'actionDate',
  );
  @override
  late final GeneratedColumn<DateTime> actionDate = GeneratedColumn<DateTime>(
    'action_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LogStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<LogStatus>($LogsTable.$converterstatus);
  static const VerificationMeta _journalNoteMeta = const VerificationMeta(
    'journalNote',
  );
  @override
  late final GeneratedColumn<String> journalNote = GeneratedColumn<String>(
    'journal_note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    logId,
    habitId,
    actionDate,
    status,
    journalNote,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Log> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('log_id')) {
      context.handle(
        _logIdMeta,
        logId.isAcceptableOrUnknown(data['log_id']!, _logIdMeta),
      );
    } else if (isInserting) {
      context.missing(_logIdMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('action_date')) {
      context.handle(
        _actionDateMeta,
        actionDate.isAcceptableOrUnknown(data['action_date']!, _actionDateMeta),
      );
    } else if (isInserting) {
      context.missing(_actionDateMeta);
    }
    if (data.containsKey('journal_note')) {
      context.handle(
        _journalNoteMeta,
        journalNote.isAcceptableOrUnknown(
          data['journal_note']!,
          _journalNoteMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {logId};
  @override
  Log map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Log(
      logId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}log_id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      actionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}action_date'],
      )!,
      status: $LogsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      journalNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journal_note'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $LogsTable createAlias(String alias) {
    return $LogsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LogStatus, String, String> $converterstatus =
      const EnumNameConverter<LogStatus>(LogStatus.values);
}

class Log extends DataClass implements Insertable<Log> {
  final String logId;
  final String habitId;
  final DateTime actionDate;
  final LogStatus status;
  final String? journalNote;
  final DateTime updatedAt;
  final bool isSynced;
  const Log({
    required this.logId,
    required this.habitId,
    required this.actionDate,
    required this.status,
    this.journalNote,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['log_id'] = Variable<String>(logId);
    map['habit_id'] = Variable<String>(habitId);
    map['action_date'] = Variable<DateTime>(actionDate);
    {
      map['status'] = Variable<String>(
        $LogsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || journalNote != null) {
      map['journal_note'] = Variable<String>(journalNote);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  LogsCompanion toCompanion(bool nullToAbsent) {
    return LogsCompanion(
      logId: Value(logId),
      habitId: Value(habitId),
      actionDate: Value(actionDate),
      status: Value(status),
      journalNote: journalNote == null && nullToAbsent
          ? const Value.absent()
          : Value(journalNote),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory Log.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Log(
      logId: serializer.fromJson<String>(json['logId']),
      habitId: serializer.fromJson<String>(json['habitId']),
      actionDate: serializer.fromJson<DateTime>(json['actionDate']),
      status: $LogsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      journalNote: serializer.fromJson<String?>(json['journalNote']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'logId': serializer.toJson<String>(logId),
      'habitId': serializer.toJson<String>(habitId),
      'actionDate': serializer.toJson<DateTime>(actionDate),
      'status': serializer.toJson<String>(
        $LogsTable.$converterstatus.toJson(status),
      ),
      'journalNote': serializer.toJson<String?>(journalNote),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Log copyWith({
    String? logId,
    String? habitId,
    DateTime? actionDate,
    LogStatus? status,
    Value<String?> journalNote = const Value.absent(),
    DateTime? updatedAt,
    bool? isSynced,
  }) => Log(
    logId: logId ?? this.logId,
    habitId: habitId ?? this.habitId,
    actionDate: actionDate ?? this.actionDate,
    status: status ?? this.status,
    journalNote: journalNote.present ? journalNote.value : this.journalNote,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  Log copyWithCompanion(LogsCompanion data) {
    return Log(
      logId: data.logId.present ? data.logId.value : this.logId,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      actionDate: data.actionDate.present
          ? data.actionDate.value
          : this.actionDate,
      status: data.status.present ? data.status.value : this.status,
      journalNote: data.journalNote.present
          ? data.journalNote.value
          : this.journalNote,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Log(')
          ..write('logId: $logId, ')
          ..write('habitId: $habitId, ')
          ..write('actionDate: $actionDate, ')
          ..write('status: $status, ')
          ..write('journalNote: $journalNote, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    logId,
    habitId,
    actionDate,
    status,
    journalNote,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Log &&
          other.logId == this.logId &&
          other.habitId == this.habitId &&
          other.actionDate == this.actionDate &&
          other.status == this.status &&
          other.journalNote == this.journalNote &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class LogsCompanion extends UpdateCompanion<Log> {
  final Value<String> logId;
  final Value<String> habitId;
  final Value<DateTime> actionDate;
  final Value<LogStatus> status;
  final Value<String?> journalNote;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const LogsCompanion({
    this.logId = const Value.absent(),
    this.habitId = const Value.absent(),
    this.actionDate = const Value.absent(),
    this.status = const Value.absent(),
    this.journalNote = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LogsCompanion.insert({
    required String logId,
    required String habitId,
    required DateTime actionDate,
    required LogStatus status,
    this.journalNote = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : logId = Value(logId),
       habitId = Value(habitId),
       actionDate = Value(actionDate),
       status = Value(status);
  static Insertable<Log> custom({
    Expression<String>? logId,
    Expression<String>? habitId,
    Expression<DateTime>? actionDate,
    Expression<String>? status,
    Expression<String>? journalNote,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (logId != null) 'log_id': logId,
      if (habitId != null) 'habit_id': habitId,
      if (actionDate != null) 'action_date': actionDate,
      if (status != null) 'status': status,
      if (journalNote != null) 'journal_note': journalNote,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LogsCompanion copyWith({
    Value<String>? logId,
    Value<String>? habitId,
    Value<DateTime>? actionDate,
    Value<LogStatus>? status,
    Value<String?>? journalNote,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return LogsCompanion(
      logId: logId ?? this.logId,
      habitId: habitId ?? this.habitId,
      actionDate: actionDate ?? this.actionDate,
      status: status ?? this.status,
      journalNote: journalNote ?? this.journalNote,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (logId.present) {
      map['log_id'] = Variable<String>(logId.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (actionDate.present) {
      map['action_date'] = Variable<DateTime>(actionDate.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $LogsTable.$converterstatus.toSql(status.value),
      );
    }
    if (journalNote.present) {
      map['journal_note'] = Variable<String>(journalNote.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LogsCompanion(')
          ..write('logId: $logId, ')
          ..write('habitId: $habitId, ')
          ..write('actionDate: $actionDate, ')
          ..write('status: $status, ')
          ..write('journalNote: $journalNote, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartnershipsTable extends Partnerships
    with TableInfo<$PartnershipsTable, Partnership> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartnershipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _partnershipIdMeta = const VerificationMeta(
    'partnershipId',
  );
  @override
  late final GeneratedColumn<String> partnershipId = GeneratedColumn<String>(
    'partnership_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (habit_id)',
    ),
  );
  static const VerificationMeta _partnerUserIdMeta = const VerificationMeta(
    'partnerUserId',
  );
  @override
  late final GeneratedColumn<String> partnerUserId = GeneratedColumn<String>(
    'partner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    partnershipId,
    habitId,
    partnerUserId,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'partnerships';
  @override
  VerificationContext validateIntegrity(
    Insertable<Partnership> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('partnership_id')) {
      context.handle(
        _partnershipIdMeta,
        partnershipId.isAcceptableOrUnknown(
          data['partnership_id']!,
          _partnershipIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_partnershipIdMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('partner_user_id')) {
      context.handle(
        _partnerUserIdMeta,
        partnerUserId.isAcceptableOrUnknown(
          data['partner_user_id']!,
          _partnerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_partnerUserIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {partnershipId};
  @override
  Partnership map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Partnership(
      partnershipId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}partnership_id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      partnerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}partner_user_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $PartnershipsTable createAlias(String alias) {
    return $PartnershipsTable(attachedDatabase, alias);
  }
}

class Partnership extends DataClass implements Insertable<Partnership> {
  final String partnershipId;
  final String habitId;
  final String partnerUserId;
  final DateTime updatedAt;
  final bool isSynced;
  const Partnership({
    required this.partnershipId,
    required this.habitId,
    required this.partnerUserId,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['partnership_id'] = Variable<String>(partnershipId);
    map['habit_id'] = Variable<String>(habitId);
    map['partner_user_id'] = Variable<String>(partnerUserId);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  PartnershipsCompanion toCompanion(bool nullToAbsent) {
    return PartnershipsCompanion(
      partnershipId: Value(partnershipId),
      habitId: Value(habitId),
      partnerUserId: Value(partnerUserId),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory Partnership.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Partnership(
      partnershipId: serializer.fromJson<String>(json['partnershipId']),
      habitId: serializer.fromJson<String>(json['habitId']),
      partnerUserId: serializer.fromJson<String>(json['partnerUserId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'partnershipId': serializer.toJson<String>(partnershipId),
      'habitId': serializer.toJson<String>(habitId),
      'partnerUserId': serializer.toJson<String>(partnerUserId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Partnership copyWith({
    String? partnershipId,
    String? habitId,
    String? partnerUserId,
    DateTime? updatedAt,
    bool? isSynced,
  }) => Partnership(
    partnershipId: partnershipId ?? this.partnershipId,
    habitId: habitId ?? this.habitId,
    partnerUserId: partnerUserId ?? this.partnerUserId,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  Partnership copyWithCompanion(PartnershipsCompanion data) {
    return Partnership(
      partnershipId: data.partnershipId.present
          ? data.partnershipId.value
          : this.partnershipId,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      partnerUserId: data.partnerUserId.present
          ? data.partnerUserId.value
          : this.partnerUserId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Partnership(')
          ..write('partnershipId: $partnershipId, ')
          ..write('habitId: $habitId, ')
          ..write('partnerUserId: $partnerUserId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(partnershipId, habitId, partnerUserId, updatedAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Partnership &&
          other.partnershipId == this.partnershipId &&
          other.habitId == this.habitId &&
          other.partnerUserId == this.partnerUserId &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class PartnershipsCompanion extends UpdateCompanion<Partnership> {
  final Value<String> partnershipId;
  final Value<String> habitId;
  final Value<String> partnerUserId;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const PartnershipsCompanion({
    this.partnershipId = const Value.absent(),
    this.habitId = const Value.absent(),
    this.partnerUserId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartnershipsCompanion.insert({
    required String partnershipId,
    required String habitId,
    required String partnerUserId,
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : partnershipId = Value(partnershipId),
       habitId = Value(habitId),
       partnerUserId = Value(partnerUserId);
  static Insertable<Partnership> custom({
    Expression<String>? partnershipId,
    Expression<String>? habitId,
    Expression<String>? partnerUserId,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (partnershipId != null) 'partnership_id': partnershipId,
      if (habitId != null) 'habit_id': habitId,
      if (partnerUserId != null) 'partner_user_id': partnerUserId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartnershipsCompanion copyWith({
    Value<String>? partnershipId,
    Value<String>? habitId,
    Value<String>? partnerUserId,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return PartnershipsCompanion(
      partnershipId: partnershipId ?? this.partnershipId,
      habitId: habitId ?? this.habitId,
      partnerUserId: partnerUserId ?? this.partnerUserId,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (partnershipId.present) {
      map['partnership_id'] = Variable<String>(partnershipId.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (partnerUserId.present) {
      map['partner_user_id'] = Variable<String>(partnerUserId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnershipsCompanion(')
          ..write('partnershipId: $partnershipId, ')
          ..write('habitId: $habitId, ')
          ..write('partnerUserId: $partnerUserId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncAction, String> action =
      GeneratedColumn<String>(
        'action',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SyncAction>($SyncQueueTable.$converteraction);
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isProcessedMeta = const VerificationMeta(
    'isProcessed',
  );
  @override
  late final GeneratedColumn<bool> isProcessed = GeneratedColumn<bool>(
    'is_processed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_processed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    action,
    payload,
    createdAt,
    isProcessed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('is_processed')) {
      context.handle(
        _isProcessedMeta,
        isProcessed.isAcceptableOrUnknown(
          data['is_processed']!,
          _isProcessedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      action: $SyncQueueTable.$converteraction.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}action'],
        )!,
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isProcessed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_processed'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SyncAction, String, String> $converteraction =
      const EnumNameConverter<SyncAction>(SyncAction.values);
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final SyncAction action;
  final String payload;
  final DateTime createdAt;
  final bool isProcessed;
  const SyncQueueData({
    required this.id,
    required this.action,
    required this.payload,
    required this.createdAt,
    required this.isProcessed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['action'] = Variable<String>(
        $SyncQueueTable.$converteraction.toSql(action),
      );
    }
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_processed'] = Variable<bool>(isProcessed);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      action: Value(action),
      payload: Value(payload),
      createdAt: Value(createdAt),
      isProcessed: Value(isProcessed),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      action: $SyncQueueTable.$converteraction.fromJson(
        serializer.fromJson<String>(json['action']),
      ),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isProcessed: serializer.fromJson<bool>(json['isProcessed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'action': serializer.toJson<String>(
        $SyncQueueTable.$converteraction.toJson(action),
      ),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isProcessed': serializer.toJson<bool>(isProcessed),
    };
  }

  SyncQueueData copyWith({
    int? id,
    SyncAction? action,
    String? payload,
    DateTime? createdAt,
    bool? isProcessed,
  }) => SyncQueueData(
    id: id ?? this.id,
    action: action ?? this.action,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    isProcessed: isProcessed ?? this.isProcessed,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      action: data.action.present ? data.action.value : this.action,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isProcessed: data.isProcessed.present
          ? data.isProcessed.value
          : this.isProcessed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('isProcessed: $isProcessed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, action, payload, createdAt, isProcessed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.action == this.action &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.isProcessed == this.isProcessed);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<SyncAction> action;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<bool> isProcessed;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.action = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isProcessed = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required SyncAction action,
    required String payload,
    this.createdAt = const Value.absent(),
    this.isProcessed = const Value.absent(),
  }) : action = Value(action),
       payload = Value(payload);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? action,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<bool>? isProcessed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (isProcessed != null) 'is_processed': isProcessed,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<SyncAction>? action,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<bool>? isProcessed,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      action: action ?? this.action,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      isProcessed: isProcessed ?? this.isProcessed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(
        $SyncQueueTable.$converteraction.toSql(action.value),
      );
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isProcessed.present) {
      map['is_processed'] = Variable<bool>(isProcessed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('isProcessed: $isProcessed')
          ..write(')'))
        .toString();
  }
}

class $CachedQuotesTable extends CachedQuotes
    with TableInfo<$CachedQuotesTable, CachedQuote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedQuotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _quoteTextMeta = const VerificationMeta(
    'quoteText',
  );
  @override
  late final GeneratedColumn<String> quoteText = GeneratedColumn<String>(
    'quote_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, quoteText, fetchedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_quotes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedQuote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('quote_text')) {
      context.handle(
        _quoteTextMeta,
        quoteText.isAcceptableOrUnknown(data['quote_text']!, _quoteTextMeta),
      );
    } else if (isInserting) {
      context.missing(_quoteTextMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedQuote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedQuote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      quoteText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quote_text'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CachedQuotesTable createAlias(String alias) {
    return $CachedQuotesTable(attachedDatabase, alias);
  }
}

class CachedQuote extends DataClass implements Insertable<CachedQuote> {
  final int id;
  final String quoteText;
  final DateTime fetchedAt;
  const CachedQuote({
    required this.id,
    required this.quoteText,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['quote_text'] = Variable<String>(quoteText);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CachedQuotesCompanion toCompanion(bool nullToAbsent) {
    return CachedQuotesCompanion(
      id: Value(id),
      quoteText: Value(quoteText),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CachedQuote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedQuote(
      id: serializer.fromJson<int>(json['id']),
      quoteText: serializer.fromJson<String>(json['quoteText']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'quoteText': serializer.toJson<String>(quoteText),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CachedQuote copyWith({int? id, String? quoteText, DateTime? fetchedAt}) =>
      CachedQuote(
        id: id ?? this.id,
        quoteText: quoteText ?? this.quoteText,
        fetchedAt: fetchedAt ?? this.fetchedAt,
      );
  CachedQuote copyWithCompanion(CachedQuotesCompanion data) {
    return CachedQuote(
      id: data.id.present ? data.id.value : this.id,
      quoteText: data.quoteText.present ? data.quoteText.value : this.quoteText,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedQuote(')
          ..write('id: $id, ')
          ..write('quoteText: $quoteText, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, quoteText, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedQuote &&
          other.id == this.id &&
          other.quoteText == this.quoteText &&
          other.fetchedAt == this.fetchedAt);
}

class CachedQuotesCompanion extends UpdateCompanion<CachedQuote> {
  final Value<int> id;
  final Value<String> quoteText;
  final Value<DateTime> fetchedAt;
  const CachedQuotesCompanion({
    this.id = const Value.absent(),
    this.quoteText = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  });
  CachedQuotesCompanion.insert({
    this.id = const Value.absent(),
    required String quoteText,
    this.fetchedAt = const Value.absent(),
  }) : quoteText = Value(quoteText);
  static Insertable<CachedQuote> custom({
    Expression<int>? id,
    Expression<String>? quoteText,
    Expression<DateTime>? fetchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quoteText != null) 'quote_text': quoteText,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
    });
  }

  CachedQuotesCompanion copyWith({
    Value<int>? id,
    Value<String>? quoteText,
    Value<DateTime>? fetchedAt,
  }) {
    return CachedQuotesCompanion(
      id: id ?? this.id,
      quoteText: quoteText ?? this.quoteText,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (quoteText.present) {
      map['quote_text'] = Variable<String>(quoteText.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedQuotesCompanion(')
          ..write('id: $id, ')
          ..write('quoteText: $quoteText, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }
}

class $SearchDocumentsTable extends SearchDocuments
    with TableInfo<$SearchDocumentsTable, SearchDocument> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchDocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _publicationDateMeta = const VerificationMeta(
    'publicationDate',
  );
  @override
  late final GeneratedColumn<DateTime> publicationDate =
      GeneratedColumn<DateTime>(
        'publication_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    documentId,
    title,
    author,
    publicationDate,
    source,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_documents';
  @override
  VerificationContext validateIntegrity(
    Insertable<SearchDocument> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('publication_date')) {
      context.handle(
        _publicationDateMeta,
        publicationDate.isAcceptableOrUnknown(
          data['publication_date']!,
          _publicationDateMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {documentId};
  @override
  SearchDocument map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchDocument(
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      publicationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}publication_date'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $SearchDocumentsTable createAlias(String alias) {
    return $SearchDocumentsTable(attachedDatabase, alias);
  }
}

class SearchDocument extends DataClass implements Insertable<SearchDocument> {
  final String documentId;
  final String title;
  final String? author;
  final DateTime? publicationDate;
  final String? source;
  final DateTime updatedAt;
  final bool isSynced;
  const SearchDocument({
    required this.documentId,
    required this.title,
    this.author,
    this.publicationDate,
    this.source,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['document_id'] = Variable<String>(documentId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || publicationDate != null) {
      map['publication_date'] = Variable<DateTime>(publicationDate);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  SearchDocumentsCompanion toCompanion(bool nullToAbsent) {
    return SearchDocumentsCompanion(
      documentId: Value(documentId),
      title: Value(title),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      publicationDate: publicationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(publicationDate),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory SearchDocument.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchDocument(
      documentId: serializer.fromJson<String>(json['documentId']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      publicationDate: serializer.fromJson<DateTime?>(json['publicationDate']),
      source: serializer.fromJson<String?>(json['source']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'documentId': serializer.toJson<String>(documentId),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'publicationDate': serializer.toJson<DateTime?>(publicationDate),
      'source': serializer.toJson<String?>(source),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  SearchDocument copyWith({
    String? documentId,
    String? title,
    Value<String?> author = const Value.absent(),
    Value<DateTime?> publicationDate = const Value.absent(),
    Value<String?> source = const Value.absent(),
    DateTime? updatedAt,
    bool? isSynced,
  }) => SearchDocument(
    documentId: documentId ?? this.documentId,
    title: title ?? this.title,
    author: author.present ? author.value : this.author,
    publicationDate: publicationDate.present
        ? publicationDate.value
        : this.publicationDate,
    source: source.present ? source.value : this.source,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  SearchDocument copyWithCompanion(SearchDocumentsCompanion data) {
    return SearchDocument(
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      publicationDate: data.publicationDate.present
          ? data.publicationDate.value
          : this.publicationDate,
      source: data.source.present ? data.source.value : this.source,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchDocument(')
          ..write('documentId: $documentId, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('publicationDate: $publicationDate, ')
          ..write('source: $source, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    documentId,
    title,
    author,
    publicationDate,
    source,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchDocument &&
          other.documentId == this.documentId &&
          other.title == this.title &&
          other.author == this.author &&
          other.publicationDate == this.publicationDate &&
          other.source == this.source &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class SearchDocumentsCompanion extends UpdateCompanion<SearchDocument> {
  final Value<String> documentId;
  final Value<String> title;
  final Value<String?> author;
  final Value<DateTime?> publicationDate;
  final Value<String?> source;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const SearchDocumentsCompanion({
    this.documentId = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.publicationDate = const Value.absent(),
    this.source = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SearchDocumentsCompanion.insert({
    required String documentId,
    required String title,
    this.author = const Value.absent(),
    this.publicationDate = const Value.absent(),
    this.source = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : documentId = Value(documentId),
       title = Value(title);
  static Insertable<SearchDocument> custom({
    Expression<String>? documentId,
    Expression<String>? title,
    Expression<String>? author,
    Expression<DateTime>? publicationDate,
    Expression<String>? source,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (documentId != null) 'document_id': documentId,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (publicationDate != null) 'publication_date': publicationDate,
      if (source != null) 'source': source,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SearchDocumentsCompanion copyWith({
    Value<String>? documentId,
    Value<String>? title,
    Value<String?>? author,
    Value<DateTime?>? publicationDate,
    Value<String?>? source,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return SearchDocumentsCompanion(
      documentId: documentId ?? this.documentId,
      title: title ?? this.title,
      author: author ?? this.author,
      publicationDate: publicationDate ?? this.publicationDate,
      source: source ?? this.source,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (publicationDate.present) {
      map['publication_date'] = Variable<DateTime>(publicationDate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchDocumentsCompanion(')
          ..write('documentId: $documentId, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('publicationDate: $publicationDate, ')
          ..write('source: $source, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PartnerSnapshotsTable extends PartnerSnapshots
    with TableInfo<$PartnerSnapshotsTable, PartnerSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PartnerSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _partnerUserIdMeta = const VerificationMeta(
    'partnerUserId',
  );
  @override
  late final GeneratedColumn<String> partnerUserId = GeneratedColumn<String>(
    'partner_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarUrlMeta = const VerificationMeta(
    'avatarUrl',
  );
  @override
  late final GeneratedColumn<String> avatarUrl = GeneratedColumn<String>(
    'avatar_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentDurationMeta = const VerificationMeta(
    'currentDuration',
  );
  @override
  late final GeneratedColumn<int> currentDuration = GeneratedColumn<int>(
    'current_duration',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hasCompletedTodayMeta = const VerificationMeta(
    'hasCompletedToday',
  );
  @override
  late final GeneratedColumn<bool> hasCompletedToday = GeneratedColumn<bool>(
    'has_completed_today',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_completed_today" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastNudgeAtMeta = const VerificationMeta(
    'lastNudgeAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastNudgeAt = GeneratedColumn<DateTime>(
    'last_nudge_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    habitId,
    partnerUserId,
    username,
    avatarUrl,
    currentDuration,
    hasCompletedToday,
    lastNudgeAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'partner_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<PartnerSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('partner_user_id')) {
      context.handle(
        _partnerUserIdMeta,
        partnerUserId.isAcceptableOrUnknown(
          data['partner_user_id']!,
          _partnerUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_partnerUserIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('current_duration')) {
      context.handle(
        _currentDurationMeta,
        currentDuration.isAcceptableOrUnknown(
          data['current_duration']!,
          _currentDurationMeta,
        ),
      );
    }
    if (data.containsKey('has_completed_today')) {
      context.handle(
        _hasCompletedTodayMeta,
        hasCompletedToday.isAcceptableOrUnknown(
          data['has_completed_today']!,
          _hasCompletedTodayMeta,
        ),
      );
    }
    if (data.containsKey('last_nudge_at')) {
      context.handle(
        _lastNudgeAtMeta,
        lastNudgeAt.isAcceptableOrUnknown(
          data['last_nudge_at']!,
          _lastNudgeAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {habitId, partnerUserId};
  @override
  PartnerSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PartnerSnapshot(
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      partnerUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}partner_user_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      currentDuration: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_duration'],
      )!,
      hasCompletedToday: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_completed_today'],
      )!,
      lastNudgeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_nudge_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $PartnerSnapshotsTable createAlias(String alias) {
    return $PartnerSnapshotsTable(attachedDatabase, alias);
  }
}

class PartnerSnapshot extends DataClass implements Insertable<PartnerSnapshot> {
  final String habitId;
  final String partnerUserId;
  final String username;
  final String? avatarUrl;
  final int currentDuration;
  final bool hasCompletedToday;
  final DateTime? lastNudgeAt;
  final DateTime updatedAt;
  final bool isSynced;
  const PartnerSnapshot({
    required this.habitId,
    required this.partnerUserId,
    required this.username,
    this.avatarUrl,
    required this.currentDuration,
    required this.hasCompletedToday,
    this.lastNudgeAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['habit_id'] = Variable<String>(habitId);
    map['partner_user_id'] = Variable<String>(partnerUserId);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['current_duration'] = Variable<int>(currentDuration);
    map['has_completed_today'] = Variable<bool>(hasCompletedToday);
    if (!nullToAbsent || lastNudgeAt != null) {
      map['last_nudge_at'] = Variable<DateTime>(lastNudgeAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  PartnerSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return PartnerSnapshotsCompanion(
      habitId: Value(habitId),
      partnerUserId: Value(partnerUserId),
      username: Value(username),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      currentDuration: Value(currentDuration),
      hasCompletedToday: Value(hasCompletedToday),
      lastNudgeAt: lastNudgeAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastNudgeAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory PartnerSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PartnerSnapshot(
      habitId: serializer.fromJson<String>(json['habitId']),
      partnerUserId: serializer.fromJson<String>(json['partnerUserId']),
      username: serializer.fromJson<String>(json['username']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      currentDuration: serializer.fromJson<int>(json['currentDuration']),
      hasCompletedToday: serializer.fromJson<bool>(json['hasCompletedToday']),
      lastNudgeAt: serializer.fromJson<DateTime?>(json['lastNudgeAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'habitId': serializer.toJson<String>(habitId),
      'partnerUserId': serializer.toJson<String>(partnerUserId),
      'username': serializer.toJson<String>(username),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'currentDuration': serializer.toJson<int>(currentDuration),
      'hasCompletedToday': serializer.toJson<bool>(hasCompletedToday),
      'lastNudgeAt': serializer.toJson<DateTime?>(lastNudgeAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  PartnerSnapshot copyWith({
    String? habitId,
    String? partnerUserId,
    String? username,
    Value<String?> avatarUrl = const Value.absent(),
    int? currentDuration,
    bool? hasCompletedToday,
    Value<DateTime?> lastNudgeAt = const Value.absent(),
    DateTime? updatedAt,
    bool? isSynced,
  }) => PartnerSnapshot(
    habitId: habitId ?? this.habitId,
    partnerUserId: partnerUserId ?? this.partnerUserId,
    username: username ?? this.username,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    currentDuration: currentDuration ?? this.currentDuration,
    hasCompletedToday: hasCompletedToday ?? this.hasCompletedToday,
    lastNudgeAt: lastNudgeAt.present ? lastNudgeAt.value : this.lastNudgeAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  PartnerSnapshot copyWithCompanion(PartnerSnapshotsCompanion data) {
    return PartnerSnapshot(
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      partnerUserId: data.partnerUserId.present
          ? data.partnerUserId.value
          : this.partnerUserId,
      username: data.username.present ? data.username.value : this.username,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      currentDuration: data.currentDuration.present
          ? data.currentDuration.value
          : this.currentDuration,
      hasCompletedToday: data.hasCompletedToday.present
          ? data.hasCompletedToday.value
          : this.hasCompletedToday,
      lastNudgeAt: data.lastNudgeAt.present
          ? data.lastNudgeAt.value
          : this.lastNudgeAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PartnerSnapshot(')
          ..write('habitId: $habitId, ')
          ..write('partnerUserId: $partnerUserId, ')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('currentDuration: $currentDuration, ')
          ..write('hasCompletedToday: $hasCompletedToday, ')
          ..write('lastNudgeAt: $lastNudgeAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    habitId,
    partnerUserId,
    username,
    avatarUrl,
    currentDuration,
    hasCompletedToday,
    lastNudgeAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PartnerSnapshot &&
          other.habitId == this.habitId &&
          other.partnerUserId == this.partnerUserId &&
          other.username == this.username &&
          other.avatarUrl == this.avatarUrl &&
          other.currentDuration == this.currentDuration &&
          other.hasCompletedToday == this.hasCompletedToday &&
          other.lastNudgeAt == this.lastNudgeAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class PartnerSnapshotsCompanion extends UpdateCompanion<PartnerSnapshot> {
  final Value<String> habitId;
  final Value<String> partnerUserId;
  final Value<String> username;
  final Value<String?> avatarUrl;
  final Value<int> currentDuration;
  final Value<bool> hasCompletedToday;
  final Value<DateTime?> lastNudgeAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const PartnerSnapshotsCompanion({
    this.habitId = const Value.absent(),
    this.partnerUserId = const Value.absent(),
    this.username = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.currentDuration = const Value.absent(),
    this.hasCompletedToday = const Value.absent(),
    this.lastNudgeAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartnerSnapshotsCompanion.insert({
    required String habitId,
    required String partnerUserId,
    required String username,
    this.avatarUrl = const Value.absent(),
    this.currentDuration = const Value.absent(),
    this.hasCompletedToday = const Value.absent(),
    this.lastNudgeAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : habitId = Value(habitId),
       partnerUserId = Value(partnerUserId),
       username = Value(username);
  static Insertable<PartnerSnapshot> custom({
    Expression<String>? habitId,
    Expression<String>? partnerUserId,
    Expression<String>? username,
    Expression<String>? avatarUrl,
    Expression<int>? currentDuration,
    Expression<bool>? hasCompletedToday,
    Expression<DateTime>? lastNudgeAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (habitId != null) 'habit_id': habitId,
      if (partnerUserId != null) 'partner_user_id': partnerUserId,
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (currentDuration != null) 'current_duration': currentDuration,
      if (hasCompletedToday != null) 'has_completed_today': hasCompletedToday,
      if (lastNudgeAt != null) 'last_nudge_at': lastNudgeAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartnerSnapshotsCompanion copyWith({
    Value<String>? habitId,
    Value<String>? partnerUserId,
    Value<String>? username,
    Value<String?>? avatarUrl,
    Value<int>? currentDuration,
    Value<bool>? hasCompletedToday,
    Value<DateTime?>? lastNudgeAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return PartnerSnapshotsCompanion(
      habitId: habitId ?? this.habitId,
      partnerUserId: partnerUserId ?? this.partnerUserId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentDuration: currentDuration ?? this.currentDuration,
      hasCompletedToday: hasCompletedToday ?? this.hasCompletedToday,
      lastNudgeAt: lastNudgeAt ?? this.lastNudgeAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (partnerUserId.present) {
      map['partner_user_id'] = Variable<String>(partnerUserId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (currentDuration.present) {
      map['current_duration'] = Variable<int>(currentDuration.value);
    }
    if (hasCompletedToday.present) {
      map['has_completed_today'] = Variable<bool>(hasCompletedToday.value);
    }
    if (lastNudgeAt.present) {
      map['last_nudge_at'] = Variable<DateTime>(lastNudgeAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PartnerSnapshotsCompanion(')
          ..write('habitId: $habitId, ')
          ..write('partnerUserId: $partnerUserId, ')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('currentDuration: $currentDuration, ')
          ..write('hasCompletedToday: $hasCompletedToday, ')
          ..write('lastNudgeAt: $lastNudgeAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PrivateMessagesTable extends PrivateMessages
    with TableInfo<$PrivateMessagesTable, PrivateMessage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PrivateMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _messageIdMeta = const VerificationMeta(
    'messageId',
  );
  @override
  late final GeneratedColumn<String> messageId = GeneratedColumn<String>(
    'message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _senderIdMeta = const VerificationMeta(
    'senderId',
  );
  @override
  late final GeneratedColumn<String> senderId = GeneratedColumn<String>(
    'sender_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipientIdMeta = const VerificationMeta(
    'recipientId',
  );
  @override
  late final GeneratedColumn<String> recipientId = GeneratedColumn<String>(
    'recipient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _milestoneTypeMeta = const VerificationMeta(
    'milestoneType',
  );
  @override
  late final GeneratedColumn<String> milestoneType = GeneratedColumn<String>(
    'milestone_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    messageId,
    senderId,
    recipientId,
    message,
    milestoneType,
    createdAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'private_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<PrivateMessage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('message_id')) {
      context.handle(
        _messageIdMeta,
        messageId.isAcceptableOrUnknown(data['message_id']!, _messageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_messageIdMeta);
    }
    if (data.containsKey('sender_id')) {
      context.handle(
        _senderIdMeta,
        senderId.isAcceptableOrUnknown(data['sender_id']!, _senderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_senderIdMeta);
    }
    if (data.containsKey('recipient_id')) {
      context.handle(
        _recipientIdMeta,
        recipientId.isAcceptableOrUnknown(
          data['recipient_id']!,
          _recipientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientIdMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('milestone_type')) {
      context.handle(
        _milestoneTypeMeta,
        milestoneType.isAcceptableOrUnknown(
          data['milestone_type']!,
          _milestoneTypeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {messageId};
  @override
  PrivateMessage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PrivateMessage(
      messageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_id'],
      )!,
      senderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_id'],
      )!,
      recipientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipient_id'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      milestoneType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}milestone_type'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $PrivateMessagesTable createAlias(String alias) {
    return $PrivateMessagesTable(attachedDatabase, alias);
  }
}

class PrivateMessage extends DataClass implements Insertable<PrivateMessage> {
  final String messageId;
  final String senderId;
  final String recipientId;
  final String message;
  final String? milestoneType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const PrivateMessage({
    required this.messageId,
    required this.senderId,
    required this.recipientId,
    required this.message,
    this.milestoneType,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['message_id'] = Variable<String>(messageId);
    map['sender_id'] = Variable<String>(senderId);
    map['recipient_id'] = Variable<String>(recipientId);
    map['message'] = Variable<String>(message);
    if (!nullToAbsent || milestoneType != null) {
      map['milestone_type'] = Variable<String>(milestoneType);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  PrivateMessagesCompanion toCompanion(bool nullToAbsent) {
    return PrivateMessagesCompanion(
      messageId: Value(messageId),
      senderId: Value(senderId),
      recipientId: Value(recipientId),
      message: Value(message),
      milestoneType: milestoneType == null && nullToAbsent
          ? const Value.absent()
          : Value(milestoneType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory PrivateMessage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PrivateMessage(
      messageId: serializer.fromJson<String>(json['messageId']),
      senderId: serializer.fromJson<String>(json['senderId']),
      recipientId: serializer.fromJson<String>(json['recipientId']),
      message: serializer.fromJson<String>(json['message']),
      milestoneType: serializer.fromJson<String?>(json['milestoneType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'messageId': serializer.toJson<String>(messageId),
      'senderId': serializer.toJson<String>(senderId),
      'recipientId': serializer.toJson<String>(recipientId),
      'message': serializer.toJson<String>(message),
      'milestoneType': serializer.toJson<String?>(milestoneType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  PrivateMessage copyWith({
    String? messageId,
    String? senderId,
    String? recipientId,
    String? message,
    Value<String?> milestoneType = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => PrivateMessage(
    messageId: messageId ?? this.messageId,
    senderId: senderId ?? this.senderId,
    recipientId: recipientId ?? this.recipientId,
    message: message ?? this.message,
    milestoneType: milestoneType.present
        ? milestoneType.value
        : this.milestoneType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  PrivateMessage copyWithCompanion(PrivateMessagesCompanion data) {
    return PrivateMessage(
      messageId: data.messageId.present ? data.messageId.value : this.messageId,
      senderId: data.senderId.present ? data.senderId.value : this.senderId,
      recipientId: data.recipientId.present
          ? data.recipientId.value
          : this.recipientId,
      message: data.message.present ? data.message.value : this.message,
      milestoneType: data.milestoneType.present
          ? data.milestoneType.value
          : this.milestoneType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PrivateMessage(')
          ..write('messageId: $messageId, ')
          ..write('senderId: $senderId, ')
          ..write('recipientId: $recipientId, ')
          ..write('message: $message, ')
          ..write('milestoneType: $milestoneType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    messageId,
    senderId,
    recipientId,
    message,
    milestoneType,
    createdAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PrivateMessage &&
          other.messageId == this.messageId &&
          other.senderId == this.senderId &&
          other.recipientId == this.recipientId &&
          other.message == this.message &&
          other.milestoneType == this.milestoneType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class PrivateMessagesCompanion extends UpdateCompanion<PrivateMessage> {
  final Value<String> messageId;
  final Value<String> senderId;
  final Value<String> recipientId;
  final Value<String> message;
  final Value<String?> milestoneType;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const PrivateMessagesCompanion({
    this.messageId = const Value.absent(),
    this.senderId = const Value.absent(),
    this.recipientId = const Value.absent(),
    this.message = const Value.absent(),
    this.milestoneType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PrivateMessagesCompanion.insert({
    required String messageId,
    required String senderId,
    required String recipientId,
    required String message,
    this.milestoneType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : messageId = Value(messageId),
       senderId = Value(senderId),
       recipientId = Value(recipientId),
       message = Value(message);
  static Insertable<PrivateMessage> custom({
    Expression<String>? messageId,
    Expression<String>? senderId,
    Expression<String>? recipientId,
    Expression<String>? message,
    Expression<String>? milestoneType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (messageId != null) 'message_id': messageId,
      if (senderId != null) 'sender_id': senderId,
      if (recipientId != null) 'recipient_id': recipientId,
      if (message != null) 'message': message,
      if (milestoneType != null) 'milestone_type': milestoneType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PrivateMessagesCompanion copyWith({
    Value<String>? messageId,
    Value<String>? senderId,
    Value<String>? recipientId,
    Value<String>? message,
    Value<String?>? milestoneType,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return PrivateMessagesCompanion(
      messageId: messageId ?? this.messageId,
      senderId: senderId ?? this.senderId,
      recipientId: recipientId ?? this.recipientId,
      message: message ?? this.message,
      milestoneType: milestoneType ?? this.milestoneType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (messageId.present) {
      map['message_id'] = Variable<String>(messageId.value);
    }
    if (senderId.present) {
      map['sender_id'] = Variable<String>(senderId.value);
    }
    if (recipientId.present) {
      map['recipient_id'] = Variable<String>(recipientId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (milestoneType.present) {
      map['milestone_type'] = Variable<String>(milestoneType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PrivateMessagesCompanion(')
          ..write('messageId: $messageId, ')
          ..write('senderId: $senderId, ')
          ..write('recipientId: $recipientId, ')
          ..write('message: $message, ')
          ..write('milestoneType: $milestoneType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitInvitationsTable extends HabitInvitations
    with TableInfo<$HabitInvitationsTable, HabitInvitation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitInvitationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _invitationIdMeta = const VerificationMeta(
    'invitationId',
  );
  @override
  late final GeneratedColumn<String> invitationId = GeneratedColumn<String>(
    'invitation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _requesterIdMeta = const VerificationMeta(
    'requesterId',
  );
  @override
  late final GeneratedColumn<String> requesterId = GeneratedColumn<String>(
    'requester_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipientIdMeta = const VerificationMeta(
    'recipientId',
  );
  @override
  late final GeneratedColumn<String> recipientId = GeneratedColumn<String>(
    'recipient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    invitationId,
    requesterId,
    recipientId,
    habitId,
    status,
    createdAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habit_invitations';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitInvitation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('invitation_id')) {
      context.handle(
        _invitationIdMeta,
        invitationId.isAcceptableOrUnknown(
          data['invitation_id']!,
          _invitationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invitationIdMeta);
    }
    if (data.containsKey('requester_id')) {
      context.handle(
        _requesterIdMeta,
        requesterId.isAcceptableOrUnknown(
          data['requester_id']!,
          _requesterIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_requesterIdMeta);
    }
    if (data.containsKey('recipient_id')) {
      context.handle(
        _recipientIdMeta,
        recipientId.isAcceptableOrUnknown(
          data['recipient_id']!,
          _recipientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recipientIdMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {invitationId};
  @override
  HabitInvitation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitInvitation(
      invitationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invitation_id'],
      )!,
      requesterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}requester_id'],
      )!,
      recipientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipient_id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $HabitInvitationsTable createAlias(String alias) {
    return $HabitInvitationsTable(attachedDatabase, alias);
  }
}

class HabitInvitation extends DataClass implements Insertable<HabitInvitation> {
  final String invitationId;
  final String requesterId;
  final String recipientId;
  final String habitId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const HabitInvitation({
    required this.invitationId,
    required this.requesterId,
    required this.recipientId,
    required this.habitId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['invitation_id'] = Variable<String>(invitationId);
    map['requester_id'] = Variable<String>(requesterId);
    map['recipient_id'] = Variable<String>(recipientId);
    map['habit_id'] = Variable<String>(habitId);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  HabitInvitationsCompanion toCompanion(bool nullToAbsent) {
    return HabitInvitationsCompanion(
      invitationId: Value(invitationId),
      requesterId: Value(requesterId),
      recipientId: Value(recipientId),
      habitId: Value(habitId),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory HabitInvitation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitInvitation(
      invitationId: serializer.fromJson<String>(json['invitationId']),
      requesterId: serializer.fromJson<String>(json['requesterId']),
      recipientId: serializer.fromJson<String>(json['recipientId']),
      habitId: serializer.fromJson<String>(json['habitId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'invitationId': serializer.toJson<String>(invitationId),
      'requesterId': serializer.toJson<String>(requesterId),
      'recipientId': serializer.toJson<String>(recipientId),
      'habitId': serializer.toJson<String>(habitId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  HabitInvitation copyWith({
    String? invitationId,
    String? requesterId,
    String? recipientId,
    String? habitId,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => HabitInvitation(
    invitationId: invitationId ?? this.invitationId,
    requesterId: requesterId ?? this.requesterId,
    recipientId: recipientId ?? this.recipientId,
    habitId: habitId ?? this.habitId,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  HabitInvitation copyWithCompanion(HabitInvitationsCompanion data) {
    return HabitInvitation(
      invitationId: data.invitationId.present
          ? data.invitationId.value
          : this.invitationId,
      requesterId: data.requesterId.present
          ? data.requesterId.value
          : this.requesterId,
      recipientId: data.recipientId.present
          ? data.recipientId.value
          : this.recipientId,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitInvitation(')
          ..write('invitationId: $invitationId, ')
          ..write('requesterId: $requesterId, ')
          ..write('recipientId: $recipientId, ')
          ..write('habitId: $habitId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    invitationId,
    requesterId,
    recipientId,
    habitId,
    status,
    createdAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitInvitation &&
          other.invitationId == this.invitationId &&
          other.requesterId == this.requesterId &&
          other.recipientId == this.recipientId &&
          other.habitId == this.habitId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class HabitInvitationsCompanion extends UpdateCompanion<HabitInvitation> {
  final Value<String> invitationId;
  final Value<String> requesterId;
  final Value<String> recipientId;
  final Value<String> habitId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const HabitInvitationsCompanion({
    this.invitationId = const Value.absent(),
    this.requesterId = const Value.absent(),
    this.recipientId = const Value.absent(),
    this.habitId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitInvitationsCompanion.insert({
    required String invitationId,
    required String requesterId,
    required String recipientId,
    required String habitId,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : invitationId = Value(invitationId),
       requesterId = Value(requesterId),
       recipientId = Value(recipientId),
       habitId = Value(habitId);
  static Insertable<HabitInvitation> custom({
    Expression<String>? invitationId,
    Expression<String>? requesterId,
    Expression<String>? recipientId,
    Expression<String>? habitId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (invitationId != null) 'invitation_id': invitationId,
      if (requesterId != null) 'requester_id': requesterId,
      if (recipientId != null) 'recipient_id': recipientId,
      if (habitId != null) 'habit_id': habitId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitInvitationsCompanion copyWith({
    Value<String>? invitationId,
    Value<String>? requesterId,
    Value<String>? recipientId,
    Value<String>? habitId,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return HabitInvitationsCompanion(
      invitationId: invitationId ?? this.invitationId,
      requesterId: requesterId ?? this.requesterId,
      recipientId: recipientId ?? this.recipientId,
      habitId: habitId ?? this.habitId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (invitationId.present) {
      map['invitation_id'] = Variable<String>(invitationId.value);
    }
    if (requesterId.present) {
      map['requester_id'] = Variable<String>(requesterId.value);
    }
    if (recipientId.present) {
      map['recipient_id'] = Variable<String>(recipientId.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitInvitationsCompanion(')
          ..write('invitationId: $invitationId, ')
          ..write('requesterId: $requesterId, ')
          ..write('recipientId: $recipientId, ')
          ..write('habitId: $habitId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MilestoneEventsTable extends MilestoneEvents
    with TableInfo<$MilestoneEventsTable, MilestoneEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MilestoneEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<String> eventId = GeneratedColumn<String>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _milestoneTypeMeta = const VerificationMeta(
    'milestoneType',
  );
  @override
  late final GeneratedColumn<String> milestoneType = GeneratedColumn<String>(
    'milestone_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    eventId,
    userId,
    habitId,
    milestoneType,
    createdAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'milestone_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<MilestoneEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('milestone_type')) {
      context.handle(
        _milestoneTypeMeta,
        milestoneType.isAcceptableOrUnknown(
          data['milestone_type']!,
          _milestoneTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_milestoneTypeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId};
  @override
  MilestoneEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MilestoneEvent(
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      milestoneType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}milestone_type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $MilestoneEventsTable createAlias(String alias) {
    return $MilestoneEventsTable(attachedDatabase, alias);
  }
}

class MilestoneEvent extends DataClass implements Insertable<MilestoneEvent> {
  final String eventId;
  final String userId;
  final String habitId;
  final String milestoneType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const MilestoneEvent({
    required this.eventId,
    required this.userId,
    required this.habitId,
    required this.milestoneType,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<String>(eventId);
    map['user_id'] = Variable<String>(userId);
    map['habit_id'] = Variable<String>(habitId);
    map['milestone_type'] = Variable<String>(milestoneType);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  MilestoneEventsCompanion toCompanion(bool nullToAbsent) {
    return MilestoneEventsCompanion(
      eventId: Value(eventId),
      userId: Value(userId),
      habitId: Value(habitId),
      milestoneType: Value(milestoneType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory MilestoneEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MilestoneEvent(
      eventId: serializer.fromJson<String>(json['eventId']),
      userId: serializer.fromJson<String>(json['userId']),
      habitId: serializer.fromJson<String>(json['habitId']),
      milestoneType: serializer.fromJson<String>(json['milestoneType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<String>(eventId),
      'userId': serializer.toJson<String>(userId),
      'habitId': serializer.toJson<String>(habitId),
      'milestoneType': serializer.toJson<String>(milestoneType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  MilestoneEvent copyWith({
    String? eventId,
    String? userId,
    String? habitId,
    String? milestoneType,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => MilestoneEvent(
    eventId: eventId ?? this.eventId,
    userId: userId ?? this.userId,
    habitId: habitId ?? this.habitId,
    milestoneType: milestoneType ?? this.milestoneType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  MilestoneEvent copyWithCompanion(MilestoneEventsCompanion data) {
    return MilestoneEvent(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      userId: data.userId.present ? data.userId.value : this.userId,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      milestoneType: data.milestoneType.present
          ? data.milestoneType.value
          : this.milestoneType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MilestoneEvent(')
          ..write('eventId: $eventId, ')
          ..write('userId: $userId, ')
          ..write('habitId: $habitId, ')
          ..write('milestoneType: $milestoneType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    eventId,
    userId,
    habitId,
    milestoneType,
    createdAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MilestoneEvent &&
          other.eventId == this.eventId &&
          other.userId == this.userId &&
          other.habitId == this.habitId &&
          other.milestoneType == this.milestoneType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class MilestoneEventsCompanion extends UpdateCompanion<MilestoneEvent> {
  final Value<String> eventId;
  final Value<String> userId;
  final Value<String> habitId;
  final Value<String> milestoneType;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const MilestoneEventsCompanion({
    this.eventId = const Value.absent(),
    this.userId = const Value.absent(),
    this.habitId = const Value.absent(),
    this.milestoneType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MilestoneEventsCompanion.insert({
    required String eventId,
    required String userId,
    required String habitId,
    required String milestoneType,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       userId = Value(userId),
       habitId = Value(habitId),
       milestoneType = Value(milestoneType);
  static Insertable<MilestoneEvent> custom({
    Expression<String>? eventId,
    Expression<String>? userId,
    Expression<String>? habitId,
    Expression<String>? milestoneType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (userId != null) 'user_id': userId,
      if (habitId != null) 'habit_id': habitId,
      if (milestoneType != null) 'milestone_type': milestoneType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MilestoneEventsCompanion copyWith({
    Value<String>? eventId,
    Value<String>? userId,
    Value<String>? habitId,
    Value<String>? milestoneType,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return MilestoneEventsCompanion(
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      habitId: habitId ?? this.habitId,
      milestoneType: milestoneType ?? this.milestoneType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<String>(eventId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (milestoneType.present) {
      map['milestone_type'] = Variable<String>(milestoneType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MilestoneEventsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('userId: $userId, ')
          ..write('habitId: $habitId, ')
          ..write('milestoneType: $milestoneType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $LogsTable logs = $LogsTable(this);
  late final $PartnershipsTable partnerships = $PartnershipsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $CachedQuotesTable cachedQuotes = $CachedQuotesTable(this);
  late final $SearchDocumentsTable searchDocuments = $SearchDocumentsTable(
    this,
  );
  late final $PartnerSnapshotsTable partnerSnapshots = $PartnerSnapshotsTable(
    this,
  );
  late final $PrivateMessagesTable privateMessages = $PrivateMessagesTable(
    this,
  );
  late final $HabitInvitationsTable habitInvitations = $HabitInvitationsTable(
    this,
  );
  late final $MilestoneEventsTable milestoneEvents = $MilestoneEventsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    habits,
    logs,
    partnerships,
    syncQueue,
    cachedQuotes,
    searchDocuments,
    partnerSnapshots,
    privateMessages,
    habitInvitations,
    milestoneEvents,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String userId,
      required String username,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> totalScore,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> userId,
      Value<String> username,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> totalScore,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitsTable, List<Habit>> _habitsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.habits,
    aliasName: 'users__user_id__habits__user_id',
  );

  $$HabitsTableProcessedTableManager get habitsRefs {
    final manager = $$HabitsTableTableManager($_db, $_db.habits).filter(
      (f) => f.userId.userId.sqlEquals($_itemColumn<String>('user_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_habitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> habitsRefs(
    Expression<bool> Function($$HabitsTableFilterComposer f) f,
  ) {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get totalScore => $composableBuilder(
    column: $table.totalScore,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  Expression<T> habitsRefs<T extends Object>(
    Expression<T> Function($$HabitsTableAnnotationComposer a) f,
  ) {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({bool habitsRefs})
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                userId: userId,
                username: username,
                createdAt: createdAt,
                updatedAt: updatedAt,
                totalScore: totalScore,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String username,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                userId: userId,
                username: username,
                createdAt: createdAt,
                updatedAt: updatedAt,
                totalScore: totalScore,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({habitsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (habitsRefs) db.habits],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (habitsRefs)
                    await $_getPrefetchedData<User, $UsersTable, Habit>(
                      currentTable: table,
                      referencedTable: $$UsersTableReferences._habitsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$UsersTableReferences(db, table, p0).habitsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.userId == item.userId),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({bool habitsRefs})
    >;
typedef $$HabitsTableCreateCompanionBuilder =
    HabitsCompanion Function({
      required String habitId,
      required String userId,
      required String title,
      Value<bool> isCustom,
      required int targetDuration,
      required int currentDuration,
      required HabitStatus status,
      Value<String> colorHex,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<String> habitId,
      Value<String> userId,
      Value<String> title,
      Value<bool> isCustom,
      Value<int> targetDuration,
      Value<int> currentDuration,
      Value<HabitStatus> status,
      Value<String> colorHex,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, Habit> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias('habits__user_id__users__user_id');

  $$UsersTableProcessedTableManager get userId {
    final $_column = $_itemColumn<String>('user_id')!;

    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.userId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LogsTable, List<Log>> _logsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.logs,
    aliasName: 'habits__habit_id__logs__habit_id',
  );

  $$LogsTableProcessedTableManager get logsRefs {
    final manager = $$LogsTableTableManager($_db, $_db.logs).filter(
      (f) => f.habitId.habitId.sqlEquals($_itemColumn<String>('habit_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_logsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PartnershipsTable, List<Partnership>>
  _partnershipsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.partnerships,
    aliasName: 'habits__habit_id__partnerships__habit_id',
  );

  $$PartnershipsTableProcessedTableManager get partnershipsRefs {
    final manager = $$PartnershipsTableTableManager($_db, $_db.partnerships)
        .filter(
          (f) => f.habitId.habitId.sqlEquals($_itemColumn<String>('habit_id')!),
        );

    final cache = $_typedResult.readTableOrNull(_partnershipsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDuration => $composableBuilder(
    column: $table.targetDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentDuration => $composableBuilder(
    column: $table.currentDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<HabitStatus, HabitStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> logsRefs(
    Expression<bool> Function($$LogsTableFilterComposer f) f,
  ) {
    final $$LogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.logs,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogsTableFilterComposer(
            $db: $db,
            $table: $db.logs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> partnershipsRefs(
    Expression<bool> Function($$PartnershipsTableFilterComposer f) f,
  ) {
    final $$PartnershipsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.partnerships,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnershipsTableFilterComposer(
            $db: $db,
            $table: $db.partnerships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDuration => $composableBuilder(
    column: $table.targetDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentDuration => $composableBuilder(
    column: $table.currentDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<int> get targetDuration => $composableBuilder(
    column: $table.targetDuration,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentDuration => $composableBuilder(
    column: $table.currentDuration,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<HabitStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> logsRefs<T extends Object>(
    Expression<T> Function($$LogsTableAnnotationComposer a) f,
  ) {
    final $$LogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.logs,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LogsTableAnnotationComposer(
            $db: $db,
            $table: $db.logs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> partnershipsRefs<T extends Object>(
    Expression<T> Function($$PartnershipsTableAnnotationComposer a) f,
  ) {
    final $$PartnershipsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.partnerships,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PartnershipsTableAnnotationComposer(
            $db: $db,
            $table: $db.partnerships,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          Habit,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (Habit, $$HabitsTableReferences),
          Habit,
          PrefetchHooks Function({
            bool userId,
            bool logsRefs,
            bool partnershipsRefs,
          })
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> habitId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> targetDuration = const Value.absent(),
                Value<int> currentDuration = const Value.absent(),
                Value<HabitStatus> status = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                habitId: habitId,
                userId: userId,
                title: title,
                isCustom: isCustom,
                targetDuration: targetDuration,
                currentDuration: currentDuration,
                status: status,
                colorHex: colorHex,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String habitId,
                required String userId,
                required String title,
                Value<bool> isCustom = const Value.absent(),
                required int targetDuration,
                required int currentDuration,
                required HabitStatus status,
                Value<String> colorHex = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                habitId: habitId,
                userId: userId,
                title: title,
                isCustom: isCustom,
                targetDuration: targetDuration,
                currentDuration: currentDuration,
                status: status,
                colorHex: colorHex,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$HabitsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({userId = false, logsRefs = false, partnershipsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (logsRefs) db.logs,
                    if (partnershipsRefs) db.partnerships,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (userId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.userId,
                                    referencedTable: $$HabitsTableReferences
                                        ._userIdTable(db),
                                    referencedColumn: $$HabitsTableReferences
                                        ._userIdTable(db)
                                        .userId,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (logsRefs)
                        await $_getPrefetchedData<Habit, $HabitsTable, Log>(
                          currentTable: table,
                          referencedTable: $$HabitsTableReferences
                              ._logsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HabitsTableReferences(db, table, p0).logsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.habitId == item.habitId,
                              ),
                          typedResults: items,
                        ),
                      if (partnershipsRefs)
                        await $_getPrefetchedData<
                          Habit,
                          $HabitsTable,
                          Partnership
                        >(
                          currentTable: table,
                          referencedTable: $$HabitsTableReferences
                              ._partnershipsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HabitsTableReferences(
                                db,
                                table,
                                p0,
                              ).partnershipsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.habitId == item.habitId,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      Habit,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (Habit, $$HabitsTableReferences),
      Habit,
      PrefetchHooks Function({
        bool userId,
        bool logsRefs,
        bool partnershipsRefs,
      })
    >;
typedef $$LogsTableCreateCompanionBuilder =
    LogsCompanion Function({
      required String logId,
      required String habitId,
      required DateTime actionDate,
      required LogStatus status,
      Value<String?> journalNote,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$LogsTableUpdateCompanionBuilder =
    LogsCompanion Function({
      Value<String> logId,
      Value<String> habitId,
      Value<DateTime> actionDate,
      Value<LogStatus> status,
      Value<String?> journalNote,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$LogsTableReferences
    extends BaseReferences<_$AppDatabase, $LogsTable, Log> {
  $$LogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('logs__habit_id__habits__habit_id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.habitId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LogsTableFilterComposer extends Composer<_$AppDatabase, $LogsTable> {
  $$LogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get logId => $composableBuilder(
    column: $table.logId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actionDate => $composableBuilder(
    column: $table.actionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LogStatus, LogStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get journalNote => $composableBuilder(
    column: $table.journalNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LogsTableOrderingComposer extends Composer<_$AppDatabase, $LogsTable> {
  $$LogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get logId => $composableBuilder(
    column: $table.logId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actionDate => $composableBuilder(
    column: $table.actionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get journalNote => $composableBuilder(
    column: $table.journalNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LogsTable> {
  $$LogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get logId =>
      $composableBuilder(column: $table.logId, builder: (column) => column);

  GeneratedColumn<DateTime> get actionDate => $composableBuilder(
    column: $table.actionDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LogStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get journalNote => $composableBuilder(
    column: $table.journalNote,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LogsTable,
          Log,
          $$LogsTableFilterComposer,
          $$LogsTableOrderingComposer,
          $$LogsTableAnnotationComposer,
          $$LogsTableCreateCompanionBuilder,
          $$LogsTableUpdateCompanionBuilder,
          (Log, $$LogsTableReferences),
          Log,
          PrefetchHooks Function({bool habitId})
        > {
  $$LogsTableTableManager(_$AppDatabase db, $LogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> logId = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<DateTime> actionDate = const Value.absent(),
                Value<LogStatus> status = const Value.absent(),
                Value<String?> journalNote = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LogsCompanion(
                logId: logId,
                habitId: habitId,
                actionDate: actionDate,
                status: status,
                journalNote: journalNote,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String logId,
                required String habitId,
                required DateTime actionDate,
                required LogStatus status,
                Value<String?> journalNote = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LogsCompanion.insert(
                logId: logId,
                habitId: habitId,
                actionDate: actionDate,
                status: status,
                journalNote: journalNote,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LogsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.habitId,
                                referencedTable: $$LogsTableReferences
                                    ._habitIdTable(db),
                                referencedColumn: $$LogsTableReferences
                                    ._habitIdTable(db)
                                    .habitId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LogsTable,
      Log,
      $$LogsTableFilterComposer,
      $$LogsTableOrderingComposer,
      $$LogsTableAnnotationComposer,
      $$LogsTableCreateCompanionBuilder,
      $$LogsTableUpdateCompanionBuilder,
      (Log, $$LogsTableReferences),
      Log,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$PartnershipsTableCreateCompanionBuilder =
    PartnershipsCompanion Function({
      required String partnershipId,
      required String habitId,
      required String partnerUserId,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$PartnershipsTableUpdateCompanionBuilder =
    PartnershipsCompanion Function({
      Value<String> partnershipId,
      Value<String> habitId,
      Value<String> partnerUserId,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$PartnershipsTableReferences
    extends BaseReferences<_$AppDatabase, $PartnershipsTable, Partnership> {
  $$PartnershipsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('partnerships__habit_id__habits__habit_id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.habitId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PartnershipsTableFilterComposer
    extends Composer<_$AppDatabase, $PartnershipsTable> {
  $$PartnershipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get partnershipId => $composableBuilder(
    column: $table.partnershipId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partnerUserId => $composableBuilder(
    column: $table.partnerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartnershipsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartnershipsTable> {
  $$PartnershipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get partnershipId => $composableBuilder(
    column: $table.partnershipId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partnerUserId => $composableBuilder(
    column: $table.partnerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartnershipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartnershipsTable> {
  $$PartnershipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get partnershipId => $composableBuilder(
    column: $table.partnershipId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get partnerUserId => $composableBuilder(
    column: $table.partnerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PartnershipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartnershipsTable,
          Partnership,
          $$PartnershipsTableFilterComposer,
          $$PartnershipsTableOrderingComposer,
          $$PartnershipsTableAnnotationComposer,
          $$PartnershipsTableCreateCompanionBuilder,
          $$PartnershipsTableUpdateCompanionBuilder,
          (Partnership, $$PartnershipsTableReferences),
          Partnership,
          PrefetchHooks Function({bool habitId})
        > {
  $$PartnershipsTableTableManager(_$AppDatabase db, $PartnershipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartnershipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartnershipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartnershipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> partnershipId = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<String> partnerUserId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartnershipsCompanion(
                partnershipId: partnershipId,
                habitId: habitId,
                partnerUserId: partnerUserId,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String partnershipId,
                required String habitId,
                required String partnerUserId,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartnershipsCompanion.insert(
                partnershipId: partnershipId,
                habitId: habitId,
                partnerUserId: partnerUserId,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PartnershipsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.habitId,
                                referencedTable: $$PartnershipsTableReferences
                                    ._habitIdTable(db),
                                referencedColumn: $$PartnershipsTableReferences
                                    ._habitIdTable(db)
                                    .habitId,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PartnershipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartnershipsTable,
      Partnership,
      $$PartnershipsTableFilterComposer,
      $$PartnershipsTableOrderingComposer,
      $$PartnershipsTableAnnotationComposer,
      $$PartnershipsTableCreateCompanionBuilder,
      $$PartnershipsTableUpdateCompanionBuilder,
      (Partnership, $$PartnershipsTableReferences),
      Partnership,
      PrefetchHooks Function({bool habitId})
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required SyncAction action,
      required String payload,
      Value<DateTime> createdAt,
      Value<bool> isProcessed,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<SyncAction> action,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<bool> isProcessed,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncAction, SyncAction, String> get action =>
      $composableBuilder(
        column: $table.action,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isProcessed => $composableBuilder(
    column: $table.isProcessed,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isProcessed => $composableBuilder(
    column: $table.isProcessed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncAction, String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isProcessed => $composableBuilder(
    column: $table.isProcessed,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<SyncAction> action = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isProcessed = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                action: action,
                payload: payload,
                createdAt: createdAt,
                isProcessed: isProcessed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required SyncAction action,
                required String payload,
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isProcessed = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                action: action,
                payload: payload,
                createdAt: createdAt,
                isProcessed: isProcessed,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;
typedef $$CachedQuotesTableCreateCompanionBuilder =
    CachedQuotesCompanion Function({
      Value<int> id,
      required String quoteText,
      Value<DateTime> fetchedAt,
    });
typedef $$CachedQuotesTableUpdateCompanionBuilder =
    CachedQuotesCompanion Function({
      Value<int> id,
      Value<String> quoteText,
      Value<DateTime> fetchedAt,
    });

class $$CachedQuotesTableFilterComposer
    extends Composer<_$AppDatabase, $CachedQuotesTable> {
  $$CachedQuotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quoteText => $composableBuilder(
    column: $table.quoteText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CachedQuotesTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedQuotesTable> {
  $$CachedQuotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quoteText => $composableBuilder(
    column: $table.quoteText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CachedQuotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedQuotesTable> {
  $$CachedQuotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get quoteText =>
      $composableBuilder(column: $table.quoteText, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CachedQuotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedQuotesTable,
          CachedQuote,
          $$CachedQuotesTableFilterComposer,
          $$CachedQuotesTableOrderingComposer,
          $$CachedQuotesTableAnnotationComposer,
          $$CachedQuotesTableCreateCompanionBuilder,
          $$CachedQuotesTableUpdateCompanionBuilder,
          (
            CachedQuote,
            BaseReferences<_$AppDatabase, $CachedQuotesTable, CachedQuote>,
          ),
          CachedQuote,
          PrefetchHooks Function()
        > {
  $$CachedQuotesTableTableManager(_$AppDatabase db, $CachedQuotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedQuotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedQuotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CachedQuotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> quoteText = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
              }) => CachedQuotesCompanion(
                id: id,
                quoteText: quoteText,
                fetchedAt: fetchedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String quoteText,
                Value<DateTime> fetchedAt = const Value.absent(),
              }) => CachedQuotesCompanion.insert(
                id: id,
                quoteText: quoteText,
                fetchedAt: fetchedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CachedQuotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedQuotesTable,
      CachedQuote,
      $$CachedQuotesTableFilterComposer,
      $$CachedQuotesTableOrderingComposer,
      $$CachedQuotesTableAnnotationComposer,
      $$CachedQuotesTableCreateCompanionBuilder,
      $$CachedQuotesTableUpdateCompanionBuilder,
      (
        CachedQuote,
        BaseReferences<_$AppDatabase, $CachedQuotesTable, CachedQuote>,
      ),
      CachedQuote,
      PrefetchHooks Function()
    >;
typedef $$SearchDocumentsTableCreateCompanionBuilder =
    SearchDocumentsCompanion Function({
      required String documentId,
      required String title,
      Value<String?> author,
      Value<DateTime?> publicationDate,
      Value<String?> source,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$SearchDocumentsTableUpdateCompanionBuilder =
    SearchDocumentsCompanion Function({
      Value<String> documentId,
      Value<String> title,
      Value<String?> author,
      Value<DateTime?> publicationDate,
      Value<String?> source,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$SearchDocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $SearchDocumentsTable> {
  $$SearchDocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publicationDate => $composableBuilder(
    column: $table.publicationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SearchDocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchDocumentsTable> {
  $$SearchDocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publicationDate => $composableBuilder(
    column: $table.publicationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SearchDocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchDocumentsTable> {
  $$SearchDocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<DateTime> get publicationDate => $composableBuilder(
    column: $table.publicationDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$SearchDocumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SearchDocumentsTable,
          SearchDocument,
          $$SearchDocumentsTableFilterComposer,
          $$SearchDocumentsTableOrderingComposer,
          $$SearchDocumentsTableAnnotationComposer,
          $$SearchDocumentsTableCreateCompanionBuilder,
          $$SearchDocumentsTableUpdateCompanionBuilder,
          (
            SearchDocument,
            BaseReferences<
              _$AppDatabase,
              $SearchDocumentsTable,
              SearchDocument
            >,
          ),
          SearchDocument,
          PrefetchHooks Function()
        > {
  $$SearchDocumentsTableTableManager(
    _$AppDatabase db,
    $SearchDocumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchDocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchDocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchDocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> documentId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<DateTime?> publicationDate = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SearchDocumentsCompanion(
                documentId: documentId,
                title: title,
                author: author,
                publicationDate: publicationDate,
                source: source,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String documentId,
                required String title,
                Value<String?> author = const Value.absent(),
                Value<DateTime?> publicationDate = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SearchDocumentsCompanion.insert(
                documentId: documentId,
                title: title,
                author: author,
                publicationDate: publicationDate,
                source: source,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SearchDocumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SearchDocumentsTable,
      SearchDocument,
      $$SearchDocumentsTableFilterComposer,
      $$SearchDocumentsTableOrderingComposer,
      $$SearchDocumentsTableAnnotationComposer,
      $$SearchDocumentsTableCreateCompanionBuilder,
      $$SearchDocumentsTableUpdateCompanionBuilder,
      (
        SearchDocument,
        BaseReferences<_$AppDatabase, $SearchDocumentsTable, SearchDocument>,
      ),
      SearchDocument,
      PrefetchHooks Function()
    >;
typedef $$PartnerSnapshotsTableCreateCompanionBuilder =
    PartnerSnapshotsCompanion Function({
      required String habitId,
      required String partnerUserId,
      required String username,
      Value<String?> avatarUrl,
      Value<int> currentDuration,
      Value<bool> hasCompletedToday,
      Value<DateTime?> lastNudgeAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$PartnerSnapshotsTableUpdateCompanionBuilder =
    PartnerSnapshotsCompanion Function({
      Value<String> habitId,
      Value<String> partnerUserId,
      Value<String> username,
      Value<String?> avatarUrl,
      Value<int> currentDuration,
      Value<bool> hasCompletedToday,
      Value<DateTime?> lastNudgeAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$PartnerSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $PartnerSnapshotsTable> {
  $$PartnerSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partnerUserId => $composableBuilder(
    column: $table.partnerUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentDuration => $composableBuilder(
    column: $table.currentDuration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasCompletedToday => $composableBuilder(
    column: $table.hasCompletedToday,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastNudgeAt => $composableBuilder(
    column: $table.lastNudgeAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PartnerSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $PartnerSnapshotsTable> {
  $$PartnerSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partnerUserId => $composableBuilder(
    column: $table.partnerUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentDuration => $composableBuilder(
    column: $table.currentDuration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasCompletedToday => $composableBuilder(
    column: $table.hasCompletedToday,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastNudgeAt => $composableBuilder(
    column: $table.lastNudgeAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PartnerSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PartnerSnapshotsTable> {
  $$PartnerSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<String> get partnerUserId => $composableBuilder(
    column: $table.partnerUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<int> get currentDuration => $composableBuilder(
    column: $table.currentDuration,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasCompletedToday => $composableBuilder(
    column: $table.hasCompletedToday,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastNudgeAt => $composableBuilder(
    column: $table.lastNudgeAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$PartnerSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PartnerSnapshotsTable,
          PartnerSnapshot,
          $$PartnerSnapshotsTableFilterComposer,
          $$PartnerSnapshotsTableOrderingComposer,
          $$PartnerSnapshotsTableAnnotationComposer,
          $$PartnerSnapshotsTableCreateCompanionBuilder,
          $$PartnerSnapshotsTableUpdateCompanionBuilder,
          (
            PartnerSnapshot,
            BaseReferences<
              _$AppDatabase,
              $PartnerSnapshotsTable,
              PartnerSnapshot
            >,
          ),
          PartnerSnapshot,
          PrefetchHooks Function()
        > {
  $$PartnerSnapshotsTableTableManager(
    _$AppDatabase db,
    $PartnerSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PartnerSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PartnerSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PartnerSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> habitId = const Value.absent(),
                Value<String> partnerUserId = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<int> currentDuration = const Value.absent(),
                Value<bool> hasCompletedToday = const Value.absent(),
                Value<DateTime?> lastNudgeAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartnerSnapshotsCompanion(
                habitId: habitId,
                partnerUserId: partnerUserId,
                username: username,
                avatarUrl: avatarUrl,
                currentDuration: currentDuration,
                hasCompletedToday: hasCompletedToday,
                lastNudgeAt: lastNudgeAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String habitId,
                required String partnerUserId,
                required String username,
                Value<String?> avatarUrl = const Value.absent(),
                Value<int> currentDuration = const Value.absent(),
                Value<bool> hasCompletedToday = const Value.absent(),
                Value<DateTime?> lastNudgeAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartnerSnapshotsCompanion.insert(
                habitId: habitId,
                partnerUserId: partnerUserId,
                username: username,
                avatarUrl: avatarUrl,
                currentDuration: currentDuration,
                hasCompletedToday: hasCompletedToday,
                lastNudgeAt: lastNudgeAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PartnerSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PartnerSnapshotsTable,
      PartnerSnapshot,
      $$PartnerSnapshotsTableFilterComposer,
      $$PartnerSnapshotsTableOrderingComposer,
      $$PartnerSnapshotsTableAnnotationComposer,
      $$PartnerSnapshotsTableCreateCompanionBuilder,
      $$PartnerSnapshotsTableUpdateCompanionBuilder,
      (
        PartnerSnapshot,
        BaseReferences<_$AppDatabase, $PartnerSnapshotsTable, PartnerSnapshot>,
      ),
      PartnerSnapshot,
      PrefetchHooks Function()
    >;
typedef $$PrivateMessagesTableCreateCompanionBuilder =
    PrivateMessagesCompanion Function({
      required String messageId,
      required String senderId,
      required String recipientId,
      required String message,
      Value<String?> milestoneType,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$PrivateMessagesTableUpdateCompanionBuilder =
    PrivateMessagesCompanion Function({
      Value<String> messageId,
      Value<String> senderId,
      Value<String> recipientId,
      Value<String> message,
      Value<String?> milestoneType,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$PrivateMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $PrivateMessagesTable> {
  $$PrivateMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipientId => $composableBuilder(
    column: $table.recipientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get milestoneType => $composableBuilder(
    column: $table.milestoneType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PrivateMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $PrivateMessagesTable> {
  $$PrivateMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get messageId => $composableBuilder(
    column: $table.messageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderId => $composableBuilder(
    column: $table.senderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipientId => $composableBuilder(
    column: $table.recipientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get milestoneType => $composableBuilder(
    column: $table.milestoneType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PrivateMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PrivateMessagesTable> {
  $$PrivateMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get messageId =>
      $composableBuilder(column: $table.messageId, builder: (column) => column);

  GeneratedColumn<String> get senderId =>
      $composableBuilder(column: $table.senderId, builder: (column) => column);

  GeneratedColumn<String> get recipientId => $composableBuilder(
    column: $table.recipientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<String> get milestoneType => $composableBuilder(
    column: $table.milestoneType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$PrivateMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PrivateMessagesTable,
          PrivateMessage,
          $$PrivateMessagesTableFilterComposer,
          $$PrivateMessagesTableOrderingComposer,
          $$PrivateMessagesTableAnnotationComposer,
          $$PrivateMessagesTableCreateCompanionBuilder,
          $$PrivateMessagesTableUpdateCompanionBuilder,
          (
            PrivateMessage,
            BaseReferences<
              _$AppDatabase,
              $PrivateMessagesTable,
              PrivateMessage
            >,
          ),
          PrivateMessage,
          PrefetchHooks Function()
        > {
  $$PrivateMessagesTableTableManager(
    _$AppDatabase db,
    $PrivateMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PrivateMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PrivateMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PrivateMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> messageId = const Value.absent(),
                Value<String> senderId = const Value.absent(),
                Value<String> recipientId = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<String?> milestoneType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrivateMessagesCompanion(
                messageId: messageId,
                senderId: senderId,
                recipientId: recipientId,
                message: message,
                milestoneType: milestoneType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String messageId,
                required String senderId,
                required String recipientId,
                required String message,
                Value<String?> milestoneType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PrivateMessagesCompanion.insert(
                messageId: messageId,
                senderId: senderId,
                recipientId: recipientId,
                message: message,
                milestoneType: milestoneType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PrivateMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PrivateMessagesTable,
      PrivateMessage,
      $$PrivateMessagesTableFilterComposer,
      $$PrivateMessagesTableOrderingComposer,
      $$PrivateMessagesTableAnnotationComposer,
      $$PrivateMessagesTableCreateCompanionBuilder,
      $$PrivateMessagesTableUpdateCompanionBuilder,
      (
        PrivateMessage,
        BaseReferences<_$AppDatabase, $PrivateMessagesTable, PrivateMessage>,
      ),
      PrivateMessage,
      PrefetchHooks Function()
    >;
typedef $$HabitInvitationsTableCreateCompanionBuilder =
    HabitInvitationsCompanion Function({
      required String invitationId,
      required String requesterId,
      required String recipientId,
      required String habitId,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$HabitInvitationsTableUpdateCompanionBuilder =
    HabitInvitationsCompanion Function({
      Value<String> invitationId,
      Value<String> requesterId,
      Value<String> recipientId,
      Value<String> habitId,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$HabitInvitationsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitInvitationsTable> {
  $$HabitInvitationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get invitationId => $composableBuilder(
    column: $table.invitationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requesterId => $composableBuilder(
    column: $table.requesterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipientId => $composableBuilder(
    column: $table.recipientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HabitInvitationsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitInvitationsTable> {
  $$HabitInvitationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get invitationId => $composableBuilder(
    column: $table.invitationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requesterId => $composableBuilder(
    column: $table.requesterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipientId => $composableBuilder(
    column: $table.recipientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HabitInvitationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitInvitationsTable> {
  $$HabitInvitationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get invitationId => $composableBuilder(
    column: $table.invitationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requesterId => $composableBuilder(
    column: $table.requesterId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recipientId => $composableBuilder(
    column: $table.recipientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$HabitInvitationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitInvitationsTable,
          HabitInvitation,
          $$HabitInvitationsTableFilterComposer,
          $$HabitInvitationsTableOrderingComposer,
          $$HabitInvitationsTableAnnotationComposer,
          $$HabitInvitationsTableCreateCompanionBuilder,
          $$HabitInvitationsTableUpdateCompanionBuilder,
          (
            HabitInvitation,
            BaseReferences<
              _$AppDatabase,
              $HabitInvitationsTable,
              HabitInvitation
            >,
          ),
          HabitInvitation,
          PrefetchHooks Function()
        > {
  $$HabitInvitationsTableTableManager(
    _$AppDatabase db,
    $HabitInvitationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitInvitationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitInvitationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitInvitationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> invitationId = const Value.absent(),
                Value<String> requesterId = const Value.absent(),
                Value<String> recipientId = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitInvitationsCompanion(
                invitationId: invitationId,
                requesterId: requesterId,
                recipientId: recipientId,
                habitId: habitId,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String invitationId,
                required String requesterId,
                required String recipientId,
                required String habitId,
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitInvitationsCompanion.insert(
                invitationId: invitationId,
                requesterId: requesterId,
                recipientId: recipientId,
                habitId: habitId,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HabitInvitationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitInvitationsTable,
      HabitInvitation,
      $$HabitInvitationsTableFilterComposer,
      $$HabitInvitationsTableOrderingComposer,
      $$HabitInvitationsTableAnnotationComposer,
      $$HabitInvitationsTableCreateCompanionBuilder,
      $$HabitInvitationsTableUpdateCompanionBuilder,
      (
        HabitInvitation,
        BaseReferences<_$AppDatabase, $HabitInvitationsTable, HabitInvitation>,
      ),
      HabitInvitation,
      PrefetchHooks Function()
    >;
typedef $$MilestoneEventsTableCreateCompanionBuilder =
    MilestoneEventsCompanion Function({
      required String eventId,
      required String userId,
      required String habitId,
      required String milestoneType,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$MilestoneEventsTableUpdateCompanionBuilder =
    MilestoneEventsCompanion Function({
      Value<String> eventId,
      Value<String> userId,
      Value<String> habitId,
      Value<String> milestoneType,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$MilestoneEventsTableFilterComposer
    extends Composer<_$AppDatabase, $MilestoneEventsTable> {
  $$MilestoneEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get milestoneType => $composableBuilder(
    column: $table.milestoneType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MilestoneEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $MilestoneEventsTable> {
  $$MilestoneEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get eventId => $composableBuilder(
    column: $table.eventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get habitId => $composableBuilder(
    column: $table.habitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get milestoneType => $composableBuilder(
    column: $table.milestoneType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MilestoneEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MilestoneEventsTable> {
  $$MilestoneEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get eventId =>
      $composableBuilder(column: $table.eventId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get habitId =>
      $composableBuilder(column: $table.habitId, builder: (column) => column);

  GeneratedColumn<String> get milestoneType => $composableBuilder(
    column: $table.milestoneType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$MilestoneEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MilestoneEventsTable,
          MilestoneEvent,
          $$MilestoneEventsTableFilterComposer,
          $$MilestoneEventsTableOrderingComposer,
          $$MilestoneEventsTableAnnotationComposer,
          $$MilestoneEventsTableCreateCompanionBuilder,
          $$MilestoneEventsTableUpdateCompanionBuilder,
          (
            MilestoneEvent,
            BaseReferences<
              _$AppDatabase,
              $MilestoneEventsTable,
              MilestoneEvent
            >,
          ),
          MilestoneEvent,
          PrefetchHooks Function()
        > {
  $$MilestoneEventsTableTableManager(
    _$AppDatabase db,
    $MilestoneEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MilestoneEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MilestoneEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MilestoneEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> eventId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<String> milestoneType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MilestoneEventsCompanion(
                eventId: eventId,
                userId: userId,
                habitId: habitId,
                milestoneType: milestoneType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String eventId,
                required String userId,
                required String habitId,
                required String milestoneType,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MilestoneEventsCompanion.insert(
                eventId: eventId,
                userId: userId,
                habitId: habitId,
                milestoneType: milestoneType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MilestoneEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MilestoneEventsTable,
      MilestoneEvent,
      $$MilestoneEventsTableFilterComposer,
      $$MilestoneEventsTableOrderingComposer,
      $$MilestoneEventsTableAnnotationComposer,
      $$MilestoneEventsTableCreateCompanionBuilder,
      $$MilestoneEventsTableUpdateCompanionBuilder,
      (
        MilestoneEvent,
        BaseReferences<_$AppDatabase, $MilestoneEventsTable, MilestoneEvent>,
      ),
      MilestoneEvent,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$LogsTableTableManager get logs => $$LogsTableTableManager(_db, _db.logs);
  $$PartnershipsTableTableManager get partnerships =>
      $$PartnershipsTableTableManager(_db, _db.partnerships);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$CachedQuotesTableTableManager get cachedQuotes =>
      $$CachedQuotesTableTableManager(_db, _db.cachedQuotes);
  $$SearchDocumentsTableTableManager get searchDocuments =>
      $$SearchDocumentsTableTableManager(_db, _db.searchDocuments);
  $$PartnerSnapshotsTableTableManager get partnerSnapshots =>
      $$PartnerSnapshotsTableTableManager(_db, _db.partnerSnapshots);
  $$PrivateMessagesTableTableManager get privateMessages =>
      $$PrivateMessagesTableTableManager(_db, _db.privateMessages);
  $$HabitInvitationsTableTableManager get habitInvitations =>
      $$HabitInvitationsTableTableManager(_db, _db.habitInvitations);
  $$MilestoneEventsTableTableManager get milestoneEvents =>
      $$MilestoneEventsTableTableManager(_db, _db.milestoneEvents);
}
