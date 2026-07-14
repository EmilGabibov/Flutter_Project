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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailVerifiedAtMeta = const VerificationMeta(
    'emailVerifiedAt',
  );
  @override
  late final GeneratedColumn<DateTime> emailVerifiedAt =
      GeneratedColumn<DateTime>(
        'email_verified_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
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
  static const VerificationMeta _levelNameMeta = const VerificationMeta(
    'levelName',
  );
  @override
  late final GeneratedColumn<String> levelName = GeneratedColumn<String>(
    'level_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Newbie'),
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
    email,
    emailVerifiedAt,
    avatarUrl,
    levelName,
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
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('email_verified_at')) {
      context.handle(
        _emailVerifiedAtMeta,
        emailVerifiedAt.isAcceptableOrUnknown(
          data['email_verified_at']!,
          _emailVerifiedAtMeta,
        ),
      );
    }
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('level_name')) {
      context.handle(
        _levelNameMeta,
        levelName.isAcceptableOrUnknown(data['level_name']!, _levelNameMeta),
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
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      emailVerifiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}email_verified_at'],
      ),
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      levelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level_name'],
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
  final String? email;
  final DateTime? emailVerifiedAt;
  final String? avatarUrl;
  final String levelName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalScore;
  final bool isSynced;
  const User({
    required this.userId,
    required this.username,
    this.email,
    this.emailVerifiedAt,
    this.avatarUrl,
    required this.levelName,
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
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || emailVerifiedAt != null) {
      map['email_verified_at'] = Variable<DateTime>(emailVerifiedAt);
    }
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['level_name'] = Variable<String>(levelName);
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
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      emailVerifiedAt: emailVerifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(emailVerifiedAt),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      levelName: Value(levelName),
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
      email: serializer.fromJson<String?>(json['email']),
      emailVerifiedAt: serializer.fromJson<DateTime?>(json['emailVerifiedAt']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      levelName: serializer.fromJson<String>(json['levelName']),
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
      'email': serializer.toJson<String?>(email),
      'emailVerifiedAt': serializer.toJson<DateTime?>(emailVerifiedAt),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'levelName': serializer.toJson<String>(levelName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'totalScore': serializer.toJson<int>(totalScore),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  User copyWith({
    String? userId,
    String? username,
    Value<String?> email = const Value.absent(),
    Value<DateTime?> emailVerifiedAt = const Value.absent(),
    Value<String?> avatarUrl = const Value.absent(),
    String? levelName,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? totalScore,
    bool? isSynced,
  }) => User(
    userId: userId ?? this.userId,
    username: username ?? this.username,
    email: email.present ? email.value : this.email,
    emailVerifiedAt: emailVerifiedAt.present
        ? emailVerifiedAt.value
        : this.emailVerifiedAt,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    levelName: levelName ?? this.levelName,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    totalScore: totalScore ?? this.totalScore,
    isSynced: isSynced ?? this.isSynced,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      userId: data.userId.present ? data.userId.value : this.userId,
      username: data.username.present ? data.username.value : this.username,
      email: data.email.present ? data.email.value : this.email,
      emailVerifiedAt: data.emailVerifiedAt.present
          ? data.emailVerifiedAt.value
          : this.emailVerifiedAt,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      levelName: data.levelName.present ? data.levelName.value : this.levelName,
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
          ..write('email: $email, ')
          ..write('emailVerifiedAt: $emailVerifiedAt, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('levelName: $levelName, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('totalScore: $totalScore, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    username,
    email,
    emailVerifiedAt,
    avatarUrl,
    levelName,
    createdAt,
    updatedAt,
    totalScore,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.userId == this.userId &&
          other.username == this.username &&
          other.email == this.email &&
          other.emailVerifiedAt == this.emailVerifiedAt &&
          other.avatarUrl == this.avatarUrl &&
          other.levelName == this.levelName &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.totalScore == this.totalScore &&
          other.isSynced == this.isSynced);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> userId;
  final Value<String> username;
  final Value<String?> email;
  final Value<DateTime?> emailVerifiedAt;
  final Value<String?> avatarUrl;
  final Value<String> levelName;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> totalScore;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const UsersCompanion({
    this.userId = const Value.absent(),
    this.username = const Value.absent(),
    this.email = const Value.absent(),
    this.emailVerifiedAt = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.levelName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.totalScore = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String userId,
    required String username,
    this.email = const Value.absent(),
    this.emailVerifiedAt = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.levelName = const Value.absent(),
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
    Expression<String>? email,
    Expression<DateTime>? emailVerifiedAt,
    Expression<String>? avatarUrl,
    Expression<String>? levelName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? totalScore,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (username != null) 'username': username,
      if (email != null) 'email': email,
      if (emailVerifiedAt != null) 'email_verified_at': emailVerifiedAt,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (levelName != null) 'level_name': levelName,
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
    Value<String?>? email,
    Value<DateTime?>? emailVerifiedAt,
    Value<String?>? avatarUrl,
    Value<String>? levelName,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? totalScore,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      levelName: levelName ?? this.levelName,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (emailVerifiedAt.present) {
      map['email_verified_at'] = Variable<DateTime>(emailVerifiedAt.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (levelName.present) {
      map['level_name'] = Variable<String>(levelName.value);
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
          ..write('email: $email, ')
          ..write('emailVerifiedAt: $emailVerifiedAt, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('levelName: $levelName, ')
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    habitId,
    userId,
    title,
    description,
    isCustom,
    targetDuration,
    currentDuration,
    status,
    colorHex,
    createdAt,
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
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
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
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
  final String? description;
  final bool isCustom;
  final int targetDuration;
  final int currentDuration;
  final HabitStatus status;

  /// Hex color string (e.g. 'FF9CAF88') for ring/avatar tinting. Assigned on
  /// creation from a fixed pastel palette; never null after migration.
  final String colorHex;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSynced;
  const Habit({
    required this.habitId,
    required this.userId,
    required this.title,
    this.description,
    required this.isCustom,
    required this.targetDuration,
    required this.currentDuration,
    required this.status,
    required this.colorHex,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['habit_id'] = Variable<String>(habitId);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    map['target_duration'] = Variable<int>(targetDuration);
    map['current_duration'] = Variable<int>(currentDuration);
    {
      map['status'] = Variable<String>(
        $HabitsTable.$converterstatus.toSql(status),
      );
    }
    map['color_hex'] = Variable<String>(colorHex);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      habitId: Value(habitId),
      userId: Value(userId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      isCustom: Value(isCustom),
      targetDuration: Value(targetDuration),
      currentDuration: Value(currentDuration),
      status: Value(status),
      colorHex: Value(colorHex),
      createdAt: Value(createdAt),
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
      description: serializer.fromJson<String?>(json['description']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      targetDuration: serializer.fromJson<int>(json['targetDuration']),
      currentDuration: serializer.fromJson<int>(json['currentDuration']),
      status: $HabitsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
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
      'description': serializer.toJson<String?>(description),
      'isCustom': serializer.toJson<bool>(isCustom),
      'targetDuration': serializer.toJson<int>(targetDuration),
      'currentDuration': serializer.toJson<int>(currentDuration),
      'status': serializer.toJson<String>(
        $HabitsTable.$converterstatus.toJson(status),
      ),
      'colorHex': serializer.toJson<String>(colorHex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Habit copyWith({
    String? habitId,
    String? userId,
    String? title,
    Value<String?> description = const Value.absent(),
    bool? isCustom,
    int? targetDuration,
    int? currentDuration,
    HabitStatus? status,
    String? colorHex,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => Habit(
    habitId: habitId ?? this.habitId,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    isCustom: isCustom ?? this.isCustom,
    targetDuration: targetDuration ?? this.targetDuration,
    currentDuration: currentDuration ?? this.currentDuration,
    status: status ?? this.status,
    colorHex: colorHex ?? this.colorHex,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  Habit copyWithCompanion(HabitsCompanion data) {
    return Habit(
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      targetDuration: data.targetDuration.present
          ? data.targetDuration.value
          : this.targetDuration,
      currentDuration: data.currentDuration.present
          ? data.currentDuration.value
          : this.currentDuration,
      status: data.status.present ? data.status.value : this.status,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
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
          ..write('description: $description, ')
          ..write('isCustom: $isCustom, ')
          ..write('targetDuration: $targetDuration, ')
          ..write('currentDuration: $currentDuration, ')
          ..write('status: $status, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt, ')
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
    description,
    isCustom,
    targetDuration,
    currentDuration,
    status,
    colorHex,
    createdAt,
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
          other.description == this.description &&
          other.isCustom == this.isCustom &&
          other.targetDuration == this.targetDuration &&
          other.currentDuration == this.currentDuration &&
          other.status == this.status &&
          other.colorHex == this.colorHex &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<String> habitId;
  final Value<String> userId;
  final Value<String> title;
  final Value<String?> description;
  final Value<bool> isCustom;
  final Value<int> targetDuration;
  final Value<int> currentDuration;
  final Value<HabitStatus> status;
  final Value<String> colorHex;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const HabitsCompanion({
    this.habitId = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.targetDuration = const Value.absent(),
    this.currentDuration = const Value.absent(),
    this.status = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String habitId,
    required String userId,
    required String title,
    this.description = const Value.absent(),
    this.isCustom = const Value.absent(),
    required int targetDuration,
    required int currentDuration,
    required HabitStatus status,
    this.colorHex = const Value.absent(),
    this.createdAt = const Value.absent(),
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
    Expression<String>? description,
    Expression<bool>? isCustom,
    Expression<int>? targetDuration,
    Expression<int>? currentDuration,
    Expression<String>? status,
    Expression<String>? colorHex,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (habitId != null) 'habit_id': habitId,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (isCustom != null) 'is_custom': isCustom,
      if (targetDuration != null) 'target_duration': targetDuration,
      if (currentDuration != null) 'current_duration': currentDuration,
      if (status != null) 'status': status,
      if (colorHex != null) 'color_hex': colorHex,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? habitId,
    Value<String>? userId,
    Value<String>? title,
    Value<String?>? description,
    Value<bool>? isCustom,
    Value<int>? targetDuration,
    Value<int>? currentDuration,
    Value<HabitStatus>? status,
    Value<String>? colorHex,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      habitId: habitId ?? this.habitId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isCustom: isCustom ?? this.isCustom,
      targetDuration: targetDuration ?? this.targetDuration,
      currentDuration: currentDuration ?? this.currentDuration,
      status: status ?? this.status,
      colorHex: colorHex ?? this.colorHex,
      createdAt: createdAt ?? this.createdAt,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
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
    return (StringBuffer('HabitsCompanion(')
          ..write('habitId: $habitId, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('isCustom: $isCustom, ')
          ..write('targetDuration: $targetDuration, ')
          ..write('currentDuration: $currentDuration, ')
          ..write('status: $status, ')
          ..write('colorHex: $colorHex, ')
          ..write('createdAt: $createdAt, ')
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
  static const VerificationMeta _pointsAwardedMeta = const VerificationMeta(
    'pointsAwarded',
  );
  @override
  late final GeneratedColumn<int> pointsAwarded = GeneratedColumn<int>(
    'points_awarded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
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
    pointsAwarded,
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
    if (data.containsKey('points_awarded')) {
      context.handle(
        _pointsAwardedMeta,
        pointsAwarded.isAcceptableOrUnknown(
          data['points_awarded']!,
          _pointsAwardedMeta,
        ),
      );
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
      pointsAwarded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points_awarded'],
      )!,
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
  final int pointsAwarded;
  final String? journalNote;
  final DateTime updatedAt;
  final bool isSynced;
  const Log({
    required this.logId,
    required this.habitId,
    required this.actionDate,
    required this.status,
    required this.pointsAwarded,
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
    map['points_awarded'] = Variable<int>(pointsAwarded);
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
      pointsAwarded: Value(pointsAwarded),
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
      pointsAwarded: serializer.fromJson<int>(json['pointsAwarded']),
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
      'pointsAwarded': serializer.toJson<int>(pointsAwarded),
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
    int? pointsAwarded,
    Value<String?> journalNote = const Value.absent(),
    DateTime? updatedAt,
    bool? isSynced,
  }) => Log(
    logId: logId ?? this.logId,
    habitId: habitId ?? this.habitId,
    actionDate: actionDate ?? this.actionDate,
    status: status ?? this.status,
    pointsAwarded: pointsAwarded ?? this.pointsAwarded,
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
      pointsAwarded: data.pointsAwarded.present
          ? data.pointsAwarded.value
          : this.pointsAwarded,
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
          ..write('pointsAwarded: $pointsAwarded, ')
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
    pointsAwarded,
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
          other.pointsAwarded == this.pointsAwarded &&
          other.journalNote == this.journalNote &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class LogsCompanion extends UpdateCompanion<Log> {
  final Value<String> logId;
  final Value<String> habitId;
  final Value<DateTime> actionDate;
  final Value<LogStatus> status;
  final Value<int> pointsAwarded;
  final Value<String?> journalNote;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const LogsCompanion({
    this.logId = const Value.absent(),
    this.habitId = const Value.absent(),
    this.actionDate = const Value.absent(),
    this.status = const Value.absent(),
    this.pointsAwarded = const Value.absent(),
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
    this.pointsAwarded = const Value.absent(),
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
    Expression<int>? pointsAwarded,
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
      if (pointsAwarded != null) 'points_awarded': pointsAwarded,
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
    Value<int>? pointsAwarded,
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
      pointsAwarded: pointsAwarded ?? this.pointsAwarded,
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
    if (pointsAwarded.present) {
      map['points_awarded'] = Variable<int>(pointsAwarded.value);
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
          ..write('pointsAwarded: $pointsAwarded, ')
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
  @override
  late final GeneratedColumnWithTypeConverter<PartnershipRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('partner'),
      ).withConverter<PartnershipRole>($PartnershipsTable.$converterrole);
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
    role,
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
      role: $PartnershipsTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
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
  $PartnershipsTable createAlias(String alias) {
    return $PartnershipsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PartnershipRole, String, String> $converterrole =
      const EnumNameConverter<PartnershipRole>(PartnershipRole.values);
}

class Partnership extends DataClass implements Insertable<Partnership> {
  final String partnershipId;
  final String habitId;
  final String partnerUserId;
  final PartnershipRole role;
  final DateTime updatedAt;
  final bool isSynced;
  const Partnership({
    required this.partnershipId,
    required this.habitId,
    required this.partnerUserId,
    required this.role,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['partnership_id'] = Variable<String>(partnershipId);
    map['habit_id'] = Variable<String>(habitId);
    map['partner_user_id'] = Variable<String>(partnerUserId);
    {
      map['role'] = Variable<String>(
        $PartnershipsTable.$converterrole.toSql(role),
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  PartnershipsCompanion toCompanion(bool nullToAbsent) {
    return PartnershipsCompanion(
      partnershipId: Value(partnershipId),
      habitId: Value(habitId),
      partnerUserId: Value(partnerUserId),
      role: Value(role),
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
      role: $PartnershipsTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
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
      'role': serializer.toJson<String>(
        $PartnershipsTable.$converterrole.toJson(role),
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Partnership copyWith({
    String? partnershipId,
    String? habitId,
    String? partnerUserId,
    PartnershipRole? role,
    DateTime? updatedAt,
    bool? isSynced,
  }) => Partnership(
    partnershipId: partnershipId ?? this.partnershipId,
    habitId: habitId ?? this.habitId,
    partnerUserId: partnerUserId ?? this.partnerUserId,
    role: role ?? this.role,
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
      role: data.role.present ? data.role.value : this.role,
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
          ..write('role: $role, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    partnershipId,
    habitId,
    partnerUserId,
    role,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Partnership &&
          other.partnershipId == this.partnershipId &&
          other.habitId == this.habitId &&
          other.partnerUserId == this.partnerUserId &&
          other.role == this.role &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class PartnershipsCompanion extends UpdateCompanion<Partnership> {
  final Value<String> partnershipId;
  final Value<String> habitId;
  final Value<String> partnerUserId;
  final Value<PartnershipRole> role;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const PartnershipsCompanion({
    this.partnershipId = const Value.absent(),
    this.habitId = const Value.absent(),
    this.partnerUserId = const Value.absent(),
    this.role = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PartnershipsCompanion.insert({
    required String partnershipId,
    required String habitId,
    required String partnerUserId,
    this.role = const Value.absent(),
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
    Expression<String>? role,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (partnershipId != null) 'partnership_id': partnershipId,
      if (habitId != null) 'habit_id': habitId,
      if (partnerUserId != null) 'partner_user_id': partnerUserId,
      if (role != null) 'role': role,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PartnershipsCompanion copyWith({
    Value<String>? partnershipId,
    Value<String>? habitId,
    Value<String>? partnerUserId,
    Value<PartnershipRole>? role,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return PartnershipsCompanion(
      partnershipId: partnershipId ?? this.partnershipId,
      habitId: habitId ?? this.habitId,
      partnerUserId: partnerUserId ?? this.partnerUserId,
      role: role ?? this.role,
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
    if (role.present) {
      map['role'] = Variable<String>(
        $PartnershipsTable.$converterrole.toSql(role.value),
      );
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
          ..write('role: $role, ')
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
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  List<GeneratedColumn> get $columns => [id, quoteText, author, fetchedAt];
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
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
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
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
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
  final String? author;
  final DateTime fetchedAt;
  const CachedQuote({
    required this.id,
    required this.quoteText,
    this.author,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['quote_text'] = Variable<String>(quoteText);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CachedQuotesCompanion toCompanion(bool nullToAbsent) {
    return CachedQuotesCompanion(
      id: Value(id),
      quoteText: Value(quoteText),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
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
      author: serializer.fromJson<String?>(json['author']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'quoteText': serializer.toJson<String>(quoteText),
      'author': serializer.toJson<String?>(author),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CachedQuote copyWith({
    int? id,
    String? quoteText,
    Value<String?> author = const Value.absent(),
    DateTime? fetchedAt,
  }) => CachedQuote(
    id: id ?? this.id,
    quoteText: quoteText ?? this.quoteText,
    author: author.present ? author.value : this.author,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CachedQuote copyWithCompanion(CachedQuotesCompanion data) {
    return CachedQuote(
      id: data.id.present ? data.id.value : this.id,
      quoteText: data.quoteText.present ? data.quoteText.value : this.quoteText,
      author: data.author.present ? data.author.value : this.author,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedQuote(')
          ..write('id: $id, ')
          ..write('quoteText: $quoteText, ')
          ..write('author: $author, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, quoteText, author, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedQuote &&
          other.id == this.id &&
          other.quoteText == this.quoteText &&
          other.author == this.author &&
          other.fetchedAt == this.fetchedAt);
}

class CachedQuotesCompanion extends UpdateCompanion<CachedQuote> {
  final Value<int> id;
  final Value<String> quoteText;
  final Value<String?> author;
  final Value<DateTime> fetchedAt;
  const CachedQuotesCompanion({
    this.id = const Value.absent(),
    this.quoteText = const Value.absent(),
    this.author = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  });
  CachedQuotesCompanion.insert({
    this.id = const Value.absent(),
    required String quoteText,
    this.author = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  }) : quoteText = Value(quoteText);
  static Insertable<CachedQuote> custom({
    Expression<int>? id,
    Expression<String>? quoteText,
    Expression<String>? author,
    Expression<DateTime>? fetchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (quoteText != null) 'quote_text': quoteText,
      if (author != null) 'author': author,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
    });
  }

  CachedQuotesCompanion copyWith({
    Value<int>? id,
    Value<String>? quoteText,
    Value<String?>? author,
    Value<DateTime>? fetchedAt,
  }) {
    return CachedQuotesCompanion(
      id: id ?? this.id,
      quoteText: quoteText ?? this.quoteText,
      author: author ?? this.author,
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
    if (author.present) {
      map['author'] = Variable<String>(author.value);
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
          ..write('author: $author, ')
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
  @override
  late final GeneratedColumnWithTypeConverter<PartnershipRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('partner'),
      ).withConverter<PartnershipRole>($PartnerSnapshotsTable.$converterrole);
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
    role,
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
      role: $PartnerSnapshotsTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
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

  static JsonTypeConverter2<PartnershipRole, String, String> $converterrole =
      const EnumNameConverter<PartnershipRole>(PartnershipRole.values);
}

class PartnerSnapshot extends DataClass implements Insertable<PartnerSnapshot> {
  final String habitId;
  final String partnerUserId;
  final String username;
  final String? avatarUrl;
  final PartnershipRole role;
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
    required this.role,
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
    {
      map['role'] = Variable<String>(
        $PartnerSnapshotsTable.$converterrole.toSql(role),
      );
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
      role: Value(role),
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
      role: $PartnerSnapshotsTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
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
      'role': serializer.toJson<String>(
        $PartnerSnapshotsTable.$converterrole.toJson(role),
      ),
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
    PartnershipRole? role,
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
    role: role ?? this.role,
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
      role: data.role.present ? data.role.value : this.role,
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
          ..write('role: $role, ')
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
    role,
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
          other.role == this.role &&
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
  final Value<PartnershipRole> role;
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
    this.role = const Value.absent(),
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
    this.role = const Value.absent(),
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
    Expression<String>? role,
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
      if (role != null) 'role': role,
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
    Value<PartnershipRole>? role,
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
      role: role ?? this.role,
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
    if (role.present) {
      map['role'] = Variable<String>(
        $PartnerSnapshotsTable.$converterrole.toSql(role.value),
      );
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
          ..write('role: $role, ')
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

class $AcceptedFriendsTable extends AcceptedFriends
    with TableInfo<$AcceptedFriendsTable, AcceptedFriend> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AcceptedFriendsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _friendUserIdMeta = const VerificationMeta(
    'friendUserId',
  );
  @override
  late final GeneratedColumn<String> friendUserId = GeneratedColumn<String>(
    'friend_user_id',
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
    friendUserId,
    username,
    avatarUrl,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accepted_friends';
  @override
  VerificationContext validateIntegrity(
    Insertable<AcceptedFriend> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('friend_user_id')) {
      context.handle(
        _friendUserIdMeta,
        friendUserId.isAcceptableOrUnknown(
          data['friend_user_id']!,
          _friendUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_friendUserIdMeta);
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
  Set<GeneratedColumn> get $primaryKey => {friendUserId};
  @override
  AcceptedFriend map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AcceptedFriend(
      friendUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}friend_user_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
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
  $AcceptedFriendsTable createAlias(String alias) {
    return $AcceptedFriendsTable(attachedDatabase, alias);
  }
}

class AcceptedFriend extends DataClass implements Insertable<AcceptedFriend> {
  final String friendUserId;
  final String username;
  final String? avatarUrl;
  final DateTime updatedAt;
  final bool isSynced;
  const AcceptedFriend({
    required this.friendUserId,
    required this.username,
    this.avatarUrl,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['friend_user_id'] = Variable<String>(friendUserId);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  AcceptedFriendsCompanion toCompanion(bool nullToAbsent) {
    return AcceptedFriendsCompanion(
      friendUserId: Value(friendUserId),
      username: Value(username),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory AcceptedFriend.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AcceptedFriend(
      friendUserId: serializer.fromJson<String>(json['friendUserId']),
      username: serializer.fromJson<String>(json['username']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'friendUserId': serializer.toJson<String>(friendUserId),
      'username': serializer.toJson<String>(username),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  AcceptedFriend copyWith({
    String? friendUserId,
    String? username,
    Value<String?> avatarUrl = const Value.absent(),
    DateTime? updatedAt,
    bool? isSynced,
  }) => AcceptedFriend(
    friendUserId: friendUserId ?? this.friendUserId,
    username: username ?? this.username,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  AcceptedFriend copyWithCompanion(AcceptedFriendsCompanion data) {
    return AcceptedFriend(
      friendUserId: data.friendUserId.present
          ? data.friendUserId.value
          : this.friendUserId,
      username: data.username.present ? data.username.value : this.username,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AcceptedFriend(')
          ..write('friendUserId: $friendUserId, ')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(friendUserId, username, avatarUrl, updatedAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AcceptedFriend &&
          other.friendUserId == this.friendUserId &&
          other.username == this.username &&
          other.avatarUrl == this.avatarUrl &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class AcceptedFriendsCompanion extends UpdateCompanion<AcceptedFriend> {
  final Value<String> friendUserId;
  final Value<String> username;
  final Value<String?> avatarUrl;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const AcceptedFriendsCompanion({
    this.friendUserId = const Value.absent(),
    this.username = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AcceptedFriendsCompanion.insert({
    required String friendUserId,
    required String username,
    this.avatarUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : friendUserId = Value(friendUserId),
       username = Value(username);
  static Insertable<AcceptedFriend> custom({
    Expression<String>? friendUserId,
    Expression<String>? username,
    Expression<String>? avatarUrl,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (friendUserId != null) 'friend_user_id': friendUserId,
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AcceptedFriendsCompanion copyWith({
    Value<String>? friendUserId,
    Value<String>? username,
    Value<String?>? avatarUrl,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return AcceptedFriendsCompanion(
      friendUserId: friendUserId ?? this.friendUserId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (friendUserId.present) {
      map['friend_user_id'] = Variable<String>(friendUserId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
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
    return (StringBuffer('AcceptedFriendsCompanion(')
          ..write('friendUserId: $friendUserId, ')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FriendRelationshipsTable extends FriendRelationships
    with TableInfo<$FriendRelationshipsTable, FriendRelationship> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FriendRelationshipsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _relationshipStateMeta = const VerificationMeta(
    'relationshipState',
  );
  @override
  late final GeneratedColumn<String> relationshipState =
      GeneratedColumn<String>(
        'relationship_state',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('none'),
      );
  static const VerificationMeta _requestIdMeta = const VerificationMeta(
    'requestId',
  );
  @override
  late final GeneratedColumn<String> requestId = GeneratedColumn<String>(
    'request_id',
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
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    username,
    avatarUrl,
    relationshipState,
    requestId,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'friend_relationships';
  @override
  VerificationContext validateIntegrity(
    Insertable<FriendRelationship> instance, {
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
    if (data.containsKey('avatar_url')) {
      context.handle(
        _avatarUrlMeta,
        avatarUrl.isAcceptableOrUnknown(data['avatar_url']!, _avatarUrlMeta),
      );
    }
    if (data.containsKey('relationship_state')) {
      context.handle(
        _relationshipStateMeta,
        relationshipState.isAcceptableOrUnknown(
          data['relationship_state']!,
          _relationshipStateMeta,
        ),
      );
    }
    if (data.containsKey('request_id')) {
      context.handle(
        _requestIdMeta,
        requestId.isAcceptableOrUnknown(data['request_id']!, _requestIdMeta),
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
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  FriendRelationship map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FriendRelationship(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      avatarUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_url'],
      ),
      relationshipState: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}relationship_state'],
      )!,
      requestId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}request_id'],
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
  $FriendRelationshipsTable createAlias(String alias) {
    return $FriendRelationshipsTable(attachedDatabase, alias);
  }
}

class FriendRelationship extends DataClass
    implements Insertable<FriendRelationship> {
  final String userId;
  final String username;
  final String? avatarUrl;
  final String relationshipState;
  final String? requestId;
  final DateTime updatedAt;
  final bool isSynced;
  const FriendRelationship({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.relationshipState,
    this.requestId,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['username'] = Variable<String>(username);
    if (!nullToAbsent || avatarUrl != null) {
      map['avatar_url'] = Variable<String>(avatarUrl);
    }
    map['relationship_state'] = Variable<String>(relationshipState);
    if (!nullToAbsent || requestId != null) {
      map['request_id'] = Variable<String>(requestId);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  FriendRelationshipsCompanion toCompanion(bool nullToAbsent) {
    return FriendRelationshipsCompanion(
      userId: Value(userId),
      username: Value(username),
      avatarUrl: avatarUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarUrl),
      relationshipState: Value(relationshipState),
      requestId: requestId == null && nullToAbsent
          ? const Value.absent()
          : Value(requestId),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory FriendRelationship.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FriendRelationship(
      userId: serializer.fromJson<String>(json['userId']),
      username: serializer.fromJson<String>(json['username']),
      avatarUrl: serializer.fromJson<String?>(json['avatarUrl']),
      relationshipState: serializer.fromJson<String>(json['relationshipState']),
      requestId: serializer.fromJson<String?>(json['requestId']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'username': serializer.toJson<String>(username),
      'avatarUrl': serializer.toJson<String?>(avatarUrl),
      'relationshipState': serializer.toJson<String>(relationshipState),
      'requestId': serializer.toJson<String?>(requestId),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  FriendRelationship copyWith({
    String? userId,
    String? username,
    Value<String?> avatarUrl = const Value.absent(),
    String? relationshipState,
    Value<String?> requestId = const Value.absent(),
    DateTime? updatedAt,
    bool? isSynced,
  }) => FriendRelationship(
    userId: userId ?? this.userId,
    username: username ?? this.username,
    avatarUrl: avatarUrl.present ? avatarUrl.value : this.avatarUrl,
    relationshipState: relationshipState ?? this.relationshipState,
    requestId: requestId.present ? requestId.value : this.requestId,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  FriendRelationship copyWithCompanion(FriendRelationshipsCompanion data) {
    return FriendRelationship(
      userId: data.userId.present ? data.userId.value : this.userId,
      username: data.username.present ? data.username.value : this.username,
      avatarUrl: data.avatarUrl.present ? data.avatarUrl.value : this.avatarUrl,
      relationshipState: data.relationshipState.present
          ? data.relationshipState.value
          : this.relationshipState,
      requestId: data.requestId.present ? data.requestId.value : this.requestId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FriendRelationship(')
          ..write('userId: $userId, ')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('relationshipState: $relationshipState, ')
          ..write('requestId: $requestId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    username,
    avatarUrl,
    relationshipState,
    requestId,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FriendRelationship &&
          other.userId == this.userId &&
          other.username == this.username &&
          other.avatarUrl == this.avatarUrl &&
          other.relationshipState == this.relationshipState &&
          other.requestId == this.requestId &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class FriendRelationshipsCompanion extends UpdateCompanion<FriendRelationship> {
  final Value<String> userId;
  final Value<String> username;
  final Value<String?> avatarUrl;
  final Value<String> relationshipState;
  final Value<String?> requestId;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const FriendRelationshipsCompanion({
    this.userId = const Value.absent(),
    this.username = const Value.absent(),
    this.avatarUrl = const Value.absent(),
    this.relationshipState = const Value.absent(),
    this.requestId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FriendRelationshipsCompanion.insert({
    required String userId,
    required String username,
    this.avatarUrl = const Value.absent(),
    this.relationshipState = const Value.absent(),
    this.requestId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       username = Value(username);
  static Insertable<FriendRelationship> custom({
    Expression<String>? userId,
    Expression<String>? username,
    Expression<String>? avatarUrl,
    Expression<String>? relationshipState,
    Expression<String>? requestId,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (username != null) 'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (relationshipState != null) 'relationship_state': relationshipState,
      if (requestId != null) 'request_id': requestId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FriendRelationshipsCompanion copyWith({
    Value<String>? userId,
    Value<String>? username,
    Value<String?>? avatarUrl,
    Value<String>? relationshipState,
    Value<String?>? requestId,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return FriendRelationshipsCompanion(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      relationshipState: relationshipState ?? this.relationshipState,
      requestId: requestId ?? this.requestId,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (avatarUrl.present) {
      map['avatar_url'] = Variable<String>(avatarUrl.value);
    }
    if (relationshipState.present) {
      map['relationship_state'] = Variable<String>(relationshipState.value);
    }
    if (requestId.present) {
      map['request_id'] = Variable<String>(requestId.value);
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
    return (StringBuffer('FriendRelationshipsCompanion(')
          ..write('userId: $userId, ')
          ..write('username: $username, ')
          ..write('avatarUrl: $avatarUrl, ')
          ..write('relationshipState: $relationshipState, ')
          ..write('requestId: $requestId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementUnlocksTable extends AchievementUnlocks
    with TableInfo<$AchievementUnlocksTable, AchievementUnlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementUnlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _achievementIdMeta = const VerificationMeta(
    'achievementId',
  );
  @override
  late final GeneratedColumn<String> achievementId = GeneratedColumn<String>(
    'achievement_id',
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
  static const VerificationMeta _sourceEventIdMeta = const VerificationMeta(
    'sourceEventId',
  );
  @override
  late final GeneratedColumn<String> sourceEventId = GeneratedColumn<String>(
    'source_event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unlockedAtMeta = const VerificationMeta(
    'unlockedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unlockedAt = GeneratedColumn<DateTime>(
    'unlocked_at',
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
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    achievementId,
    userId,
    sourceEventId,
    unlockedAt,
    updatedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievement_unlocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<AchievementUnlock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('achievement_id')) {
      context.handle(
        _achievementIdMeta,
        achievementId.isAcceptableOrUnknown(
          data['achievement_id']!,
          _achievementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievementIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('source_event_id')) {
      context.handle(
        _sourceEventIdMeta,
        sourceEventId.isAcceptableOrUnknown(
          data['source_event_id']!,
          _sourceEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceEventIdMeta);
    }
    if (data.containsKey('unlocked_at')) {
      context.handle(
        _unlockedAtMeta,
        unlockedAt.isAcceptableOrUnknown(data['unlocked_at']!, _unlockedAtMeta),
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
  Set<GeneratedColumn> get $primaryKey => {userId, achievementId};
  @override
  AchievementUnlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementUnlock(
      achievementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}achievement_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      sourceEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_event_id'],
      )!,
      unlockedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unlocked_at'],
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
  $AchievementUnlocksTable createAlias(String alias) {
    return $AchievementUnlocksTable(attachedDatabase, alias);
  }
}

class AchievementUnlock extends DataClass
    implements Insertable<AchievementUnlock> {
  final String achievementId;
  final String userId;
  final String sourceEventId;
  final DateTime unlockedAt;
  final DateTime updatedAt;
  final bool isSynced;
  const AchievementUnlock({
    required this.achievementId,
    required this.userId,
    required this.sourceEventId,
    required this.unlockedAt,
    required this.updatedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['achievement_id'] = Variable<String>(achievementId);
    map['user_id'] = Variable<String>(userId);
    map['source_event_id'] = Variable<String>(sourceEventId);
    map['unlocked_at'] = Variable<DateTime>(unlockedAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  AchievementUnlocksCompanion toCompanion(bool nullToAbsent) {
    return AchievementUnlocksCompanion(
      achievementId: Value(achievementId),
      userId: Value(userId),
      sourceEventId: Value(sourceEventId),
      unlockedAt: Value(unlockedAt),
      updatedAt: Value(updatedAt),
      isSynced: Value(isSynced),
    );
  }

  factory AchievementUnlock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementUnlock(
      achievementId: serializer.fromJson<String>(json['achievementId']),
      userId: serializer.fromJson<String>(json['userId']),
      sourceEventId: serializer.fromJson<String>(json['sourceEventId']),
      unlockedAt: serializer.fromJson<DateTime>(json['unlockedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'achievementId': serializer.toJson<String>(achievementId),
      'userId': serializer.toJson<String>(userId),
      'sourceEventId': serializer.toJson<String>(sourceEventId),
      'unlockedAt': serializer.toJson<DateTime>(unlockedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  AchievementUnlock copyWith({
    String? achievementId,
    String? userId,
    String? sourceEventId,
    DateTime? unlockedAt,
    DateTime? updatedAt,
    bool? isSynced,
  }) => AchievementUnlock(
    achievementId: achievementId ?? this.achievementId,
    userId: userId ?? this.userId,
    sourceEventId: sourceEventId ?? this.sourceEventId,
    unlockedAt: unlockedAt ?? this.unlockedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  AchievementUnlock copyWithCompanion(AchievementUnlocksCompanion data) {
    return AchievementUnlock(
      achievementId: data.achievementId.present
          ? data.achievementId.value
          : this.achievementId,
      userId: data.userId.present ? data.userId.value : this.userId,
      sourceEventId: data.sourceEventId.present
          ? data.sourceEventId.value
          : this.sourceEventId,
      unlockedAt: data.unlockedAt.present
          ? data.unlockedAt.value
          : this.unlockedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementUnlock(')
          ..write('achievementId: $achievementId, ')
          ..write('userId: $userId, ')
          ..write('sourceEventId: $sourceEventId, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    achievementId,
    userId,
    sourceEventId,
    unlockedAt,
    updatedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementUnlock &&
          other.achievementId == this.achievementId &&
          other.userId == this.userId &&
          other.sourceEventId == this.sourceEventId &&
          other.unlockedAt == this.unlockedAt &&
          other.updatedAt == this.updatedAt &&
          other.isSynced == this.isSynced);
}

class AchievementUnlocksCompanion extends UpdateCompanion<AchievementUnlock> {
  final Value<String> achievementId;
  final Value<String> userId;
  final Value<String> sourceEventId;
  final Value<DateTime> unlockedAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const AchievementUnlocksCompanion({
    this.achievementId = const Value.absent(),
    this.userId = const Value.absent(),
    this.sourceEventId = const Value.absent(),
    this.unlockedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementUnlocksCompanion.insert({
    required String achievementId,
    required String userId,
    required String sourceEventId,
    this.unlockedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : achievementId = Value(achievementId),
       userId = Value(userId),
       sourceEventId = Value(sourceEventId);
  static Insertable<AchievementUnlock> custom({
    Expression<String>? achievementId,
    Expression<String>? userId,
    Expression<String>? sourceEventId,
    Expression<DateTime>? unlockedAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (achievementId != null) 'achievement_id': achievementId,
      if (userId != null) 'user_id': userId,
      if (sourceEventId != null) 'source_event_id': sourceEventId,
      if (unlockedAt != null) 'unlocked_at': unlockedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementUnlocksCompanion copyWith({
    Value<String>? achievementId,
    Value<String>? userId,
    Value<String>? sourceEventId,
    Value<DateTime>? unlockedAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return AchievementUnlocksCompanion(
      achievementId: achievementId ?? this.achievementId,
      userId: userId ?? this.userId,
      sourceEventId: sourceEventId ?? this.sourceEventId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (achievementId.present) {
      map['achievement_id'] = Variable<String>(achievementId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (sourceEventId.present) {
      map['source_event_id'] = Variable<String>(sourceEventId.value);
    }
    if (unlockedAt.present) {
      map['unlocked_at'] = Variable<DateTime>(unlockedAt.value);
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
    return (StringBuffer('AchievementUnlocksCompanion(')
          ..write('achievementId: $achievementId, ')
          ..write('userId: $userId, ')
          ..write('sourceEventId: $sourceEventId, ')
          ..write('unlockedAt: $unlockedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationEventsTable extends NotificationEvents
    with TableInfo<$NotificationEventsTable, NotificationEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _notificationIdMeta = const VerificationMeta(
    'notificationId',
  );
  @override
  late final GeneratedColumn<String> notificationId = GeneratedColumn<String>(
    'notification_id',
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
  @override
  late final GeneratedColumnWithTypeConverter<NotificationEventType, String>
  type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<NotificationEventType>(
        $NotificationEventsTable.$convertertype,
      );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionRouteMeta = const VerificationMeta(
    'actionRoute',
  );
  @override
  late final GeneratedColumn<String> actionRoute = GeneratedColumn<String>(
    'action_route',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionPayloadJsonMeta = const VerificationMeta(
    'actionPayloadJson',
  );
  @override
  late final GeneratedColumn<String> actionPayloadJson =
      GeneratedColumn<String>(
        'action_payload_json',
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
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
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
  @override
  List<GeneratedColumn> get $columns => [
    notificationId,
    userId,
    type,
    sourceType,
    sourceId,
    title,
    body,
    actionRoute,
    actionPayloadJson,
    createdAt,
    expiresAt,
    readAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('notification_id')) {
      context.handle(
        _notificationIdMeta,
        notificationId.isAcceptableOrUnknown(
          data['notification_id']!,
          _notificationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_notificationIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('action_route')) {
      context.handle(
        _actionRouteMeta,
        actionRoute.isAcceptableOrUnknown(
          data['action_route']!,
          _actionRouteMeta,
        ),
      );
    }
    if (data.containsKey('action_payload_json')) {
      context.handle(
        _actionPayloadJsonMeta,
        actionPayloadJson.isAcceptableOrUnknown(
          data['action_payload_json']!,
          _actionPayloadJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {notificationId};
  @override
  NotificationEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationEvent(
      notificationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notification_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      type: $NotificationEventsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      actionRoute: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_route'],
      ),
      actionPayloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_payload_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotificationEventsTable createAlias(String alias) {
    return $NotificationEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<NotificationEventType, String, String>
  $convertertype = const EnumNameConverter<NotificationEventType>(
    NotificationEventType.values,
  );
}

class NotificationEvent extends DataClass
    implements Insertable<NotificationEvent> {
  final String notificationId;
  final String userId;
  final NotificationEventType type;
  final String sourceType;
  final String? sourceId;
  final String title;
  final String body;
  final String? actionRoute;
  final String? actionPayloadJson;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final DateTime? readAt;
  final DateTime updatedAt;
  const NotificationEvent({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.sourceType,
    this.sourceId,
    required this.title,
    required this.body,
    this.actionRoute,
    this.actionPayloadJson,
    required this.createdAt,
    this.expiresAt,
    this.readAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['notification_id'] = Variable<String>(notificationId);
    map['user_id'] = Variable<String>(userId);
    {
      map['type'] = Variable<String>(
        $NotificationEventsTable.$convertertype.toSql(type),
      );
    }
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sourceId != null) {
      map['source_id'] = Variable<String>(sourceId);
    }
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || actionRoute != null) {
      map['action_route'] = Variable<String>(actionRoute);
    }
    if (!nullToAbsent || actionPayloadJson != null) {
      map['action_payload_json'] = Variable<String>(actionPayloadJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotificationEventsCompanion toCompanion(bool nullToAbsent) {
    return NotificationEventsCompanion(
      notificationId: Value(notificationId),
      userId: Value(userId),
      type: Value(type),
      sourceType: Value(sourceType),
      sourceId: sourceId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceId),
      title: Value(title),
      body: Value(body),
      actionRoute: actionRoute == null && nullToAbsent
          ? const Value.absent()
          : Value(actionRoute),
      actionPayloadJson: actionPayloadJson == null && nullToAbsent
          ? const Value.absent()
          : Value(actionPayloadJson),
      createdAt: Value(createdAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NotificationEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationEvent(
      notificationId: serializer.fromJson<String>(json['notificationId']),
      userId: serializer.fromJson<String>(json['userId']),
      type: $NotificationEventsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String?>(json['sourceId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      actionRoute: serializer.fromJson<String?>(json['actionRoute']),
      actionPayloadJson: serializer.fromJson<String?>(
        json['actionPayloadJson'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'notificationId': serializer.toJson<String>(notificationId),
      'userId': serializer.toJson<String>(userId),
      'type': serializer.toJson<String>(
        $NotificationEventsTable.$convertertype.toJson(type),
      ),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String?>(sourceId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'actionRoute': serializer.toJson<String?>(actionRoute),
      'actionPayloadJson': serializer.toJson<String?>(actionPayloadJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NotificationEvent copyWith({
    String? notificationId,
    String? userId,
    NotificationEventType? type,
    String? sourceType,
    Value<String?> sourceId = const Value.absent(),
    String? title,
    String? body,
    Value<String?> actionRoute = const Value.absent(),
    Value<String?> actionPayloadJson = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> expiresAt = const Value.absent(),
    Value<DateTime?> readAt = const Value.absent(),
    DateTime? updatedAt,
  }) => NotificationEvent(
    notificationId: notificationId ?? this.notificationId,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    sourceType: sourceType ?? this.sourceType,
    sourceId: sourceId.present ? sourceId.value : this.sourceId,
    title: title ?? this.title,
    body: body ?? this.body,
    actionRoute: actionRoute.present ? actionRoute.value : this.actionRoute,
    actionPayloadJson: actionPayloadJson.present
        ? actionPayloadJson.value
        : this.actionPayloadJson,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    readAt: readAt.present ? readAt.value : this.readAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NotificationEvent copyWithCompanion(NotificationEventsCompanion data) {
    return NotificationEvent(
      notificationId: data.notificationId.present
          ? data.notificationId.value
          : this.notificationId,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      actionRoute: data.actionRoute.present
          ? data.actionRoute.value
          : this.actionRoute,
      actionPayloadJson: data.actionPayloadJson.present
          ? data.actionPayloadJson.value
          : this.actionPayloadJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationEvent(')
          ..write('notificationId: $notificationId, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('actionRoute: $actionRoute, ')
          ..write('actionPayloadJson: $actionPayloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('readAt: $readAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    notificationId,
    userId,
    type,
    sourceType,
    sourceId,
    title,
    body,
    actionRoute,
    actionPayloadJson,
    createdAt,
    expiresAt,
    readAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationEvent &&
          other.notificationId == this.notificationId &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.title == this.title &&
          other.body == this.body &&
          other.actionRoute == this.actionRoute &&
          other.actionPayloadJson == this.actionPayloadJson &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt &&
          other.readAt == this.readAt &&
          other.updatedAt == this.updatedAt);
}

class NotificationEventsCompanion extends UpdateCompanion<NotificationEvent> {
  final Value<String> notificationId;
  final Value<String> userId;
  final Value<NotificationEventType> type;
  final Value<String> sourceType;
  final Value<String?> sourceId;
  final Value<String> title;
  final Value<String> body;
  final Value<String?> actionRoute;
  final Value<String?> actionPayloadJson;
  final Value<DateTime> createdAt;
  final Value<DateTime?> expiresAt;
  final Value<DateTime?> readAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NotificationEventsCompanion({
    this.notificationId = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.actionRoute = const Value.absent(),
    this.actionPayloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationEventsCompanion.insert({
    required String notificationId,
    required String userId,
    required NotificationEventType type,
    required String sourceType,
    this.sourceId = const Value.absent(),
    required String title,
    required String body,
    this.actionRoute = const Value.absent(),
    this.actionPayloadJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.readAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : notificationId = Value(notificationId),
       userId = Value(userId),
       type = Value(type),
       sourceType = Value(sourceType),
       title = Value(title),
       body = Value(body);
  static Insertable<NotificationEvent> custom({
    Expression<String>? notificationId,
    Expression<String>? userId,
    Expression<String>? type,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? actionRoute,
    Expression<String>? actionPayloadJson,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? readAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (notificationId != null) 'notification_id': notificationId,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (actionRoute != null) 'action_route': actionRoute,
      if (actionPayloadJson != null) 'action_payload_json': actionPayloadJson,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (readAt != null) 'read_at': readAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationEventsCompanion copyWith({
    Value<String>? notificationId,
    Value<String>? userId,
    Value<NotificationEventType>? type,
    Value<String>? sourceType,
    Value<String?>? sourceId,
    Value<String>? title,
    Value<String>? body,
    Value<String?>? actionRoute,
    Value<String?>? actionPayloadJson,
    Value<DateTime>? createdAt,
    Value<DateTime?>? expiresAt,
    Value<DateTime?>? readAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NotificationEventsCompanion(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      title: title ?? this.title,
      body: body ?? this.body,
      actionRoute: actionRoute ?? this.actionRoute,
      actionPayloadJson: actionPayloadJson ?? this.actionPayloadJson,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      readAt: readAt ?? this.readAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (notificationId.present) {
      map['notification_id'] = Variable<String>(notificationId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $NotificationEventsTable.$convertertype.toSql(type.value),
      );
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (actionRoute.present) {
      map['action_route'] = Variable<String>(actionRoute.value);
    }
    if (actionPayloadJson.present) {
      map['action_payload_json'] = Variable<String>(actionPayloadJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationEventsCompanion(')
          ..write('notificationId: $notificationId, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('actionRoute: $actionRoute, ')
          ..write('actionPayloadJson: $actionPayloadJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('readAt: $readAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReminderSettingsTable extends ReminderSettings
    with TableInfo<$ReminderSettingsTable, ReminderSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReminderSettingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReminderType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('dailyHabit'),
      ).withConverter<ReminderType>($ReminderSettingsTable.$convertertype);
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(20),
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isPermissionDeniedMeta =
      const VerificationMeta('isPermissionDenied');
  @override
  late final GeneratedColumn<bool> isPermissionDenied = GeneratedColumn<bool>(
    'is_permission_denied',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_permission_denied" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    type,
    isEnabled,
    hour,
    minute,
    isPermissionDenied,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reminder_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReminderSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    }
    if (data.containsKey('is_permission_denied')) {
      context.handle(
        _isPermissionDeniedMeta,
        isPermissionDenied.isAcceptableOrUnknown(
          data['is_permission_denied']!,
          _isPermissionDeniedMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReminderSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReminderSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      type: $ReminderSettingsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
      isPermissionDenied: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_permission_denied'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReminderSettingsTable createAlias(String alias) {
    return $ReminderSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReminderType, String, String> $convertertype =
      const EnumNameConverter<ReminderType>(ReminderType.values);
}

class ReminderSetting extends DataClass implements Insertable<ReminderSetting> {
  final int id;
  final String userId;
  final ReminderType type;
  final bool isEnabled;
  final int hour;
  final int minute;
  final bool isPermissionDenied;
  final DateTime updatedAt;
  const ReminderSetting({
    required this.id,
    required this.userId,
    required this.type,
    required this.isEnabled,
    required this.hour,
    required this.minute,
    required this.isPermissionDenied,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<String>(userId);
    {
      map['type'] = Variable<String>(
        $ReminderSettingsTable.$convertertype.toSql(type),
      );
    }
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['is_permission_denied'] = Variable<bool>(isPermissionDenied);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReminderSettingsCompanion toCompanion(bool nullToAbsent) {
    return ReminderSettingsCompanion(
      id: Value(id),
      userId: Value(userId),
      type: Value(type),
      isEnabled: Value(isEnabled),
      hour: Value(hour),
      minute: Value(minute),
      isPermissionDenied: Value(isPermissionDenied),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReminderSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReminderSetting(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      type: $ReminderSettingsTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      isPermissionDenied: serializer.fromJson<bool>(json['isPermissionDenied']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<String>(userId),
      'type': serializer.toJson<String>(
        $ReminderSettingsTable.$convertertype.toJson(type),
      ),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'isPermissionDenied': serializer.toJson<bool>(isPermissionDenied),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ReminderSetting copyWith({
    int? id,
    String? userId,
    ReminderType? type,
    bool? isEnabled,
    int? hour,
    int? minute,
    bool? isPermissionDenied,
    DateTime? updatedAt,
  }) => ReminderSetting(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    isEnabled: isEnabled ?? this.isEnabled,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    isPermissionDenied: isPermissionDenied ?? this.isPermissionDenied,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReminderSetting copyWithCompanion(ReminderSettingsCompanion data) {
    return ReminderSetting(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      isPermissionDenied: data.isPermissionDenied.present
          ? data.isPermissionDenied.value
          : this.isPermissionDenied,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSetting(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('isPermissionDenied: $isPermissionDenied, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    type,
    isEnabled,
    hour,
    minute,
    isPermissionDenied,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReminderSetting &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.isEnabled == this.isEnabled &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.isPermissionDenied == this.isPermissionDenied &&
          other.updatedAt == this.updatedAt);
}

class ReminderSettingsCompanion extends UpdateCompanion<ReminderSetting> {
  final Value<int> id;
  final Value<String> userId;
  final Value<ReminderType> type;
  final Value<bool> isEnabled;
  final Value<int> hour;
  final Value<int> minute;
  final Value<bool> isPermissionDenied;
  final Value<DateTime> updatedAt;
  const ReminderSettingsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.isPermissionDenied = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ReminderSettingsCompanion.insert({
    this.id = const Value.absent(),
    required String userId,
    this.type = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.isPermissionDenied = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<ReminderSetting> custom({
    Expression<int>? id,
    Expression<String>? userId,
    Expression<String>? type,
    Expression<bool>? isEnabled,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<bool>? isPermissionDenied,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (isPermissionDenied != null)
        'is_permission_denied': isPermissionDenied,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ReminderSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? userId,
    Value<ReminderType>? type,
    Value<bool>? isEnabled,
    Value<int>? hour,
    Value<int>? minute,
    Value<bool>? isPermissionDenied,
    Value<DateTime>? updatedAt,
  }) {
    return ReminderSettingsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      isPermissionDenied: isPermissionDenied ?? this.isPermissionDenied,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $ReminderSettingsTable.$convertertype.toSql(type.value),
      );
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (isPermissionDenied.present) {
      map['is_permission_denied'] = Variable<bool>(isPermissionDenied.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReminderSettingsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('isPermissionDenied: $isPermissionDenied, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UsageAggregateBucketsTable extends UsageAggregateBuckets
    with TableInfo<$UsageAggregateBucketsTable, UsageAggregateBucket> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsageAggregateBucketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _bucketDateMeta = const VerificationMeta(
    'bucketDate',
  );
  @override
  late final GeneratedColumn<String> bucketDate = GeneratedColumn<String>(
    'bucket_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _buildChannelMeta = const VerificationMeta(
    'buildChannel',
  );
  @override
  late final GeneratedColumn<String> buildChannel = GeneratedColumn<String>(
    'build_channel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _screenNameMeta = const VerificationMeta(
    'screenName',
  );
  @override
  late final GeneratedColumn<String> screenName = GeneratedColumn<String>(
    'screen_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metricNameMeta = const VerificationMeta(
    'metricName',
  );
  @override
  late final GeneratedColumn<String> metricName = GeneratedColumn<String>(
    'metric_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalDurationMsMeta = const VerificationMeta(
    'totalDurationMs',
  );
  @override
  late final GeneratedColumn<int> totalDurationMs = GeneratedColumn<int>(
    'total_duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _uploadedCountMeta = const VerificationMeta(
    'uploadedCount',
  );
  @override
  late final GeneratedColumn<int> uploadedCount = GeneratedColumn<int>(
    'uploaded_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _uploadedTotalDurationMsMeta =
      const VerificationMeta('uploadedTotalDurationMs');
  @override
  late final GeneratedColumn<int> uploadedTotalDurationMs =
      GeneratedColumn<int>(
        'uploaded_total_duration_ms',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
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
  @override
  List<GeneratedColumn> get $columns => [
    bucketDate,
    platform,
    buildChannel,
    screenName,
    metricName,
    count,
    totalDurationMs,
    uploadedCount,
    uploadedTotalDurationMs,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'usage_aggregate_buckets';
  @override
  VerificationContext validateIntegrity(
    Insertable<UsageAggregateBucket> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('bucket_date')) {
      context.handle(
        _bucketDateMeta,
        bucketDate.isAcceptableOrUnknown(data['bucket_date']!, _bucketDateMeta),
      );
    } else if (isInserting) {
      context.missing(_bucketDateMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('build_channel')) {
      context.handle(
        _buildChannelMeta,
        buildChannel.isAcceptableOrUnknown(
          data['build_channel']!,
          _buildChannelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_buildChannelMeta);
    }
    if (data.containsKey('screen_name')) {
      context.handle(
        _screenNameMeta,
        screenName.isAcceptableOrUnknown(data['screen_name']!, _screenNameMeta),
      );
    } else if (isInserting) {
      context.missing(_screenNameMeta);
    }
    if (data.containsKey('metric_name')) {
      context.handle(
        _metricNameMeta,
        metricName.isAcceptableOrUnknown(data['metric_name']!, _metricNameMeta),
      );
    } else if (isInserting) {
      context.missing(_metricNameMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    if (data.containsKey('total_duration_ms')) {
      context.handle(
        _totalDurationMsMeta,
        totalDurationMs.isAcceptableOrUnknown(
          data['total_duration_ms']!,
          _totalDurationMsMeta,
        ),
      );
    }
    if (data.containsKey('uploaded_count')) {
      context.handle(
        _uploadedCountMeta,
        uploadedCount.isAcceptableOrUnknown(
          data['uploaded_count']!,
          _uploadedCountMeta,
        ),
      );
    }
    if (data.containsKey('uploaded_total_duration_ms')) {
      context.handle(
        _uploadedTotalDurationMsMeta,
        uploadedTotalDurationMs.isAcceptableOrUnknown(
          data['uploaded_total_duration_ms']!,
          _uploadedTotalDurationMsMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {
    bucketDate,
    platform,
    buildChannel,
    screenName,
    metricName,
  };
  @override
  UsageAggregateBucket map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UsageAggregateBucket(
      bucketDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bucket_date'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      buildChannel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}build_channel'],
      )!,
      screenName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}screen_name'],
      )!,
      metricName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metric_name'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      totalDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_duration_ms'],
      )!,
      uploadedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uploaded_count'],
      )!,
      uploadedTotalDurationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}uploaded_total_duration_ms'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsageAggregateBucketsTable createAlias(String alias) {
    return $UsageAggregateBucketsTable(attachedDatabase, alias);
  }
}

class UsageAggregateBucket extends DataClass
    implements Insertable<UsageAggregateBucket> {
  final String bucketDate;
  final String platform;
  final String buildChannel;
  final String screenName;
  final String metricName;
  final int count;
  final int totalDurationMs;
  final int uploadedCount;
  final int uploadedTotalDurationMs;
  final DateTime updatedAt;
  const UsageAggregateBucket({
    required this.bucketDate,
    required this.platform,
    required this.buildChannel,
    required this.screenName,
    required this.metricName,
    required this.count,
    required this.totalDurationMs,
    required this.uploadedCount,
    required this.uploadedTotalDurationMs,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['bucket_date'] = Variable<String>(bucketDate);
    map['platform'] = Variable<String>(platform);
    map['build_channel'] = Variable<String>(buildChannel);
    map['screen_name'] = Variable<String>(screenName);
    map['metric_name'] = Variable<String>(metricName);
    map['count'] = Variable<int>(count);
    map['total_duration_ms'] = Variable<int>(totalDurationMs);
    map['uploaded_count'] = Variable<int>(uploadedCount);
    map['uploaded_total_duration_ms'] = Variable<int>(uploadedTotalDurationMs);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsageAggregateBucketsCompanion toCompanion(bool nullToAbsent) {
    return UsageAggregateBucketsCompanion(
      bucketDate: Value(bucketDate),
      platform: Value(platform),
      buildChannel: Value(buildChannel),
      screenName: Value(screenName),
      metricName: Value(metricName),
      count: Value(count),
      totalDurationMs: Value(totalDurationMs),
      uploadedCount: Value(uploadedCount),
      uploadedTotalDurationMs: Value(uploadedTotalDurationMs),
      updatedAt: Value(updatedAt),
    );
  }

  factory UsageAggregateBucket.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UsageAggregateBucket(
      bucketDate: serializer.fromJson<String>(json['bucketDate']),
      platform: serializer.fromJson<String>(json['platform']),
      buildChannel: serializer.fromJson<String>(json['buildChannel']),
      screenName: serializer.fromJson<String>(json['screenName']),
      metricName: serializer.fromJson<String>(json['metricName']),
      count: serializer.fromJson<int>(json['count']),
      totalDurationMs: serializer.fromJson<int>(json['totalDurationMs']),
      uploadedCount: serializer.fromJson<int>(json['uploadedCount']),
      uploadedTotalDurationMs: serializer.fromJson<int>(
        json['uploadedTotalDurationMs'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'bucketDate': serializer.toJson<String>(bucketDate),
      'platform': serializer.toJson<String>(platform),
      'buildChannel': serializer.toJson<String>(buildChannel),
      'screenName': serializer.toJson<String>(screenName),
      'metricName': serializer.toJson<String>(metricName),
      'count': serializer.toJson<int>(count),
      'totalDurationMs': serializer.toJson<int>(totalDurationMs),
      'uploadedCount': serializer.toJson<int>(uploadedCount),
      'uploadedTotalDurationMs': serializer.toJson<int>(
        uploadedTotalDurationMs,
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UsageAggregateBucket copyWith({
    String? bucketDate,
    String? platform,
    String? buildChannel,
    String? screenName,
    String? metricName,
    int? count,
    int? totalDurationMs,
    int? uploadedCount,
    int? uploadedTotalDurationMs,
    DateTime? updatedAt,
  }) => UsageAggregateBucket(
    bucketDate: bucketDate ?? this.bucketDate,
    platform: platform ?? this.platform,
    buildChannel: buildChannel ?? this.buildChannel,
    screenName: screenName ?? this.screenName,
    metricName: metricName ?? this.metricName,
    count: count ?? this.count,
    totalDurationMs: totalDurationMs ?? this.totalDurationMs,
    uploadedCount: uploadedCount ?? this.uploadedCount,
    uploadedTotalDurationMs:
        uploadedTotalDurationMs ?? this.uploadedTotalDurationMs,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UsageAggregateBucket copyWithCompanion(UsageAggregateBucketsCompanion data) {
    return UsageAggregateBucket(
      bucketDate: data.bucketDate.present
          ? data.bucketDate.value
          : this.bucketDate,
      platform: data.platform.present ? data.platform.value : this.platform,
      buildChannel: data.buildChannel.present
          ? data.buildChannel.value
          : this.buildChannel,
      screenName: data.screenName.present
          ? data.screenName.value
          : this.screenName,
      metricName: data.metricName.present
          ? data.metricName.value
          : this.metricName,
      count: data.count.present ? data.count.value : this.count,
      totalDurationMs: data.totalDurationMs.present
          ? data.totalDurationMs.value
          : this.totalDurationMs,
      uploadedCount: data.uploadedCount.present
          ? data.uploadedCount.value
          : this.uploadedCount,
      uploadedTotalDurationMs: data.uploadedTotalDurationMs.present
          ? data.uploadedTotalDurationMs.value
          : this.uploadedTotalDurationMs,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UsageAggregateBucket(')
          ..write('bucketDate: $bucketDate, ')
          ..write('platform: $platform, ')
          ..write('buildChannel: $buildChannel, ')
          ..write('screenName: $screenName, ')
          ..write('metricName: $metricName, ')
          ..write('count: $count, ')
          ..write('totalDurationMs: $totalDurationMs, ')
          ..write('uploadedCount: $uploadedCount, ')
          ..write('uploadedTotalDurationMs: $uploadedTotalDurationMs, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    bucketDate,
    platform,
    buildChannel,
    screenName,
    metricName,
    count,
    totalDurationMs,
    uploadedCount,
    uploadedTotalDurationMs,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UsageAggregateBucket &&
          other.bucketDate == this.bucketDate &&
          other.platform == this.platform &&
          other.buildChannel == this.buildChannel &&
          other.screenName == this.screenName &&
          other.metricName == this.metricName &&
          other.count == this.count &&
          other.totalDurationMs == this.totalDurationMs &&
          other.uploadedCount == this.uploadedCount &&
          other.uploadedTotalDurationMs == this.uploadedTotalDurationMs &&
          other.updatedAt == this.updatedAt);
}

class UsageAggregateBucketsCompanion
    extends UpdateCompanion<UsageAggregateBucket> {
  final Value<String> bucketDate;
  final Value<String> platform;
  final Value<String> buildChannel;
  final Value<String> screenName;
  final Value<String> metricName;
  final Value<int> count;
  final Value<int> totalDurationMs;
  final Value<int> uploadedCount;
  final Value<int> uploadedTotalDurationMs;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsageAggregateBucketsCompanion({
    this.bucketDate = const Value.absent(),
    this.platform = const Value.absent(),
    this.buildChannel = const Value.absent(),
    this.screenName = const Value.absent(),
    this.metricName = const Value.absent(),
    this.count = const Value.absent(),
    this.totalDurationMs = const Value.absent(),
    this.uploadedCount = const Value.absent(),
    this.uploadedTotalDurationMs = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsageAggregateBucketsCompanion.insert({
    required String bucketDate,
    required String platform,
    required String buildChannel,
    required String screenName,
    required String metricName,
    this.count = const Value.absent(),
    this.totalDurationMs = const Value.absent(),
    this.uploadedCount = const Value.absent(),
    this.uploadedTotalDurationMs = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : bucketDate = Value(bucketDate),
       platform = Value(platform),
       buildChannel = Value(buildChannel),
       screenName = Value(screenName),
       metricName = Value(metricName);
  static Insertable<UsageAggregateBucket> custom({
    Expression<String>? bucketDate,
    Expression<String>? platform,
    Expression<String>? buildChannel,
    Expression<String>? screenName,
    Expression<String>? metricName,
    Expression<int>? count,
    Expression<int>? totalDurationMs,
    Expression<int>? uploadedCount,
    Expression<int>? uploadedTotalDurationMs,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (bucketDate != null) 'bucket_date': bucketDate,
      if (platform != null) 'platform': platform,
      if (buildChannel != null) 'build_channel': buildChannel,
      if (screenName != null) 'screen_name': screenName,
      if (metricName != null) 'metric_name': metricName,
      if (count != null) 'count': count,
      if (totalDurationMs != null) 'total_duration_ms': totalDurationMs,
      if (uploadedCount != null) 'uploaded_count': uploadedCount,
      if (uploadedTotalDurationMs != null)
        'uploaded_total_duration_ms': uploadedTotalDurationMs,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsageAggregateBucketsCompanion copyWith({
    Value<String>? bucketDate,
    Value<String>? platform,
    Value<String>? buildChannel,
    Value<String>? screenName,
    Value<String>? metricName,
    Value<int>? count,
    Value<int>? totalDurationMs,
    Value<int>? uploadedCount,
    Value<int>? uploadedTotalDurationMs,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UsageAggregateBucketsCompanion(
      bucketDate: bucketDate ?? this.bucketDate,
      platform: platform ?? this.platform,
      buildChannel: buildChannel ?? this.buildChannel,
      screenName: screenName ?? this.screenName,
      metricName: metricName ?? this.metricName,
      count: count ?? this.count,
      totalDurationMs: totalDurationMs ?? this.totalDurationMs,
      uploadedCount: uploadedCount ?? this.uploadedCount,
      uploadedTotalDurationMs:
          uploadedTotalDurationMs ?? this.uploadedTotalDurationMs,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (bucketDate.present) {
      map['bucket_date'] = Variable<String>(bucketDate.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (buildChannel.present) {
      map['build_channel'] = Variable<String>(buildChannel.value);
    }
    if (screenName.present) {
      map['screen_name'] = Variable<String>(screenName.value);
    }
    if (metricName.present) {
      map['metric_name'] = Variable<String>(metricName.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (totalDurationMs.present) {
      map['total_duration_ms'] = Variable<int>(totalDurationMs.value);
    }
    if (uploadedCount.present) {
      map['uploaded_count'] = Variable<int>(uploadedCount.value);
    }
    if (uploadedTotalDurationMs.present) {
      map['uploaded_total_duration_ms'] = Variable<int>(
        uploadedTotalDurationMs.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsageAggregateBucketsCompanion(')
          ..write('bucketDate: $bucketDate, ')
          ..write('platform: $platform, ')
          ..write('buildChannel: $buildChannel, ')
          ..write('screenName: $screenName, ')
          ..write('metricName: $metricName, ')
          ..write('count: $count, ')
          ..write('totalDurationMs: $totalDurationMs, ')
          ..write('uploadedCount: $uploadedCount, ')
          ..write('uploadedTotalDurationMs: $uploadedTotalDurationMs, ')
          ..write('updatedAt: $updatedAt, ')
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
  late final $AcceptedFriendsTable acceptedFriends = $AcceptedFriendsTable(
    this,
  );
  late final $FriendRelationshipsTable friendRelationships =
      $FriendRelationshipsTable(this);
  late final $AchievementUnlocksTable achievementUnlocks =
      $AchievementUnlocksTable(this);
  late final $NotificationEventsTable notificationEvents =
      $NotificationEventsTable(this);
  late final $ReminderSettingsTable reminderSettings = $ReminderSettingsTable(
    this,
  );
  late final $UsageAggregateBucketsTable usageAggregateBuckets =
      $UsageAggregateBucketsTable(this);
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
    acceptedFriends,
    friendRelationships,
    achievementUnlocks,
    notificationEvents,
    reminderSettings,
    usageAggregateBuckets,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String userId,
      required String username,
      Value<String?> email,
      Value<DateTime?> emailVerifiedAt,
      Value<String?> avatarUrl,
      Value<String> levelName,
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
      Value<String?> email,
      Value<DateTime?> emailVerifiedAt,
      Value<String?> avatarUrl,
      Value<String> levelName,
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get emailVerifiedAt => $composableBuilder(
    column: $table.emailVerifiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get levelName => $composableBuilder(
    column: $table.levelName,
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get emailVerifiedAt => $composableBuilder(
    column: $table.emailVerifiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get levelName => $composableBuilder(
    column: $table.levelName,
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

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get emailVerifiedAt => $composableBuilder(
    column: $table.emailVerifiedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get levelName =>
      $composableBuilder(column: $table.levelName, builder: (column) => column);

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
                Value<String?> email = const Value.absent(),
                Value<DateTime?> emailVerifiedAt = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String> levelName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                userId: userId,
                username: username,
                email: email,
                emailVerifiedAt: emailVerifiedAt,
                avatarUrl: avatarUrl,
                levelName: levelName,
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
                Value<String?> email = const Value.absent(),
                Value<DateTime?> emailVerifiedAt = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String> levelName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> totalScore = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                userId: userId,
                username: username,
                email: email,
                emailVerifiedAt: emailVerifiedAt,
                avatarUrl: avatarUrl,
                levelName: levelName,
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
      Value<String?> description,
      Value<bool> isCustom,
      required int targetDuration,
      required int currentDuration,
      required HabitStatus status,
      Value<String> colorHex,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$HabitsTableUpdateCompanionBuilder =
    HabitsCompanion Function({
      Value<String> habitId,
      Value<String> userId,
      Value<String> title,
      Value<String?> description,
      Value<bool> isCustom,
      Value<int> targetDuration,
      Value<int> currentDuration,
      Value<HabitStatus> status,
      Value<String> colorHex,
      Value<DateTime> createdAt,
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

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

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

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
                Value<String?> description = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<int> targetDuration = const Value.absent(),
                Value<int> currentDuration = const Value.absent(),
                Value<HabitStatus> status = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                habitId: habitId,
                userId: userId,
                title: title,
                description: description,
                isCustom: isCustom,
                targetDuration: targetDuration,
                currentDuration: currentDuration,
                status: status,
                colorHex: colorHex,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String habitId,
                required String userId,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                required int targetDuration,
                required int currentDuration,
                required HabitStatus status,
                Value<String> colorHex = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                habitId: habitId,
                userId: userId,
                title: title,
                description: description,
                isCustom: isCustom,
                targetDuration: targetDuration,
                currentDuration: currentDuration,
                status: status,
                colorHex: colorHex,
                createdAt: createdAt,
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
      Value<int> pointsAwarded,
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
      Value<int> pointsAwarded,
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

  ColumnFilters<int> get pointsAwarded => $composableBuilder(
    column: $table.pointsAwarded,
    builder: (column) => ColumnFilters(column),
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

  ColumnOrderings<int> get pointsAwarded => $composableBuilder(
    column: $table.pointsAwarded,
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

  GeneratedColumn<int> get pointsAwarded => $composableBuilder(
    column: $table.pointsAwarded,
    builder: (column) => column,
  );

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
                Value<int> pointsAwarded = const Value.absent(),
                Value<String?> journalNote = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LogsCompanion(
                logId: logId,
                habitId: habitId,
                actionDate: actionDate,
                status: status,
                pointsAwarded: pointsAwarded,
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
                Value<int> pointsAwarded = const Value.absent(),
                Value<String?> journalNote = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LogsCompanion.insert(
                logId: logId,
                habitId: habitId,
                actionDate: actionDate,
                status: status,
                pointsAwarded: pointsAwarded,
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
      Value<PartnershipRole> role,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$PartnershipsTableUpdateCompanionBuilder =
    PartnershipsCompanion Function({
      Value<String> partnershipId,
      Value<String> habitId,
      Value<String> partnerUserId,
      Value<PartnershipRole> role,
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

  ColumnWithTypeConverterFilters<PartnershipRole, PartnershipRole, String>
  get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnWithTypeConverterFilters(column),
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

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
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

  GeneratedColumnWithTypeConverter<PartnershipRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

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
                Value<PartnershipRole> role = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartnershipsCompanion(
                partnershipId: partnershipId,
                habitId: habitId,
                partnerUserId: partnerUserId,
                role: role,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String partnershipId,
                required String habitId,
                required String partnerUserId,
                Value<PartnershipRole> role = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PartnershipsCompanion.insert(
                partnershipId: partnershipId,
                habitId: habitId,
                partnerUserId: partnerUserId,
                role: role,
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
      Value<String?> author,
      Value<DateTime> fetchedAt,
    });
typedef $$CachedQuotesTableUpdateCompanionBuilder =
    CachedQuotesCompanion Function({
      Value<int> id,
      Value<String> quoteText,
      Value<String?> author,
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

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
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

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
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

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

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
                Value<String?> author = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
              }) => CachedQuotesCompanion(
                id: id,
                quoteText: quoteText,
                author: author,
                fetchedAt: fetchedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String quoteText,
                Value<String?> author = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
              }) => CachedQuotesCompanion.insert(
                id: id,
                quoteText: quoteText,
                author: author,
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
      Value<PartnershipRole> role,
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
      Value<PartnershipRole> role,
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

  ColumnWithTypeConverterFilters<PartnershipRole, PartnershipRole, String>
  get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnWithTypeConverterFilters(column),
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

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
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

  GeneratedColumnWithTypeConverter<PartnershipRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

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
                Value<PartnershipRole> role = const Value.absent(),
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
                role: role,
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
                Value<PartnershipRole> role = const Value.absent(),
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
                role: role,
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
typedef $$AcceptedFriendsTableCreateCompanionBuilder =
    AcceptedFriendsCompanion Function({
      required String friendUserId,
      required String username,
      Value<String?> avatarUrl,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$AcceptedFriendsTableUpdateCompanionBuilder =
    AcceptedFriendsCompanion Function({
      Value<String> friendUserId,
      Value<String> username,
      Value<String?> avatarUrl,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$AcceptedFriendsTableFilterComposer
    extends Composer<_$AppDatabase, $AcceptedFriendsTable> {
  $$AcceptedFriendsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get friendUserId => $composableBuilder(
    column: $table.friendUserId,
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

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AcceptedFriendsTableOrderingComposer
    extends Composer<_$AppDatabase, $AcceptedFriendsTable> {
  $$AcceptedFriendsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get friendUserId => $composableBuilder(
    column: $table.friendUserId,
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

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AcceptedFriendsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AcceptedFriendsTable> {
  $$AcceptedFriendsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get friendUserId => $composableBuilder(
    column: $table.friendUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$AcceptedFriendsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AcceptedFriendsTable,
          AcceptedFriend,
          $$AcceptedFriendsTableFilterComposer,
          $$AcceptedFriendsTableOrderingComposer,
          $$AcceptedFriendsTableAnnotationComposer,
          $$AcceptedFriendsTableCreateCompanionBuilder,
          $$AcceptedFriendsTableUpdateCompanionBuilder,
          (
            AcceptedFriend,
            BaseReferences<
              _$AppDatabase,
              $AcceptedFriendsTable,
              AcceptedFriend
            >,
          ),
          AcceptedFriend,
          PrefetchHooks Function()
        > {
  $$AcceptedFriendsTableTableManager(
    _$AppDatabase db,
    $AcceptedFriendsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AcceptedFriendsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AcceptedFriendsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AcceptedFriendsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> friendUserId = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AcceptedFriendsCompanion(
                friendUserId: friendUserId,
                username: username,
                avatarUrl: avatarUrl,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String friendUserId,
                required String username,
                Value<String?> avatarUrl = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AcceptedFriendsCompanion.insert(
                friendUserId: friendUserId,
                username: username,
                avatarUrl: avatarUrl,
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

typedef $$AcceptedFriendsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AcceptedFriendsTable,
      AcceptedFriend,
      $$AcceptedFriendsTableFilterComposer,
      $$AcceptedFriendsTableOrderingComposer,
      $$AcceptedFriendsTableAnnotationComposer,
      $$AcceptedFriendsTableCreateCompanionBuilder,
      $$AcceptedFriendsTableUpdateCompanionBuilder,
      (
        AcceptedFriend,
        BaseReferences<_$AppDatabase, $AcceptedFriendsTable, AcceptedFriend>,
      ),
      AcceptedFriend,
      PrefetchHooks Function()
    >;
typedef $$FriendRelationshipsTableCreateCompanionBuilder =
    FriendRelationshipsCompanion Function({
      required String userId,
      required String username,
      Value<String?> avatarUrl,
      Value<String> relationshipState,
      Value<String?> requestId,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$FriendRelationshipsTableUpdateCompanionBuilder =
    FriendRelationshipsCompanion Function({
      Value<String> userId,
      Value<String> username,
      Value<String?> avatarUrl,
      Value<String> relationshipState,
      Value<String?> requestId,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$FriendRelationshipsTableFilterComposer
    extends Composer<_$AppDatabase, $FriendRelationshipsTable> {
  $$FriendRelationshipsTableFilterComposer({
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

  ColumnFilters<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get relationshipState => $composableBuilder(
    column: $table.relationshipState,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get requestId => $composableBuilder(
    column: $table.requestId,
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

class $$FriendRelationshipsTableOrderingComposer
    extends Composer<_$AppDatabase, $FriendRelationshipsTable> {
  $$FriendRelationshipsTableOrderingComposer({
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

  ColumnOrderings<String> get avatarUrl => $composableBuilder(
    column: $table.avatarUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get relationshipState => $composableBuilder(
    column: $table.relationshipState,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get requestId => $composableBuilder(
    column: $table.requestId,
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

class $$FriendRelationshipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FriendRelationshipsTable> {
  $$FriendRelationshipsTableAnnotationComposer({
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

  GeneratedColumn<String> get avatarUrl =>
      $composableBuilder(column: $table.avatarUrl, builder: (column) => column);

  GeneratedColumn<String> get relationshipState => $composableBuilder(
    column: $table.relationshipState,
    builder: (column) => column,
  );

  GeneratedColumn<String> get requestId =>
      $composableBuilder(column: $table.requestId, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$FriendRelationshipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FriendRelationshipsTable,
          FriendRelationship,
          $$FriendRelationshipsTableFilterComposer,
          $$FriendRelationshipsTableOrderingComposer,
          $$FriendRelationshipsTableAnnotationComposer,
          $$FriendRelationshipsTableCreateCompanionBuilder,
          $$FriendRelationshipsTableUpdateCompanionBuilder,
          (
            FriendRelationship,
            BaseReferences<
              _$AppDatabase,
              $FriendRelationshipsTable,
              FriendRelationship
            >,
          ),
          FriendRelationship,
          PrefetchHooks Function()
        > {
  $$FriendRelationshipsTableTableManager(
    _$AppDatabase db,
    $FriendRelationshipsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FriendRelationshipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FriendRelationshipsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FriendRelationshipsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String?> avatarUrl = const Value.absent(),
                Value<String> relationshipState = const Value.absent(),
                Value<String?> requestId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FriendRelationshipsCompanion(
                userId: userId,
                username: username,
                avatarUrl: avatarUrl,
                relationshipState: relationshipState,
                requestId: requestId,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String username,
                Value<String?> avatarUrl = const Value.absent(),
                Value<String> relationshipState = const Value.absent(),
                Value<String?> requestId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FriendRelationshipsCompanion.insert(
                userId: userId,
                username: username,
                avatarUrl: avatarUrl,
                relationshipState: relationshipState,
                requestId: requestId,
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

typedef $$FriendRelationshipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FriendRelationshipsTable,
      FriendRelationship,
      $$FriendRelationshipsTableFilterComposer,
      $$FriendRelationshipsTableOrderingComposer,
      $$FriendRelationshipsTableAnnotationComposer,
      $$FriendRelationshipsTableCreateCompanionBuilder,
      $$FriendRelationshipsTableUpdateCompanionBuilder,
      (
        FriendRelationship,
        BaseReferences<
          _$AppDatabase,
          $FriendRelationshipsTable,
          FriendRelationship
        >,
      ),
      FriendRelationship,
      PrefetchHooks Function()
    >;
typedef $$AchievementUnlocksTableCreateCompanionBuilder =
    AchievementUnlocksCompanion Function({
      required String achievementId,
      required String userId,
      required String sourceEventId,
      Value<DateTime> unlockedAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$AchievementUnlocksTableUpdateCompanionBuilder =
    AchievementUnlocksCompanion Function({
      Value<String> achievementId,
      Value<String> userId,
      Value<String> sourceEventId,
      Value<DateTime> unlockedAt,
      Value<DateTime> updatedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$AchievementUnlocksTableFilterComposer
    extends Composer<_$AppDatabase, $AchievementUnlocksTable> {
  $$AchievementUnlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceEventId => $composableBuilder(
    column: $table.sourceEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
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

class $$AchievementUnlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $AchievementUnlocksTable> {
  $$AchievementUnlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceEventId => $composableBuilder(
    column: $table.sourceEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
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

class $$AchievementUnlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $AchievementUnlocksTable> {
  $$AchievementUnlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get achievementId => $composableBuilder(
    column: $table.achievementId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get sourceEventId => $composableBuilder(
    column: $table.sourceEventId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get unlockedAt => $composableBuilder(
    column: $table.unlockedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$AchievementUnlocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AchievementUnlocksTable,
          AchievementUnlock,
          $$AchievementUnlocksTableFilterComposer,
          $$AchievementUnlocksTableOrderingComposer,
          $$AchievementUnlocksTableAnnotationComposer,
          $$AchievementUnlocksTableCreateCompanionBuilder,
          $$AchievementUnlocksTableUpdateCompanionBuilder,
          (
            AchievementUnlock,
            BaseReferences<
              _$AppDatabase,
              $AchievementUnlocksTable,
              AchievementUnlock
            >,
          ),
          AchievementUnlock,
          PrefetchHooks Function()
        > {
  $$AchievementUnlocksTableTableManager(
    _$AppDatabase db,
    $AchievementUnlocksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementUnlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementUnlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementUnlocksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> achievementId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> sourceEventId = const Value.absent(),
                Value<DateTime> unlockedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementUnlocksCompanion(
                achievementId: achievementId,
                userId: userId,
                sourceEventId: sourceEventId,
                unlockedAt: unlockedAt,
                updatedAt: updatedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String achievementId,
                required String userId,
                required String sourceEventId,
                Value<DateTime> unlockedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementUnlocksCompanion.insert(
                achievementId: achievementId,
                userId: userId,
                sourceEventId: sourceEventId,
                unlockedAt: unlockedAt,
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

typedef $$AchievementUnlocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AchievementUnlocksTable,
      AchievementUnlock,
      $$AchievementUnlocksTableFilterComposer,
      $$AchievementUnlocksTableOrderingComposer,
      $$AchievementUnlocksTableAnnotationComposer,
      $$AchievementUnlocksTableCreateCompanionBuilder,
      $$AchievementUnlocksTableUpdateCompanionBuilder,
      (
        AchievementUnlock,
        BaseReferences<
          _$AppDatabase,
          $AchievementUnlocksTable,
          AchievementUnlock
        >,
      ),
      AchievementUnlock,
      PrefetchHooks Function()
    >;
typedef $$NotificationEventsTableCreateCompanionBuilder =
    NotificationEventsCompanion Function({
      required String notificationId,
      required String userId,
      required NotificationEventType type,
      required String sourceType,
      Value<String?> sourceId,
      required String title,
      required String body,
      Value<String?> actionRoute,
      Value<String?> actionPayloadJson,
      Value<DateTime> createdAt,
      Value<DateTime?> expiresAt,
      Value<DateTime?> readAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$NotificationEventsTableUpdateCompanionBuilder =
    NotificationEventsCompanion Function({
      Value<String> notificationId,
      Value<String> userId,
      Value<NotificationEventType> type,
      Value<String> sourceType,
      Value<String?> sourceId,
      Value<String> title,
      Value<String> body,
      Value<String?> actionRoute,
      Value<String?> actionPayloadJson,
      Value<DateTime> createdAt,
      Value<DateTime?> expiresAt,
      Value<DateTime?> readAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$NotificationEventsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationEventsTable> {
  $$NotificationEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    NotificationEventType,
    NotificationEventType,
    String
  >
  get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionRoute => $composableBuilder(
    column: $table.actionRoute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionPayloadJson => $composableBuilder(
    column: $table.actionPayloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationEventsTable> {
  $$NotificationEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionRoute => $composableBuilder(
    column: $table.actionRoute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionPayloadJson => $composableBuilder(
    column: $table.actionPayloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationEventsTable> {
  $$NotificationEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get notificationId => $composableBuilder(
    column: $table.notificationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NotificationEventType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get actionRoute => $composableBuilder(
    column: $table.actionRoute,
    builder: (column) => column,
  );

  GeneratedColumn<String> get actionPayloadJson => $composableBuilder(
    column: $table.actionPayloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$NotificationEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationEventsTable,
          NotificationEvent,
          $$NotificationEventsTableFilterComposer,
          $$NotificationEventsTableOrderingComposer,
          $$NotificationEventsTableAnnotationComposer,
          $$NotificationEventsTableCreateCompanionBuilder,
          $$NotificationEventsTableUpdateCompanionBuilder,
          (
            NotificationEvent,
            BaseReferences<
              _$AppDatabase,
              $NotificationEventsTable,
              NotificationEvent
            >,
          ),
          NotificationEvent,
          PrefetchHooks Function()
        > {
  $$NotificationEventsTableTableManager(
    _$AppDatabase db,
    $NotificationEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> notificationId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<NotificationEventType> type = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String?> sourceId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> actionRoute = const Value.absent(),
                Value<String?> actionPayloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationEventsCompanion(
                notificationId: notificationId,
                userId: userId,
                type: type,
                sourceType: sourceType,
                sourceId: sourceId,
                title: title,
                body: body,
                actionRoute: actionRoute,
                actionPayloadJson: actionPayloadJson,
                createdAt: createdAt,
                expiresAt: expiresAt,
                readAt: readAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String notificationId,
                required String userId,
                required NotificationEventType type,
                required String sourceType,
                Value<String?> sourceId = const Value.absent(),
                required String title,
                required String body,
                Value<String?> actionRoute = const Value.absent(),
                Value<String?> actionPayloadJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationEventsCompanion.insert(
                notificationId: notificationId,
                userId: userId,
                type: type,
                sourceType: sourceType,
                sourceId: sourceId,
                title: title,
                body: body,
                actionRoute: actionRoute,
                actionPayloadJson: actionPayloadJson,
                createdAt: createdAt,
                expiresAt: expiresAt,
                readAt: readAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationEventsTable,
      NotificationEvent,
      $$NotificationEventsTableFilterComposer,
      $$NotificationEventsTableOrderingComposer,
      $$NotificationEventsTableAnnotationComposer,
      $$NotificationEventsTableCreateCompanionBuilder,
      $$NotificationEventsTableUpdateCompanionBuilder,
      (
        NotificationEvent,
        BaseReferences<
          _$AppDatabase,
          $NotificationEventsTable,
          NotificationEvent
        >,
      ),
      NotificationEvent,
      PrefetchHooks Function()
    >;
typedef $$ReminderSettingsTableCreateCompanionBuilder =
    ReminderSettingsCompanion Function({
      Value<int> id,
      required String userId,
      Value<ReminderType> type,
      Value<bool> isEnabled,
      Value<int> hour,
      Value<int> minute,
      Value<bool> isPermissionDenied,
      Value<DateTime> updatedAt,
    });
typedef $$ReminderSettingsTableUpdateCompanionBuilder =
    ReminderSettingsCompanion Function({
      Value<int> id,
      Value<String> userId,
      Value<ReminderType> type,
      Value<bool> isEnabled,
      Value<int> hour,
      Value<int> minute,
      Value<bool> isPermissionDenied,
      Value<DateTime> updatedAt,
    });

class $$ReminderSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTable> {
  $$ReminderSettingsTableFilterComposer({
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

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReminderType, ReminderType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPermissionDenied => $composableBuilder(
    column: $table.isPermissionDenied,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReminderSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTable> {
  $$ReminderSettingsTableOrderingComposer({
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

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPermissionDenied => $composableBuilder(
    column: $table.isPermissionDenied,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReminderSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReminderSettingsTable> {
  $$ReminderSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReminderType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<bool> get isPermissionDenied => $composableBuilder(
    column: $table.isPermissionDenied,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ReminderSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReminderSettingsTable,
          ReminderSetting,
          $$ReminderSettingsTableFilterComposer,
          $$ReminderSettingsTableOrderingComposer,
          $$ReminderSettingsTableAnnotationComposer,
          $$ReminderSettingsTableCreateCompanionBuilder,
          $$ReminderSettingsTableUpdateCompanionBuilder,
          (
            ReminderSetting,
            BaseReferences<
              _$AppDatabase,
              $ReminderSettingsTable,
              ReminderSetting
            >,
          ),
          ReminderSetting,
          PrefetchHooks Function()
        > {
  $$ReminderSettingsTableTableManager(
    _$AppDatabase db,
    $ReminderSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReminderSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReminderSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReminderSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<ReminderType> type = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
                Value<bool> isPermissionDenied = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ReminderSettingsCompanion(
                id: id,
                userId: userId,
                type: type,
                isEnabled: isEnabled,
                hour: hour,
                minute: minute,
                isPermissionDenied: isPermissionDenied,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String userId,
                Value<ReminderType> type = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
                Value<bool> isPermissionDenied = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ReminderSettingsCompanion.insert(
                id: id,
                userId: userId,
                type: type,
                isEnabled: isEnabled,
                hour: hour,
                minute: minute,
                isPermissionDenied: isPermissionDenied,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReminderSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReminderSettingsTable,
      ReminderSetting,
      $$ReminderSettingsTableFilterComposer,
      $$ReminderSettingsTableOrderingComposer,
      $$ReminderSettingsTableAnnotationComposer,
      $$ReminderSettingsTableCreateCompanionBuilder,
      $$ReminderSettingsTableUpdateCompanionBuilder,
      (
        ReminderSetting,
        BaseReferences<_$AppDatabase, $ReminderSettingsTable, ReminderSetting>,
      ),
      ReminderSetting,
      PrefetchHooks Function()
    >;
typedef $$UsageAggregateBucketsTableCreateCompanionBuilder =
    UsageAggregateBucketsCompanion Function({
      required String bucketDate,
      required String platform,
      required String buildChannel,
      required String screenName,
      required String metricName,
      Value<int> count,
      Value<int> totalDurationMs,
      Value<int> uploadedCount,
      Value<int> uploadedTotalDurationMs,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$UsageAggregateBucketsTableUpdateCompanionBuilder =
    UsageAggregateBucketsCompanion Function({
      Value<String> bucketDate,
      Value<String> platform,
      Value<String> buildChannel,
      Value<String> screenName,
      Value<String> metricName,
      Value<int> count,
      Value<int> totalDurationMs,
      Value<int> uploadedCount,
      Value<int> uploadedTotalDurationMs,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UsageAggregateBucketsTableFilterComposer
    extends Composer<_$AppDatabase, $UsageAggregateBucketsTable> {
  $$UsageAggregateBucketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get bucketDate => $composableBuilder(
    column: $table.bucketDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get buildChannel => $composableBuilder(
    column: $table.buildChannel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get screenName => $composableBuilder(
    column: $table.screenName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metricName => $composableBuilder(
    column: $table.metricName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalDurationMs => $composableBuilder(
    column: $table.totalDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uploadedCount => $composableBuilder(
    column: $table.uploadedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uploadedTotalDurationMs => $composableBuilder(
    column: $table.uploadedTotalDurationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsageAggregateBucketsTableOrderingComposer
    extends Composer<_$AppDatabase, $UsageAggregateBucketsTable> {
  $$UsageAggregateBucketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get bucketDate => $composableBuilder(
    column: $table.bucketDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get buildChannel => $composableBuilder(
    column: $table.buildChannel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get screenName => $composableBuilder(
    column: $table.screenName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metricName => $composableBuilder(
    column: $table.metricName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalDurationMs => $composableBuilder(
    column: $table.totalDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uploadedCount => $composableBuilder(
    column: $table.uploadedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uploadedTotalDurationMs => $composableBuilder(
    column: $table.uploadedTotalDurationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsageAggregateBucketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsageAggregateBucketsTable> {
  $$UsageAggregateBucketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get bucketDate => $composableBuilder(
    column: $table.bucketDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<String> get buildChannel => $composableBuilder(
    column: $table.buildChannel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get screenName => $composableBuilder(
    column: $table.screenName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metricName => $composableBuilder(
    column: $table.metricName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<int> get totalDurationMs => $composableBuilder(
    column: $table.totalDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get uploadedCount => $composableBuilder(
    column: $table.uploadedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get uploadedTotalDurationMs => $composableBuilder(
    column: $table.uploadedTotalDurationMs,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsageAggregateBucketsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsageAggregateBucketsTable,
          UsageAggregateBucket,
          $$UsageAggregateBucketsTableFilterComposer,
          $$UsageAggregateBucketsTableOrderingComposer,
          $$UsageAggregateBucketsTableAnnotationComposer,
          $$UsageAggregateBucketsTableCreateCompanionBuilder,
          $$UsageAggregateBucketsTableUpdateCompanionBuilder,
          (
            UsageAggregateBucket,
            BaseReferences<
              _$AppDatabase,
              $UsageAggregateBucketsTable,
              UsageAggregateBucket
            >,
          ),
          UsageAggregateBucket,
          PrefetchHooks Function()
        > {
  $$UsageAggregateBucketsTableTableManager(
    _$AppDatabase db,
    $UsageAggregateBucketsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsageAggregateBucketsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$UsageAggregateBucketsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UsageAggregateBucketsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> bucketDate = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<String> buildChannel = const Value.absent(),
                Value<String> screenName = const Value.absent(),
                Value<String> metricName = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int> totalDurationMs = const Value.absent(),
                Value<int> uploadedCount = const Value.absent(),
                Value<int> uploadedTotalDurationMs = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageAggregateBucketsCompanion(
                bucketDate: bucketDate,
                platform: platform,
                buildChannel: buildChannel,
                screenName: screenName,
                metricName: metricName,
                count: count,
                totalDurationMs: totalDurationMs,
                uploadedCount: uploadedCount,
                uploadedTotalDurationMs: uploadedTotalDurationMs,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String bucketDate,
                required String platform,
                required String buildChannel,
                required String screenName,
                required String metricName,
                Value<int> count = const Value.absent(),
                Value<int> totalDurationMs = const Value.absent(),
                Value<int> uploadedCount = const Value.absent(),
                Value<int> uploadedTotalDurationMs = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsageAggregateBucketsCompanion.insert(
                bucketDate: bucketDate,
                platform: platform,
                buildChannel: buildChannel,
                screenName: screenName,
                metricName: metricName,
                count: count,
                totalDurationMs: totalDurationMs,
                uploadedCount: uploadedCount,
                uploadedTotalDurationMs: uploadedTotalDurationMs,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsageAggregateBucketsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsageAggregateBucketsTable,
      UsageAggregateBucket,
      $$UsageAggregateBucketsTableFilterComposer,
      $$UsageAggregateBucketsTableOrderingComposer,
      $$UsageAggregateBucketsTableAnnotationComposer,
      $$UsageAggregateBucketsTableCreateCompanionBuilder,
      $$UsageAggregateBucketsTableUpdateCompanionBuilder,
      (
        UsageAggregateBucket,
        BaseReferences<
          _$AppDatabase,
          $UsageAggregateBucketsTable,
          UsageAggregateBucket
        >,
      ),
      UsageAggregateBucket,
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
  $$AcceptedFriendsTableTableManager get acceptedFriends =>
      $$AcceptedFriendsTableTableManager(_db, _db.acceptedFriends);
  $$FriendRelationshipsTableTableManager get friendRelationships =>
      $$FriendRelationshipsTableTableManager(_db, _db.friendRelationships);
  $$AchievementUnlocksTableTableManager get achievementUnlocks =>
      $$AchievementUnlocksTableTableManager(_db, _db.achievementUnlocks);
  $$NotificationEventsTableTableManager get notificationEvents =>
      $$NotificationEventsTableTableManager(_db, _db.notificationEvents);
  $$ReminderSettingsTableTableManager get reminderSettings =>
      $$ReminderSettingsTableTableManager(_db, _db.reminderSettings);
  $$UsageAggregateBucketsTableTableManager get usageAggregateBuckets =>
      $$UsageAggregateBucketsTableTableManager(_db, _db.usageAggregateBuckets);
}
