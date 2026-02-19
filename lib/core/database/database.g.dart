// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _muscleGroupMeta = const VerificationMeta(
    'muscleGroup',
  );
  @override
  late final GeneratedColumn<String> muscleGroup = GeneratedColumn<String>(
    'muscle_group',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCardioMeta = const VerificationMeta(
    'isCardio',
  );
  @override
  late final GeneratedColumn<bool> isCardio = GeneratedColumn<bool>(
    'is_cardio',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_cardio" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _cardioTypeMeta = const VerificationMeta(
    'cardioType',
  );
  @override
  late final GeneratedColumn<String> cardioType = GeneratedColumn<String>(
    'cardio_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    muscleGroup,
    isCardio,
    cardioType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<Exercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('muscle_group')) {
      context.handle(
        _muscleGroupMeta,
        muscleGroup.isAcceptableOrUnknown(
          data['muscle_group']!,
          _muscleGroupMeta,
        ),
      );
    }
    if (data.containsKey('is_cardio')) {
      context.handle(
        _isCardioMeta,
        isCardio.isAcceptableOrUnknown(data['is_cardio']!, _isCardioMeta),
      );
    }
    if (data.containsKey('cardio_type')) {
      context.handle(
        _cardioTypeMeta,
        cardioType.isAcceptableOrUnknown(data['cardio_type']!, _cardioTypeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      muscleGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}muscle_group'],
      ),
      isCardio: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_cardio'],
      )!,
      cardioType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cardio_type'],
      ),
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final int id;
  final String name;
  final String category;
  final String? muscleGroup;
  final bool isCardio;
  final String? cardioType;
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    this.muscleGroup,
    required this.isCardio,
    this.cardioType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || muscleGroup != null) {
      map['muscle_group'] = Variable<String>(muscleGroup);
    }
    map['is_cardio'] = Variable<bool>(isCardio);
    if (!nullToAbsent || cardioType != null) {
      map['cardio_type'] = Variable<String>(cardioType);
    }
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      muscleGroup: muscleGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(muscleGroup),
      isCardio: Value(isCardio),
      cardioType: cardioType == null && nullToAbsent
          ? const Value.absent()
          : Value(cardioType),
    );
  }

  factory Exercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      muscleGroup: serializer.fromJson<String?>(json['muscleGroup']),
      isCardio: serializer.fromJson<bool>(json['isCardio']),
      cardioType: serializer.fromJson<String?>(json['cardioType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'muscleGroup': serializer.toJson<String?>(muscleGroup),
      'isCardio': serializer.toJson<bool>(isCardio),
      'cardioType': serializer.toJson<String?>(cardioType),
    };
  }

  Exercise copyWith({
    int? id,
    String? name,
    String? category,
    Value<String?> muscleGroup = const Value.absent(),
    bool? isCardio,
    Value<String?> cardioType = const Value.absent(),
  }) => Exercise(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    muscleGroup: muscleGroup.present ? muscleGroup.value : this.muscleGroup,
    isCardio: isCardio ?? this.isCardio,
    cardioType: cardioType.present ? cardioType.value : this.cardioType,
  );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      muscleGroup: data.muscleGroup.present
          ? data.muscleGroup.value
          : this.muscleGroup,
      isCardio: data.isCardio.present ? data.isCardio.value : this.isCardio,
      cardioType: data.cardioType.present
          ? data.cardioType.value
          : this.cardioType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('isCardio: $isCardio, ')
          ..write('cardioType: $cardioType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, category, muscleGroup, isCardio, cardioType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.muscleGroup == this.muscleGroup &&
          other.isCardio == this.isCardio &&
          other.cardioType == this.cardioType);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String?> muscleGroup;
  final Value<bool> isCardio;
  final Value<String?> cardioType;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.muscleGroup = const Value.absent(),
    this.isCardio = const Value.absent(),
    this.cardioType = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    this.muscleGroup = const Value.absent(),
    this.isCardio = const Value.absent(),
    this.cardioType = const Value.absent(),
  }) : name = Value(name),
       category = Value(category);
  static Insertable<Exercise> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? muscleGroup,
    Expression<bool>? isCardio,
    Expression<String>? cardioType,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (muscleGroup != null) 'muscle_group': muscleGroup,
      if (isCardio != null) 'is_cardio': isCardio,
      if (cardioType != null) 'cardio_type': cardioType,
    });
  }

  ExercisesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String?>? muscleGroup,
    Value<bool>? isCardio,
    Value<String?>? cardioType,
  }) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      muscleGroup: muscleGroup ?? this.muscleGroup,
      isCardio: isCardio ?? this.isCardio,
      cardioType: cardioType ?? this.cardioType,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (muscleGroup.present) {
      map['muscle_group'] = Variable<String>(muscleGroup.value);
    }
    if (isCardio.present) {
      map['is_cardio'] = Variable<bool>(isCardio.value);
    }
    if (cardioType.present) {
      map['cardio_type'] = Variable<String>(cardioType.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('muscleGroup: $muscleGroup, ')
          ..write('isCardio: $isCardio, ')
          ..write('cardioType: $cardioType')
          ..write(')'))
        .toString();
  }
}

class $ExerciseLogsTable extends ExerciseLogs
    with TableInfo<$ExerciseLogsTable, ExerciseLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercises (id)',
    ),
  );
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
    'sets',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceKmMeta = const VerificationMeta(
    'distanceKm',
  );
  @override
  late final GeneratedColumn<double> distanceKm = GeneratedColumn<double>(
    'distance_km',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    logDate,
    exerciseId,
    sets,
    reps,
    weight,
    durationMinutes,
    distanceKm,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
        _setsMeta,
        sets.isAcceptableOrUnknown(data['sets']!, _setsMeta),
      );
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('distance_km')) {
      context.handle(
        _distanceKmMeta,
        distanceKm.isAcceptableOrUnknown(data['distance_km']!, _distanceKmMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exercise_id'],
      )!,
      sets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sets'],
      ),
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      ),
      distanceKm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}distance_km'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ExerciseLogsTable createAlias(String alias) {
    return $ExerciseLogsTable(attachedDatabase, alias);
  }
}

class ExerciseLog extends DataClass implements Insertable<ExerciseLog> {
  final int id;
  final DateTime logDate;
  final int exerciseId;
  final int? sets;
  final int? reps;
  final double? weight;
  final int? durationMinutes;
  final double? distanceKm;
  final String? notes;
  const ExerciseLog({
    required this.id,
    required this.logDate,
    required this.exerciseId,
    this.sets,
    this.reps,
    this.weight,
    this.durationMinutes,
    this.distanceKm,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['log_date'] = Variable<DateTime>(logDate);
    map['exercise_id'] = Variable<int>(exerciseId);
    if (!nullToAbsent || sets != null) {
      map['sets'] = Variable<int>(sets);
    }
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || durationMinutes != null) {
      map['duration_minutes'] = Variable<int>(durationMinutes);
    }
    if (!nullToAbsent || distanceKm != null) {
      map['distance_km'] = Variable<double>(distanceKm);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ExerciseLogsCompanion toCompanion(bool nullToAbsent) {
    return ExerciseLogsCompanion(
      id: Value(id),
      logDate: Value(logDate),
      exerciseId: Value(exerciseId),
      sets: sets == null && nullToAbsent ? const Value.absent() : Value(sets),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      weight: weight == null && nullToAbsent
          ? const Value.absent()
          : Value(weight),
      durationMinutes: durationMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinutes),
      distanceKm: distanceKm == null && nullToAbsent
          ? const Value.absent()
          : Value(distanceKm),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory ExerciseLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseLog(
      id: serializer.fromJson<int>(json['id']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      sets: serializer.fromJson<int?>(json['sets']),
      reps: serializer.fromJson<int?>(json['reps']),
      weight: serializer.fromJson<double?>(json['weight']),
      durationMinutes: serializer.fromJson<int?>(json['durationMinutes']),
      distanceKm: serializer.fromJson<double?>(json['distanceKm']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'logDate': serializer.toJson<DateTime>(logDate),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'sets': serializer.toJson<int?>(sets),
      'reps': serializer.toJson<int?>(reps),
      'weight': serializer.toJson<double?>(weight),
      'durationMinutes': serializer.toJson<int?>(durationMinutes),
      'distanceKm': serializer.toJson<double?>(distanceKm),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  ExerciseLog copyWith({
    int? id,
    DateTime? logDate,
    int? exerciseId,
    Value<int?> sets = const Value.absent(),
    Value<int?> reps = const Value.absent(),
    Value<double?> weight = const Value.absent(),
    Value<int?> durationMinutes = const Value.absent(),
    Value<double?> distanceKm = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => ExerciseLog(
    id: id ?? this.id,
    logDate: logDate ?? this.logDate,
    exerciseId: exerciseId ?? this.exerciseId,
    sets: sets.present ? sets.value : this.sets,
    reps: reps.present ? reps.value : this.reps,
    weight: weight.present ? weight.value : this.weight,
    durationMinutes: durationMinutes.present
        ? durationMinutes.value
        : this.durationMinutes,
    distanceKm: distanceKm.present ? distanceKm.value : this.distanceKm,
    notes: notes.present ? notes.value : this.notes,
  );
  ExerciseLog copyWithCompanion(ExerciseLogsCompanion data) {
    return ExerciseLog(
      id: data.id.present ? data.id.value : this.id,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      sets: data.sets.present ? data.sets.value : this.sets,
      reps: data.reps.present ? data.reps.value : this.reps,
      weight: data.weight.present ? data.weight.value : this.weight,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      distanceKm: data.distanceKm.present
          ? data.distanceKm.value
          : this.distanceKm,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseLog(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    logDate,
    exerciseId,
    sets,
    reps,
    weight,
    durationMinutes,
    distanceKm,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseLog &&
          other.id == this.id &&
          other.logDate == this.logDate &&
          other.exerciseId == this.exerciseId &&
          other.sets == this.sets &&
          other.reps == this.reps &&
          other.weight == this.weight &&
          other.durationMinutes == this.durationMinutes &&
          other.distanceKm == this.distanceKm &&
          other.notes == this.notes);
}

class ExerciseLogsCompanion extends UpdateCompanion<ExerciseLog> {
  final Value<int> id;
  final Value<DateTime> logDate;
  final Value<int> exerciseId;
  final Value<int?> sets;
  final Value<int?> reps;
  final Value<double?> weight;
  final Value<int?> durationMinutes;
  final Value<double?> distanceKm;
  final Value<String?> notes;
  const ExerciseLogsCompanion({
    this.id = const Value.absent(),
    this.logDate = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ExerciseLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime logDate,
    required int exerciseId,
    this.sets = const Value.absent(),
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.distanceKm = const Value.absent(),
    this.notes = const Value.absent(),
  }) : logDate = Value(logDate),
       exerciseId = Value(exerciseId);
  static Insertable<ExerciseLog> custom({
    Expression<int>? id,
    Expression<DateTime>? logDate,
    Expression<int>? exerciseId,
    Expression<int>? sets,
    Expression<int>? reps,
    Expression<double>? weight,
    Expression<int>? durationMinutes,
    Expression<double>? distanceKm,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logDate != null) 'log_date': logDate,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (sets != null) 'sets': sets,
      if (reps != null) 'reps': reps,
      if (weight != null) 'weight': weight,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (distanceKm != null) 'distance_km': distanceKm,
      if (notes != null) 'notes': notes,
    });
  }

  ExerciseLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? logDate,
    Value<int>? exerciseId,
    Value<int?>? sets,
    Value<int?>? reps,
    Value<double?>? weight,
    Value<int?>? durationMinutes,
    Value<double?>? distanceKm,
    Value<String?>? notes,
  }) {
    return ExerciseLogsCompanion(
      id: id ?? this.id,
      logDate: logDate ?? this.logDate,
      exerciseId: exerciseId ?? this.exerciseId,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      distanceKm: distanceKm ?? this.distanceKm,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (distanceKm.present) {
      map['distance_km'] = Variable<double>(distanceKm.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseLogsCompanion(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('sets: $sets, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('distanceKm: $distanceKm, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $FoodsTable extends Foods with TableInfo<$FoodsTable, Food> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fiberMeta = const VerificationMeta('fiber');
  @override
  late final GeneratedColumn<double> fiber = GeneratedColumn<double>(
    'fiber',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sugarMeta = const VerificationMeta('sugar');
  @override
  late final GeneratedColumn<double> sugar = GeneratedColumn<double>(
    'sugar',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servingSizeMeta = const VerificationMeta(
    'servingSize',
  );
  @override
  late final GeneratedColumn<double> servingSize = GeneratedColumn<double>(
    'serving_size',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _servingUnitMeta = const VerificationMeta(
    'servingUnit',
  );
  @override
  late final GeneratedColumn<String> servingUnit = GeneratedColumn<String>(
    'serving_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('g'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('custom'),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verifiedMeta = const VerificationMeta(
    'verified',
  );
  @override
  late final GeneratedColumn<bool> verified = GeneratedColumn<bool>(
    'verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    barcode,
    calories,
    protein,
    carbs,
    fat,
    fiber,
    sugar,
    servingSize,
    servingUnit,
    source,
    imageUrl,
    verified,
    createdBy,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<Food> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsMeta);
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    if (data.containsKey('fiber')) {
      context.handle(
        _fiberMeta,
        fiber.isAcceptableOrUnknown(data['fiber']!, _fiberMeta),
      );
    }
    if (data.containsKey('sugar')) {
      context.handle(
        _sugarMeta,
        sugar.isAcceptableOrUnknown(data['sugar']!, _sugarMeta),
      );
    }
    if (data.containsKey('serving_size')) {
      context.handle(
        _servingSizeMeta,
        servingSize.isAcceptableOrUnknown(
          data['serving_size']!,
          _servingSizeMeta,
        ),
      );
    }
    if (data.containsKey('serving_unit')) {
      context.handle(
        _servingUnitMeta,
        servingUnit.isAcceptableOrUnknown(
          data['serving_unit']!,
          _servingUnitMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('verified')) {
      context.handle(
        _verifiedMeta,
        verified.isAcceptableOrUnknown(data['verified']!, _verifiedMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Food map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Food(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      )!,
      fiber: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fiber'],
      ),
      sugar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sugar'],
      ),
      servingSize: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}serving_size'],
      )!,
      servingUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serving_unit'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      verified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}verified'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
    );
  }

  @override
  $FoodsTable createAlias(String alias) {
    return $FoodsTable(attachedDatabase, alias);
  }
}

class Food extends DataClass implements Insertable<Food> {
  final int id;
  final String name;
  final String? barcode;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double? fiber;
  final double? sugar;
  final double servingSize;
  final String servingUnit;
  final String source;
  final String? imageUrl;
  final bool verified;
  final String? createdBy;
  const Food({
    required this.id,
    required this.name,
    this.barcode,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber,
    this.sugar,
    required this.servingSize,
    required this.servingUnit,
    required this.source,
    this.imageUrl,
    required this.verified,
    this.createdBy,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['calories'] = Variable<double>(calories);
    map['protein'] = Variable<double>(protein);
    map['carbs'] = Variable<double>(carbs);
    map['fat'] = Variable<double>(fat);
    if (!nullToAbsent || fiber != null) {
      map['fiber'] = Variable<double>(fiber);
    }
    if (!nullToAbsent || sugar != null) {
      map['sugar'] = Variable<double>(sugar);
    }
    map['serving_size'] = Variable<double>(servingSize);
    map['serving_unit'] = Variable<String>(servingUnit);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['verified'] = Variable<bool>(verified);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      id: Value(id),
      name: Value(name),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      calories: Value(calories),
      protein: Value(protein),
      carbs: Value(carbs),
      fat: Value(fat),
      fiber: fiber == null && nullToAbsent
          ? const Value.absent()
          : Value(fiber),
      sugar: sugar == null && nullToAbsent
          ? const Value.absent()
          : Value(sugar),
      servingSize: Value(servingSize),
      servingUnit: Value(servingUnit),
      source: Value(source),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      verified: Value(verified),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
    );
  }

  factory Food.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Food(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      calories: serializer.fromJson<double>(json['calories']),
      protein: serializer.fromJson<double>(json['protein']),
      carbs: serializer.fromJson<double>(json['carbs']),
      fat: serializer.fromJson<double>(json['fat']),
      fiber: serializer.fromJson<double?>(json['fiber']),
      sugar: serializer.fromJson<double?>(json['sugar']),
      servingSize: serializer.fromJson<double>(json['servingSize']),
      servingUnit: serializer.fromJson<String>(json['servingUnit']),
      source: serializer.fromJson<String>(json['source']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      verified: serializer.fromJson<bool>(json['verified']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'barcode': serializer.toJson<String?>(barcode),
      'calories': serializer.toJson<double>(calories),
      'protein': serializer.toJson<double>(protein),
      'carbs': serializer.toJson<double>(carbs),
      'fat': serializer.toJson<double>(fat),
      'fiber': serializer.toJson<double?>(fiber),
      'sugar': serializer.toJson<double?>(sugar),
      'servingSize': serializer.toJson<double>(servingSize),
      'servingUnit': serializer.toJson<String>(servingUnit),
      'source': serializer.toJson<String>(source),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'verified': serializer.toJson<bool>(verified),
      'createdBy': serializer.toJson<String?>(createdBy),
    };
  }

  Food copyWith({
    int? id,
    String? name,
    Value<String?> barcode = const Value.absent(),
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    Value<double?> fiber = const Value.absent(),
    Value<double?> sugar = const Value.absent(),
    double? servingSize,
    String? servingUnit,
    String? source,
    Value<String?> imageUrl = const Value.absent(),
    bool? verified,
    Value<String?> createdBy = const Value.absent(),
  }) => Food(
    id: id ?? this.id,
    name: name ?? this.name,
    barcode: barcode.present ? barcode.value : this.barcode,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    fiber: fiber.present ? fiber.value : this.fiber,
    sugar: sugar.present ? sugar.value : this.sugar,
    servingSize: servingSize ?? this.servingSize,
    servingUnit: servingUnit ?? this.servingUnit,
    source: source ?? this.source,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    verified: verified ?? this.verified,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
  );
  Food copyWithCompanion(FoodsCompanion data) {
    return Food(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
      fiber: data.fiber.present ? data.fiber.value : this.fiber,
      sugar: data.sugar.present ? data.sugar.value : this.sugar,
      servingSize: data.servingSize.present
          ? data.servingSize.value
          : this.servingSize,
      servingUnit: data.servingUnit.present
          ? data.servingUnit.value
          : this.servingUnit,
      source: data.source.present ? data.source.value : this.source,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      verified: data.verified.present ? data.verified.value : this.verified,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Food(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('fiber: $fiber, ')
          ..write('sugar: $sugar, ')
          ..write('servingSize: $servingSize, ')
          ..write('servingUnit: $servingUnit, ')
          ..write('source: $source, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('verified: $verified, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    barcode,
    calories,
    protein,
    carbs,
    fat,
    fiber,
    sugar,
    servingSize,
    servingUnit,
    source,
    imageUrl,
    verified,
    createdBy,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Food &&
          other.id == this.id &&
          other.name == this.name &&
          other.barcode == this.barcode &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat &&
          other.fiber == this.fiber &&
          other.sugar == this.sugar &&
          other.servingSize == this.servingSize &&
          other.servingUnit == this.servingUnit &&
          other.source == this.source &&
          other.imageUrl == this.imageUrl &&
          other.verified == this.verified &&
          other.createdBy == this.createdBy);
}

class FoodsCompanion extends UpdateCompanion<Food> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> barcode;
  final Value<double> calories;
  final Value<double> protein;
  final Value<double> carbs;
  final Value<double> fat;
  final Value<double?> fiber;
  final Value<double?> sugar;
  final Value<double> servingSize;
  final Value<String> servingUnit;
  final Value<String> source;
  final Value<String?> imageUrl;
  final Value<bool> verified;
  final Value<String?> createdBy;
  const FoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.barcode = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.fiber = const Value.absent(),
    this.sugar = const Value.absent(),
    this.servingSize = const Value.absent(),
    this.servingUnit = const Value.absent(),
    this.source = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.verified = const Value.absent(),
    this.createdBy = const Value.absent(),
  });
  FoodsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.barcode = const Value.absent(),
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
    this.fiber = const Value.absent(),
    this.sugar = const Value.absent(),
    this.servingSize = const Value.absent(),
    this.servingUnit = const Value.absent(),
    this.source = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.verified = const Value.absent(),
    this.createdBy = const Value.absent(),
  }) : name = Value(name),
       calories = Value(calories),
       protein = Value(protein),
       carbs = Value(carbs),
       fat = Value(fat);
  static Insertable<Food> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? barcode,
    Expression<double>? calories,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? fat,
    Expression<double>? fiber,
    Expression<double>? sugar,
    Expression<double>? servingSize,
    Expression<String>? servingUnit,
    Expression<String>? source,
    Expression<String>? imageUrl,
    Expression<bool>? verified,
    Expression<String>? createdBy,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (barcode != null) 'barcode': barcode,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (fiber != null) 'fiber': fiber,
      if (sugar != null) 'sugar': sugar,
      if (servingSize != null) 'serving_size': servingSize,
      if (servingUnit != null) 'serving_unit': servingUnit,
      if (source != null) 'source': source,
      if (imageUrl != null) 'image_url': imageUrl,
      if (verified != null) 'verified': verified,
      if (createdBy != null) 'created_by': createdBy,
    });
  }

  FoodsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? barcode,
    Value<double>? calories,
    Value<double>? protein,
    Value<double>? carbs,
    Value<double>? fat,
    Value<double?>? fiber,
    Value<double?>? sugar,
    Value<double>? servingSize,
    Value<String>? servingUnit,
    Value<String>? source,
    Value<String?>? imageUrl,
    Value<bool>? verified,
    Value<String?>? createdBy,
  }) {
    return FoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      barcode: barcode ?? this.barcode,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      servingSize: servingSize ?? this.servingSize,
      servingUnit: servingUnit ?? this.servingUnit,
      source: source ?? this.source,
      imageUrl: imageUrl ?? this.imageUrl,
      verified: verified ?? this.verified,
      createdBy: createdBy ?? this.createdBy,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (fiber.present) {
      map['fiber'] = Variable<double>(fiber.value);
    }
    if (sugar.present) {
      map['sugar'] = Variable<double>(sugar.value);
    }
    if (servingSize.present) {
      map['serving_size'] = Variable<double>(servingSize.value);
    }
    if (servingUnit.present) {
      map['serving_unit'] = Variable<String>(servingUnit.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (verified.present) {
      map['verified'] = Variable<bool>(verified.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('barcode: $barcode, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('fiber: $fiber, ')
          ..write('sugar: $sugar, ')
          ..write('servingSize: $servingSize, ')
          ..write('servingUnit: $servingUnit, ')
          ..write('source: $source, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('verified: $verified, ')
          ..write('createdBy: $createdBy')
          ..write(')'))
        .toString();
  }
}

class $FoodLogsTable extends FoodLogs with TableInfo<$FoodLogsTable, FoodLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<int> foodId = GeneratedColumn<int>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES foods (id)',
    ),
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<double> servings = GeneratedColumn<double>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isEatenMeta = const VerificationMeta(
    'isEaten',
  );
  @override
  late final GeneratedColumn<bool> isEaten = GeneratedColumn<bool>(
    'is_eaten',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_eaten" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    logDate,
    foodId,
    servings,
    mealType,
    isEaten,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('is_eaten')) {
      context.handle(
        _isEatenMeta,
        isEaten.isAcceptableOrUnknown(data['is_eaten']!, _isEatenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}food_id'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}servings'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      isEaten: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_eaten'],
      )!,
    );
  }

  @override
  $FoodLogsTable createAlias(String alias) {
    return $FoodLogsTable(attachedDatabase, alias);
  }
}

class FoodLog extends DataClass implements Insertable<FoodLog> {
  final int id;
  final DateTime logDate;
  final int foodId;
  final double servings;
  final String mealType;
  final bool isEaten;
  const FoodLog({
    required this.id,
    required this.logDate,
    required this.foodId,
    required this.servings,
    required this.mealType,
    required this.isEaten,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['log_date'] = Variable<DateTime>(logDate);
    map['food_id'] = Variable<int>(foodId);
    map['servings'] = Variable<double>(servings);
    map['meal_type'] = Variable<String>(mealType);
    map['is_eaten'] = Variable<bool>(isEaten);
    return map;
  }

  FoodLogsCompanion toCompanion(bool nullToAbsent) {
    return FoodLogsCompanion(
      id: Value(id),
      logDate: Value(logDate),
      foodId: Value(foodId),
      servings: Value(servings),
      mealType: Value(mealType),
      isEaten: Value(isEaten),
    );
  }

  factory FoodLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodLog(
      id: serializer.fromJson<int>(json['id']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      foodId: serializer.fromJson<int>(json['foodId']),
      servings: serializer.fromJson<double>(json['servings']),
      mealType: serializer.fromJson<String>(json['mealType']),
      isEaten: serializer.fromJson<bool>(json['isEaten']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'logDate': serializer.toJson<DateTime>(logDate),
      'foodId': serializer.toJson<int>(foodId),
      'servings': serializer.toJson<double>(servings),
      'mealType': serializer.toJson<String>(mealType),
      'isEaten': serializer.toJson<bool>(isEaten),
    };
  }

  FoodLog copyWith({
    int? id,
    DateTime? logDate,
    int? foodId,
    double? servings,
    String? mealType,
    bool? isEaten,
  }) => FoodLog(
    id: id ?? this.id,
    logDate: logDate ?? this.logDate,
    foodId: foodId ?? this.foodId,
    servings: servings ?? this.servings,
    mealType: mealType ?? this.mealType,
    isEaten: isEaten ?? this.isEaten,
  );
  FoodLog copyWithCompanion(FoodLogsCompanion data) {
    return FoodLog(
      id: data.id.present ? data.id.value : this.id,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      servings: data.servings.present ? data.servings.value : this.servings,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      isEaten: data.isEaten.present ? data.isEaten.value : this.isEaten,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodLog(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('foodId: $foodId, ')
          ..write('servings: $servings, ')
          ..write('mealType: $mealType, ')
          ..write('isEaten: $isEaten')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, logDate, foodId, servings, mealType, isEaten);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodLog &&
          other.id == this.id &&
          other.logDate == this.logDate &&
          other.foodId == this.foodId &&
          other.servings == this.servings &&
          other.mealType == this.mealType &&
          other.isEaten == this.isEaten);
}

class FoodLogsCompanion extends UpdateCompanion<FoodLog> {
  final Value<int> id;
  final Value<DateTime> logDate;
  final Value<int> foodId;
  final Value<double> servings;
  final Value<String> mealType;
  final Value<bool> isEaten;
  const FoodLogsCompanion({
    this.id = const Value.absent(),
    this.logDate = const Value.absent(),
    this.foodId = const Value.absent(),
    this.servings = const Value.absent(),
    this.mealType = const Value.absent(),
    this.isEaten = const Value.absent(),
  });
  FoodLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime logDate,
    required int foodId,
    this.servings = const Value.absent(),
    required String mealType,
    this.isEaten = const Value.absent(),
  }) : logDate = Value(logDate),
       foodId = Value(foodId),
       mealType = Value(mealType);
  static Insertable<FoodLog> custom({
    Expression<int>? id,
    Expression<DateTime>? logDate,
    Expression<int>? foodId,
    Expression<double>? servings,
    Expression<String>? mealType,
    Expression<bool>? isEaten,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logDate != null) 'log_date': logDate,
      if (foodId != null) 'food_id': foodId,
      if (servings != null) 'servings': servings,
      if (mealType != null) 'meal_type': mealType,
      if (isEaten != null) 'is_eaten': isEaten,
    });
  }

  FoodLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? logDate,
    Value<int>? foodId,
    Value<double>? servings,
    Value<String>? mealType,
    Value<bool>? isEaten,
  }) {
    return FoodLogsCompanion(
      id: id ?? this.id,
      logDate: logDate ?? this.logDate,
      foodId: foodId ?? this.foodId,
      servings: servings ?? this.servings,
      mealType: mealType ?? this.mealType,
      isEaten: isEaten ?? this.isEaten,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<int>(foodId.value);
    }
    if (servings.present) {
      map['servings'] = Variable<double>(servings.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (isEaten.present) {
      map['is_eaten'] = Variable<bool>(isEaten.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodLogsCompanion(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('foodId: $foodId, ')
          ..write('servings: $servings, ')
          ..write('mealType: $mealType, ')
          ..write('isEaten: $isEaten')
          ..write(')'))
        .toString();
  }
}

class $SupplementsTable extends Supplements
    with TableInfo<$SupplementsTable, Supplement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplementsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dosageUnitMeta = const VerificationMeta(
    'dosageUnit',
  );
  @override
  late final GeneratedColumn<String> dosageUnit = GeneratedColumn<String>(
    'dosage_unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('mg'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, type, dosageUnit];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('dosage_unit')) {
      context.handle(
        _dosageUnitMeta,
        dosageUnit.isAcceptableOrUnknown(data['dosage_unit']!, _dosageUnitMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      dosageUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage_unit'],
      )!,
    );
  }

  @override
  $SupplementsTable createAlias(String alias) {
    return $SupplementsTable(attachedDatabase, alias);
  }
}

class Supplement extends DataClass implements Insertable<Supplement> {
  final int id;
  final String name;
  final String type;
  final String dosageUnit;
  const Supplement({
    required this.id,
    required this.name,
    required this.type,
    required this.dosageUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['dosage_unit'] = Variable<String>(dosageUnit);
    return map;
  }

  SupplementsCompanion toCompanion(bool nullToAbsent) {
    return SupplementsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      dosageUnit: Value(dosageUnit),
    );
  }

  factory Supplement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplement(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      dosageUnit: serializer.fromJson<String>(json['dosageUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'dosageUnit': serializer.toJson<String>(dosageUnit),
    };
  }

  Supplement copyWith({
    int? id,
    String? name,
    String? type,
    String? dosageUnit,
  }) => Supplement(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    dosageUnit: dosageUnit ?? this.dosageUnit,
  );
  Supplement copyWithCompanion(SupplementsCompanion data) {
    return Supplement(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      dosageUnit: data.dosageUnit.present
          ? data.dosageUnit.value
          : this.dosageUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplement(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('dosageUnit: $dosageUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, dosageUnit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplement &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.dosageUnit == this.dosageUnit);
}

class SupplementsCompanion extends UpdateCompanion<Supplement> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> dosageUnit;
  const SupplementsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.dosageUnit = const Value.absent(),
  });
  SupplementsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String type,
    this.dosageUnit = const Value.absent(),
  }) : name = Value(name),
       type = Value(type);
  static Insertable<Supplement> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? dosageUnit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (dosageUnit != null) 'dosage_unit': dosageUnit,
    });
  }

  SupplementsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String>? dosageUnit,
  }) {
    return SupplementsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      dosageUnit: dosageUnit ?? this.dosageUnit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (dosageUnit.present) {
      map['dosage_unit'] = Variable<String>(dosageUnit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplementsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('dosageUnit: $dosageUnit')
          ..write(')'))
        .toString();
  }
}

class $SupplementLogsTable extends SupplementLogs
    with TableInfo<$SupplementLogsTable, SupplementLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplementLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplementIdMeta = const VerificationMeta(
    'supplementId',
  );
  @override
  late final GeneratedColumn<int> supplementId = GeneratedColumn<int>(
    'supplement_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES supplements (id)',
    ),
  );
  static const VerificationMeta _dosageMeta = const VerificationMeta('dosage');
  @override
  late final GeneratedColumn<double> dosage = GeneratedColumn<double>(
    'dosage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, logDate, supplementId, dosage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplement_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplementLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('supplement_id')) {
      context.handle(
        _supplementIdMeta,
        supplementId.isAcceptableOrUnknown(
          data['supplement_id']!,
          _supplementIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supplementIdMeta);
    }
    if (data.containsKey('dosage')) {
      context.handle(
        _dosageMeta,
        dosage.isAcceptableOrUnknown(data['dosage']!, _dosageMeta),
      );
    } else if (isInserting) {
      context.missing(_dosageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplementLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplementLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      supplementId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}supplement_id'],
      )!,
      dosage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}dosage'],
      )!,
    );
  }

  @override
  $SupplementLogsTable createAlias(String alias) {
    return $SupplementLogsTable(attachedDatabase, alias);
  }
}

class SupplementLog extends DataClass implements Insertable<SupplementLog> {
  final int id;
  final DateTime logDate;
  final int supplementId;
  final double dosage;
  const SupplementLog({
    required this.id,
    required this.logDate,
    required this.supplementId,
    required this.dosage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['log_date'] = Variable<DateTime>(logDate);
    map['supplement_id'] = Variable<int>(supplementId);
    map['dosage'] = Variable<double>(dosage);
    return map;
  }

  SupplementLogsCompanion toCompanion(bool nullToAbsent) {
    return SupplementLogsCompanion(
      id: Value(id),
      logDate: Value(logDate),
      supplementId: Value(supplementId),
      dosage: Value(dosage),
    );
  }

  factory SupplementLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplementLog(
      id: serializer.fromJson<int>(json['id']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      supplementId: serializer.fromJson<int>(json['supplementId']),
      dosage: serializer.fromJson<double>(json['dosage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'logDate': serializer.toJson<DateTime>(logDate),
      'supplementId': serializer.toJson<int>(supplementId),
      'dosage': serializer.toJson<double>(dosage),
    };
  }

  SupplementLog copyWith({
    int? id,
    DateTime? logDate,
    int? supplementId,
    double? dosage,
  }) => SupplementLog(
    id: id ?? this.id,
    logDate: logDate ?? this.logDate,
    supplementId: supplementId ?? this.supplementId,
    dosage: dosage ?? this.dosage,
  );
  SupplementLog copyWithCompanion(SupplementLogsCompanion data) {
    return SupplementLog(
      id: data.id.present ? data.id.value : this.id,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      supplementId: data.supplementId.present
          ? data.supplementId.value
          : this.supplementId,
      dosage: data.dosage.present ? data.dosage.value : this.dosage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplementLog(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('supplementId: $supplementId, ')
          ..write('dosage: $dosage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, logDate, supplementId, dosage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplementLog &&
          other.id == this.id &&
          other.logDate == this.logDate &&
          other.supplementId == this.supplementId &&
          other.dosage == this.dosage);
}

class SupplementLogsCompanion extends UpdateCompanion<SupplementLog> {
  final Value<int> id;
  final Value<DateTime> logDate;
  final Value<int> supplementId;
  final Value<double> dosage;
  const SupplementLogsCompanion({
    this.id = const Value.absent(),
    this.logDate = const Value.absent(),
    this.supplementId = const Value.absent(),
    this.dosage = const Value.absent(),
  });
  SupplementLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime logDate,
    required int supplementId,
    required double dosage,
  }) : logDate = Value(logDate),
       supplementId = Value(supplementId),
       dosage = Value(dosage);
  static Insertable<SupplementLog> custom({
    Expression<int>? id,
    Expression<DateTime>? logDate,
    Expression<int>? supplementId,
    Expression<double>? dosage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logDate != null) 'log_date': logDate,
      if (supplementId != null) 'supplement_id': supplementId,
      if (dosage != null) 'dosage': dosage,
    });
  }

  SupplementLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? logDate,
    Value<int>? supplementId,
    Value<double>? dosage,
  }) {
    return SupplementLogsCompanion(
      id: id ?? this.id,
      logDate: logDate ?? this.logDate,
      supplementId: supplementId ?? this.supplementId,
      dosage: dosage ?? this.dosage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (supplementId.present) {
      map['supplement_id'] = Variable<int>(supplementId.value);
    }
    if (dosage.present) {
      map['dosage'] = Variable<double>(dosage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplementLogsCompanion(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('supplementId: $supplementId, ')
          ..write('dosage: $dosage')
          ..write(')'))
        .toString();
  }
}

class $AlcoholLogsTable extends AlcoholLogs
    with TableInfo<$AlcoholLogsTable, AlcoholLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlcoholLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _drinkTypeMeta = const VerificationMeta(
    'drinkType',
  );
  @override
  late final GeneratedColumn<String> drinkType = GeneratedColumn<String>(
    'drink_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitsMeta = const VerificationMeta('units');
  @override
  late final GeneratedColumn<double> units = GeneratedColumn<double>(
    'units',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<double> calories = GeneratedColumn<double>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _volumeMlMeta = const VerificationMeta(
    'volumeMl',
  );
  @override
  late final GeneratedColumn<double> volumeMl = GeneratedColumn<double>(
    'volume_ml',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<double> protein = GeneratedColumn<double>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<double> carbs = GeneratedColumn<double>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<double> fat = GeneratedColumn<double>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isEatenMeta = const VerificationMeta(
    'isEaten',
  );
  @override
  late final GeneratedColumn<bool> isEaten = GeneratedColumn<bool>(
    'is_eaten',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_eaten" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    logDate,
    drinkType,
    units,
    calories,
    volumeMl,
    protein,
    carbs,
    fat,
    isEaten,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alcohol_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlcoholLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('drink_type')) {
      context.handle(
        _drinkTypeMeta,
        drinkType.isAcceptableOrUnknown(data['drink_type']!, _drinkTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_drinkTypeMeta);
    }
    if (data.containsKey('units')) {
      context.handle(
        _unitsMeta,
        units.isAcceptableOrUnknown(data['units']!, _unitsMeta),
      );
    } else if (isInserting) {
      context.missing(_unitsMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('volume_ml')) {
      context.handle(
        _volumeMlMeta,
        volumeMl.isAcceptableOrUnknown(data['volume_ml']!, _volumeMlMeta),
      );
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    }
    if (data.containsKey('is_eaten')) {
      context.handle(
        _isEatenMeta,
        isEaten.isAcceptableOrUnknown(data['is_eaten']!, _isEatenMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlcoholLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlcoholLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      drinkType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drink_type'],
      )!,
      units: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}units'],
      )!,
      calories: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories'],
      )!,
      volumeMl: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volume_ml'],
      ),
      protein: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein'],
      )!,
      carbs: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs'],
      )!,
      fat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat'],
      )!,
      isEaten: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_eaten'],
      )!,
    );
  }

  @override
  $AlcoholLogsTable createAlias(String alias) {
    return $AlcoholLogsTable(attachedDatabase, alias);
  }
}

class AlcoholLog extends DataClass implements Insertable<AlcoholLog> {
  final int id;
  final DateTime logDate;
  final String drinkType;
  final double units;
  final double calories;
  final double? volumeMl;
  final double protein;
  final double carbs;
  final double fat;
  final bool isEaten;
  const AlcoholLog({
    required this.id,
    required this.logDate,
    required this.drinkType,
    required this.units,
    required this.calories,
    this.volumeMl,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.isEaten,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['log_date'] = Variable<DateTime>(logDate);
    map['drink_type'] = Variable<String>(drinkType);
    map['units'] = Variable<double>(units);
    map['calories'] = Variable<double>(calories);
    if (!nullToAbsent || volumeMl != null) {
      map['volume_ml'] = Variable<double>(volumeMl);
    }
    map['protein'] = Variable<double>(protein);
    map['carbs'] = Variable<double>(carbs);
    map['fat'] = Variable<double>(fat);
    map['is_eaten'] = Variable<bool>(isEaten);
    return map;
  }

  AlcoholLogsCompanion toCompanion(bool nullToAbsent) {
    return AlcoholLogsCompanion(
      id: Value(id),
      logDate: Value(logDate),
      drinkType: Value(drinkType),
      units: Value(units),
      calories: Value(calories),
      volumeMl: volumeMl == null && nullToAbsent
          ? const Value.absent()
          : Value(volumeMl),
      protein: Value(protein),
      carbs: Value(carbs),
      fat: Value(fat),
      isEaten: Value(isEaten),
    );
  }

  factory AlcoholLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlcoholLog(
      id: serializer.fromJson<int>(json['id']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      drinkType: serializer.fromJson<String>(json['drinkType']),
      units: serializer.fromJson<double>(json['units']),
      calories: serializer.fromJson<double>(json['calories']),
      volumeMl: serializer.fromJson<double?>(json['volumeMl']),
      protein: serializer.fromJson<double>(json['protein']),
      carbs: serializer.fromJson<double>(json['carbs']),
      fat: serializer.fromJson<double>(json['fat']),
      isEaten: serializer.fromJson<bool>(json['isEaten']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'logDate': serializer.toJson<DateTime>(logDate),
      'drinkType': serializer.toJson<String>(drinkType),
      'units': serializer.toJson<double>(units),
      'calories': serializer.toJson<double>(calories),
      'volumeMl': serializer.toJson<double?>(volumeMl),
      'protein': serializer.toJson<double>(protein),
      'carbs': serializer.toJson<double>(carbs),
      'fat': serializer.toJson<double>(fat),
      'isEaten': serializer.toJson<bool>(isEaten),
    };
  }

  AlcoholLog copyWith({
    int? id,
    DateTime? logDate,
    String? drinkType,
    double? units,
    double? calories,
    Value<double?> volumeMl = const Value.absent(),
    double? protein,
    double? carbs,
    double? fat,
    bool? isEaten,
  }) => AlcoholLog(
    id: id ?? this.id,
    logDate: logDate ?? this.logDate,
    drinkType: drinkType ?? this.drinkType,
    units: units ?? this.units,
    calories: calories ?? this.calories,
    volumeMl: volumeMl.present ? volumeMl.value : this.volumeMl,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    isEaten: isEaten ?? this.isEaten,
  );
  AlcoholLog copyWithCompanion(AlcoholLogsCompanion data) {
    return AlcoholLog(
      id: data.id.present ? data.id.value : this.id,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      drinkType: data.drinkType.present ? data.drinkType.value : this.drinkType,
      units: data.units.present ? data.units.value : this.units,
      calories: data.calories.present ? data.calories.value : this.calories,
      volumeMl: data.volumeMl.present ? data.volumeMl.value : this.volumeMl,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
      isEaten: data.isEaten.present ? data.isEaten.value : this.isEaten,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlcoholLog(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('drinkType: $drinkType, ')
          ..write('units: $units, ')
          ..write('calories: $calories, ')
          ..write('volumeMl: $volumeMl, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('isEaten: $isEaten')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    logDate,
    drinkType,
    units,
    calories,
    volumeMl,
    protein,
    carbs,
    fat,
    isEaten,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlcoholLog &&
          other.id == this.id &&
          other.logDate == this.logDate &&
          other.drinkType == this.drinkType &&
          other.units == this.units &&
          other.calories == this.calories &&
          other.volumeMl == this.volumeMl &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat &&
          other.isEaten == this.isEaten);
}

class AlcoholLogsCompanion extends UpdateCompanion<AlcoholLog> {
  final Value<int> id;
  final Value<DateTime> logDate;
  final Value<String> drinkType;
  final Value<double> units;
  final Value<double> calories;
  final Value<double?> volumeMl;
  final Value<double> protein;
  final Value<double> carbs;
  final Value<double> fat;
  final Value<bool> isEaten;
  const AlcoholLogsCompanion({
    this.id = const Value.absent(),
    this.logDate = const Value.absent(),
    this.drinkType = const Value.absent(),
    this.units = const Value.absent(),
    this.calories = const Value.absent(),
    this.volumeMl = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.isEaten = const Value.absent(),
  });
  AlcoholLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime logDate,
    required String drinkType,
    required double units,
    required double calories,
    this.volumeMl = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.isEaten = const Value.absent(),
  }) : logDate = Value(logDate),
       drinkType = Value(drinkType),
       units = Value(units),
       calories = Value(calories);
  static Insertable<AlcoholLog> custom({
    Expression<int>? id,
    Expression<DateTime>? logDate,
    Expression<String>? drinkType,
    Expression<double>? units,
    Expression<double>? calories,
    Expression<double>? volumeMl,
    Expression<double>? protein,
    Expression<double>? carbs,
    Expression<double>? fat,
    Expression<bool>? isEaten,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logDate != null) 'log_date': logDate,
      if (drinkType != null) 'drink_type': drinkType,
      if (units != null) 'units': units,
      if (calories != null) 'calories': calories,
      if (volumeMl != null) 'volume_ml': volumeMl,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (isEaten != null) 'is_eaten': isEaten,
    });
  }

  AlcoholLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? logDate,
    Value<String>? drinkType,
    Value<double>? units,
    Value<double>? calories,
    Value<double?>? volumeMl,
    Value<double>? protein,
    Value<double>? carbs,
    Value<double>? fat,
    Value<bool>? isEaten,
  }) {
    return AlcoholLogsCompanion(
      id: id ?? this.id,
      logDate: logDate ?? this.logDate,
      drinkType: drinkType ?? this.drinkType,
      units: units ?? this.units,
      calories: calories ?? this.calories,
      volumeMl: volumeMl ?? this.volumeMl,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      isEaten: isEaten ?? this.isEaten,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (drinkType.present) {
      map['drink_type'] = Variable<String>(drinkType.value);
    }
    if (units.present) {
      map['units'] = Variable<double>(units.value);
    }
    if (calories.present) {
      map['calories'] = Variable<double>(calories.value);
    }
    if (volumeMl.present) {
      map['volume_ml'] = Variable<double>(volumeMl.value);
    }
    if (protein.present) {
      map['protein'] = Variable<double>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<double>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<double>(fat.value);
    }
    if (isEaten.present) {
      map['is_eaten'] = Variable<bool>(isEaten.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlcoholLogsCompanion(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('drinkType: $drinkType, ')
          ..write('units: $units, ')
          ..write('calories: $calories, ')
          ..write('volumeMl: $volumeMl, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('isEaten: $isEaten')
          ..write(')'))
        .toString();
  }
}

class $CaloriePlansTable extends CaloriePlans
    with TableInfo<$CaloriePlansTable, CaloriePlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaloriePlansTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<String> goalType = GeneratedColumn<String>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('maintain'),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDailyCaloriesMeta =
      const VerificationMeta('targetDailyCalories');
  @override
  late final GeneratedColumn<int> targetDailyCalories = GeneratedColumn<int>(
    'target_daily_calories',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetWeeklyDeficitMeta =
      const VerificationMeta('targetWeeklyDeficit');
  @override
  late final GeneratedColumn<int> targetWeeklyDeficit = GeneratedColumn<int>(
    'target_weekly_deficit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    goalType,
    startDate,
    endDate,
    targetDailyCalories,
    targetWeeklyDeficit,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calorie_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<CaloriePlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('target_daily_calories')) {
      context.handle(
        _targetDailyCaloriesMeta,
        targetDailyCalories.isAcceptableOrUnknown(
          data['target_daily_calories']!,
          _targetDailyCaloriesMeta,
        ),
      );
    }
    if (data.containsKey('target_weekly_deficit')) {
      context.handle(
        _targetWeeklyDeficitMeta,
        targetWeeklyDeficit.isAcceptableOrUnknown(
          data['target_weekly_deficit']!,
          _targetWeeklyDeficitMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CaloriePlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaloriePlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      goalType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_type'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      targetDailyCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_daily_calories'],
      ),
      targetWeeklyDeficit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_weekly_deficit'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CaloriePlansTable createAlias(String alias) {
    return $CaloriePlansTable(attachedDatabase, alias);
  }
}

class CaloriePlan extends DataClass implements Insertable<CaloriePlan> {
  final int id;
  final String name;
  final String goalType;
  final DateTime startDate;
  final DateTime endDate;
  final int? targetDailyCalories;
  final int? targetWeeklyDeficit;
  final bool isActive;
  final DateTime createdAt;
  const CaloriePlan({
    required this.id,
    required this.name,
    required this.goalType,
    required this.startDate,
    required this.endDate,
    this.targetDailyCalories,
    this.targetWeeklyDeficit,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['goal_type'] = Variable<String>(goalType);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    if (!nullToAbsent || targetDailyCalories != null) {
      map['target_daily_calories'] = Variable<int>(targetDailyCalories);
    }
    if (!nullToAbsent || targetWeeklyDeficit != null) {
      map['target_weekly_deficit'] = Variable<int>(targetWeeklyDeficit);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CaloriePlansCompanion toCompanion(bool nullToAbsent) {
    return CaloriePlansCompanion(
      id: Value(id),
      name: Value(name),
      goalType: Value(goalType),
      startDate: Value(startDate),
      endDate: Value(endDate),
      targetDailyCalories: targetDailyCalories == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDailyCalories),
      targetWeeklyDeficit: targetWeeklyDeficit == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWeeklyDeficit),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory CaloriePlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaloriePlan(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      goalType: serializer.fromJson<String>(json['goalType']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      targetDailyCalories: serializer.fromJson<int?>(
        json['targetDailyCalories'],
      ),
      targetWeeklyDeficit: serializer.fromJson<int?>(
        json['targetWeeklyDeficit'],
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'goalType': serializer.toJson<String>(goalType),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'targetDailyCalories': serializer.toJson<int?>(targetDailyCalories),
      'targetWeeklyDeficit': serializer.toJson<int?>(targetWeeklyDeficit),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CaloriePlan copyWith({
    int? id,
    String? name,
    String? goalType,
    DateTime? startDate,
    DateTime? endDate,
    Value<int?> targetDailyCalories = const Value.absent(),
    Value<int?> targetWeeklyDeficit = const Value.absent(),
    bool? isActive,
    DateTime? createdAt,
  }) => CaloriePlan(
    id: id ?? this.id,
    name: name ?? this.name,
    goalType: goalType ?? this.goalType,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    targetDailyCalories: targetDailyCalories.present
        ? targetDailyCalories.value
        : this.targetDailyCalories,
    targetWeeklyDeficit: targetWeeklyDeficit.present
        ? targetWeeklyDeficit.value
        : this.targetWeeklyDeficit,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  CaloriePlan copyWithCompanion(CaloriePlansCompanion data) {
    return CaloriePlan(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      targetDailyCalories: data.targetDailyCalories.present
          ? data.targetDailyCalories.value
          : this.targetDailyCalories,
      targetWeeklyDeficit: data.targetWeeklyDeficit.present
          ? data.targetWeeklyDeficit.value
          : this.targetWeeklyDeficit,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaloriePlan(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('goalType: $goalType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('targetDailyCalories: $targetDailyCalories, ')
          ..write('targetWeeklyDeficit: $targetWeeklyDeficit, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    goalType,
    startDate,
    endDate,
    targetDailyCalories,
    targetWeeklyDeficit,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaloriePlan &&
          other.id == this.id &&
          other.name == this.name &&
          other.goalType == this.goalType &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.targetDailyCalories == this.targetDailyCalories &&
          other.targetWeeklyDeficit == this.targetWeeklyDeficit &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class CaloriePlansCompanion extends UpdateCompanion<CaloriePlan> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> goalType;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int?> targetDailyCalories;
  final Value<int?> targetWeeklyDeficit;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const CaloriePlansCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.goalType = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.targetDailyCalories = const Value.absent(),
    this.targetWeeklyDeficit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CaloriePlansCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.goalType = const Value.absent(),
    required DateTime startDate,
    required DateTime endDate,
    this.targetDailyCalories = const Value.absent(),
    this.targetWeeklyDeficit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       startDate = Value(startDate),
       endDate = Value(endDate);
  static Insertable<CaloriePlan> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? goalType,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? targetDailyCalories,
    Expression<int>? targetWeeklyDeficit,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (goalType != null) 'goal_type': goalType,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (targetDailyCalories != null)
        'target_daily_calories': targetDailyCalories,
      if (targetWeeklyDeficit != null)
        'target_weekly_deficit': targetWeeklyDeficit,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CaloriePlansCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? goalType,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int?>? targetDailyCalories,
    Value<int?>? targetWeeklyDeficit,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return CaloriePlansCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      goalType: goalType ?? this.goalType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      targetDailyCalories: targetDailyCalories ?? this.targetDailyCalories,
      targetWeeklyDeficit: targetWeeklyDeficit ?? this.targetWeeklyDeficit,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<String>(goalType.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (targetDailyCalories.present) {
      map['target_daily_calories'] = Variable<int>(targetDailyCalories.value);
    }
    if (targetWeeklyDeficit.present) {
      map['target_weekly_deficit'] = Variable<int>(targetWeeklyDeficit.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaloriePlansCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('goalType: $goalType, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('targetDailyCalories: $targetDailyCalories, ')
          ..write('targetWeeklyDeficit: $targetWeeklyDeficit, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CaloriePlanWeeksTable extends CaloriePlanWeeks
    with TableInfo<$CaloriePlanWeeksTable, CaloriePlanWeek> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CaloriePlanWeeksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calorie_plans (id)',
    ),
  );
  static const VerificationMeta _weekNumberMeta = const VerificationMeta(
    'weekNumber',
  );
  @override
  late final GeneratedColumn<int> weekNumber = GeneratedColumn<int>(
    'week_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekStartDateMeta = const VerificationMeta(
    'weekStartDate',
  );
  @override
  late final GeneratedColumn<DateTime> weekStartDate =
      GeneratedColumn<DateTime>(
        'week_start_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _weekEndDateMeta = const VerificationMeta(
    'weekEndDate',
  );
  @override
  late final GeneratedColumn<DateTime> weekEndDate = GeneratedColumn<DateTime>(
    'week_end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDailyCaloriesMeta =
      const VerificationMeta('targetDailyCalories');
  @override
  late final GeneratedColumn<int> targetDailyCalories = GeneratedColumn<int>(
    'target_daily_calories',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetWeeklyDeficitMeta =
      const VerificationMeta('targetWeeklyDeficit');
  @override
  late final GeneratedColumn<int> targetWeeklyDeficit = GeneratedColumn<int>(
    'target_weekly_deficit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planId,
    weekNumber,
    weekStartDate,
    weekEndDate,
    targetDailyCalories,
    targetWeeklyDeficit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calorie_plan_weeks';
  @override
  VerificationContext validateIntegrity(
    Insertable<CaloriePlanWeek> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('week_number')) {
      context.handle(
        _weekNumberMeta,
        weekNumber.isAcceptableOrUnknown(data['week_number']!, _weekNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_weekNumberMeta);
    }
    if (data.containsKey('week_start_date')) {
      context.handle(
        _weekStartDateMeta,
        weekStartDate.isAcceptableOrUnknown(
          data['week_start_date']!,
          _weekStartDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weekStartDateMeta);
    }
    if (data.containsKey('week_end_date')) {
      context.handle(
        _weekEndDateMeta,
        weekEndDate.isAcceptableOrUnknown(
          data['week_end_date']!,
          _weekEndDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weekEndDateMeta);
    }
    if (data.containsKey('target_daily_calories')) {
      context.handle(
        _targetDailyCaloriesMeta,
        targetDailyCalories.isAcceptableOrUnknown(
          data['target_daily_calories']!,
          _targetDailyCaloriesMeta,
        ),
      );
    }
    if (data.containsKey('target_weekly_deficit')) {
      context.handle(
        _targetWeeklyDeficitMeta,
        targetWeeklyDeficit.isAcceptableOrUnknown(
          data['target_weekly_deficit']!,
          _targetWeeklyDeficitMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {planId, weekNumber},
  ];
  @override
  CaloriePlanWeek map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CaloriePlanWeek(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      planId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}plan_id'],
      )!,
      weekNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_number'],
      )!,
      weekStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}week_start_date'],
      )!,
      weekEndDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}week_end_date'],
      )!,
      targetDailyCalories: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_daily_calories'],
      ),
      targetWeeklyDeficit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_weekly_deficit'],
      ),
    );
  }

  @override
  $CaloriePlanWeeksTable createAlias(String alias) {
    return $CaloriePlanWeeksTable(attachedDatabase, alias);
  }
}

class CaloriePlanWeek extends DataClass implements Insertable<CaloriePlanWeek> {
  final int id;
  final int planId;
  final int weekNumber;
  final DateTime weekStartDate;
  final DateTime weekEndDate;
  final int? targetDailyCalories;
  final int? targetWeeklyDeficit;
  const CaloriePlanWeek({
    required this.id,
    required this.planId,
    required this.weekNumber,
    required this.weekStartDate,
    required this.weekEndDate,
    this.targetDailyCalories,
    this.targetWeeklyDeficit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    map['week_number'] = Variable<int>(weekNumber);
    map['week_start_date'] = Variable<DateTime>(weekStartDate);
    map['week_end_date'] = Variable<DateTime>(weekEndDate);
    if (!nullToAbsent || targetDailyCalories != null) {
      map['target_daily_calories'] = Variable<int>(targetDailyCalories);
    }
    if (!nullToAbsent || targetWeeklyDeficit != null) {
      map['target_weekly_deficit'] = Variable<int>(targetWeeklyDeficit);
    }
    return map;
  }

  CaloriePlanWeeksCompanion toCompanion(bool nullToAbsent) {
    return CaloriePlanWeeksCompanion(
      id: Value(id),
      planId: Value(planId),
      weekNumber: Value(weekNumber),
      weekStartDate: Value(weekStartDate),
      weekEndDate: Value(weekEndDate),
      targetDailyCalories: targetDailyCalories == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDailyCalories),
      targetWeeklyDeficit: targetWeeklyDeficit == null && nullToAbsent
          ? const Value.absent()
          : Value(targetWeeklyDeficit),
    );
  }

  factory CaloriePlanWeek.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CaloriePlanWeek(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      weekNumber: serializer.fromJson<int>(json['weekNumber']),
      weekStartDate: serializer.fromJson<DateTime>(json['weekStartDate']),
      weekEndDate: serializer.fromJson<DateTime>(json['weekEndDate']),
      targetDailyCalories: serializer.fromJson<int?>(
        json['targetDailyCalories'],
      ),
      targetWeeklyDeficit: serializer.fromJson<int?>(
        json['targetWeeklyDeficit'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'weekNumber': serializer.toJson<int>(weekNumber),
      'weekStartDate': serializer.toJson<DateTime>(weekStartDate),
      'weekEndDate': serializer.toJson<DateTime>(weekEndDate),
      'targetDailyCalories': serializer.toJson<int?>(targetDailyCalories),
      'targetWeeklyDeficit': serializer.toJson<int?>(targetWeeklyDeficit),
    };
  }

  CaloriePlanWeek copyWith({
    int? id,
    int? planId,
    int? weekNumber,
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    Value<int?> targetDailyCalories = const Value.absent(),
    Value<int?> targetWeeklyDeficit = const Value.absent(),
  }) => CaloriePlanWeek(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    weekNumber: weekNumber ?? this.weekNumber,
    weekStartDate: weekStartDate ?? this.weekStartDate,
    weekEndDate: weekEndDate ?? this.weekEndDate,
    targetDailyCalories: targetDailyCalories.present
        ? targetDailyCalories.value
        : this.targetDailyCalories,
    targetWeeklyDeficit: targetWeeklyDeficit.present
        ? targetWeeklyDeficit.value
        : this.targetWeeklyDeficit,
  );
  CaloriePlanWeek copyWithCompanion(CaloriePlanWeeksCompanion data) {
    return CaloriePlanWeek(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      weekNumber: data.weekNumber.present
          ? data.weekNumber.value
          : this.weekNumber,
      weekStartDate: data.weekStartDate.present
          ? data.weekStartDate.value
          : this.weekStartDate,
      weekEndDate: data.weekEndDate.present
          ? data.weekEndDate.value
          : this.weekEndDate,
      targetDailyCalories: data.targetDailyCalories.present
          ? data.targetDailyCalories.value
          : this.targetDailyCalories,
      targetWeeklyDeficit: data.targetWeeklyDeficit.present
          ? data.targetWeeklyDeficit.value
          : this.targetWeeklyDeficit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CaloriePlanWeek(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('weekStartDate: $weekStartDate, ')
          ..write('weekEndDate: $weekEndDate, ')
          ..write('targetDailyCalories: $targetDailyCalories, ')
          ..write('targetWeeklyDeficit: $targetWeeklyDeficit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    planId,
    weekNumber,
    weekStartDate,
    weekEndDate,
    targetDailyCalories,
    targetWeeklyDeficit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CaloriePlanWeek &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.weekNumber == this.weekNumber &&
          other.weekStartDate == this.weekStartDate &&
          other.weekEndDate == this.weekEndDate &&
          other.targetDailyCalories == this.targetDailyCalories &&
          other.targetWeeklyDeficit == this.targetWeeklyDeficit);
}

class CaloriePlanWeeksCompanion extends UpdateCompanion<CaloriePlanWeek> {
  final Value<int> id;
  final Value<int> planId;
  final Value<int> weekNumber;
  final Value<DateTime> weekStartDate;
  final Value<DateTime> weekEndDate;
  final Value<int?> targetDailyCalories;
  final Value<int?> targetWeeklyDeficit;
  const CaloriePlanWeeksCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.weekNumber = const Value.absent(),
    this.weekStartDate = const Value.absent(),
    this.weekEndDate = const Value.absent(),
    this.targetDailyCalories = const Value.absent(),
    this.targetWeeklyDeficit = const Value.absent(),
  });
  CaloriePlanWeeksCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    required int weekNumber,
    required DateTime weekStartDate,
    required DateTime weekEndDate,
    this.targetDailyCalories = const Value.absent(),
    this.targetWeeklyDeficit = const Value.absent(),
  }) : planId = Value(planId),
       weekNumber = Value(weekNumber),
       weekStartDate = Value(weekStartDate),
       weekEndDate = Value(weekEndDate);
  static Insertable<CaloriePlanWeek> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<int>? weekNumber,
    Expression<DateTime>? weekStartDate,
    Expression<DateTime>? weekEndDate,
    Expression<int>? targetDailyCalories,
    Expression<int>? targetWeeklyDeficit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (weekNumber != null) 'week_number': weekNumber,
      if (weekStartDate != null) 'week_start_date': weekStartDate,
      if (weekEndDate != null) 'week_end_date': weekEndDate,
      if (targetDailyCalories != null)
        'target_daily_calories': targetDailyCalories,
      if (targetWeeklyDeficit != null)
        'target_weekly_deficit': targetWeeklyDeficit,
    });
  }

  CaloriePlanWeeksCompanion copyWith({
    Value<int>? id,
    Value<int>? planId,
    Value<int>? weekNumber,
    Value<DateTime>? weekStartDate,
    Value<DateTime>? weekEndDate,
    Value<int?>? targetDailyCalories,
    Value<int?>? targetWeeklyDeficit,
  }) {
    return CaloriePlanWeeksCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      weekNumber: weekNumber ?? this.weekNumber,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      weekEndDate: weekEndDate ?? this.weekEndDate,
      targetDailyCalories: targetDailyCalories ?? this.targetDailyCalories,
      targetWeeklyDeficit: targetWeeklyDeficit ?? this.targetWeeklyDeficit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (weekNumber.present) {
      map['week_number'] = Variable<int>(weekNumber.value);
    }
    if (weekStartDate.present) {
      map['week_start_date'] = Variable<DateTime>(weekStartDate.value);
    }
    if (weekEndDate.present) {
      map['week_end_date'] = Variable<DateTime>(weekEndDate.value);
    }
    if (targetDailyCalories.present) {
      map['target_daily_calories'] = Variable<int>(targetDailyCalories.value);
    }
    if (targetWeeklyDeficit.present) {
      map['target_weekly_deficit'] = Variable<int>(targetWeeklyDeficit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CaloriePlanWeeksCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('weekStartDate: $weekStartDate, ')
          ..write('weekEndDate: $weekEndDate, ')
          ..write('targetDailyCalories: $targetDailyCalories, ')
          ..write('targetWeeklyDeficit: $targetWeeklyDeficit')
          ..write(')'))
        .toString();
  }
}

class $DailyEnergyLogsTable extends DailyEnergyLogs
    with TableInfo<$DailyEnergyLogsTable, DailyEnergyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyEnergyLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<int> steps = GeneratedColumn<int>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _caloriesOutMeta = const VerificationMeta(
    'caloriesOut',
  );
  @override
  late final GeneratedColumn<double> caloriesOut = GeneratedColumn<double>(
    'calories_out',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    logDate,
    steps,
    caloriesOut,
    source,
    notes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_energy_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyEnergyLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('calories_out')) {
      context.handle(
        _caloriesOutMeta,
        caloriesOut.isAcceptableOrUnknown(
          data['calories_out']!,
          _caloriesOutMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesOutMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {logDate},
  ];
  @override
  DailyEnergyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyEnergyLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}steps'],
      )!,
      caloriesOut: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}calories_out'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyEnergyLogsTable createAlias(String alias) {
    return $DailyEnergyLogsTable(attachedDatabase, alias);
  }
}

class DailyEnergyLog extends DataClass implements Insertable<DailyEnergyLog> {
  final int id;
  final DateTime logDate;
  final int steps;
  final double caloriesOut;
  final String source;
  final String? notes;
  final DateTime updatedAt;
  const DailyEnergyLog({
    required this.id,
    required this.logDate,
    required this.steps,
    required this.caloriesOut,
    required this.source,
    this.notes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['log_date'] = Variable<DateTime>(logDate);
    map['steps'] = Variable<int>(steps);
    map['calories_out'] = Variable<double>(caloriesOut);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DailyEnergyLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyEnergyLogsCompanion(
      id: Value(id),
      logDate: Value(logDate),
      steps: Value(steps),
      caloriesOut: Value(caloriesOut),
      source: Value(source),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyEnergyLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyEnergyLog(
      id: serializer.fromJson<int>(json['id']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      steps: serializer.fromJson<int>(json['steps']),
      caloriesOut: serializer.fromJson<double>(json['caloriesOut']),
      source: serializer.fromJson<String>(json['source']),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'logDate': serializer.toJson<DateTime>(logDate),
      'steps': serializer.toJson<int>(steps),
      'caloriesOut': serializer.toJson<double>(caloriesOut),
      'source': serializer.toJson<String>(source),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DailyEnergyLog copyWith({
    int? id,
    DateTime? logDate,
    int? steps,
    double? caloriesOut,
    String? source,
    Value<String?> notes = const Value.absent(),
    DateTime? updatedAt,
  }) => DailyEnergyLog(
    id: id ?? this.id,
    logDate: logDate ?? this.logDate,
    steps: steps ?? this.steps,
    caloriesOut: caloriesOut ?? this.caloriesOut,
    source: source ?? this.source,
    notes: notes.present ? notes.value : this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyEnergyLog copyWithCompanion(DailyEnergyLogsCompanion data) {
    return DailyEnergyLog(
      id: data.id.present ? data.id.value : this.id,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      steps: data.steps.present ? data.steps.value : this.steps,
      caloriesOut: data.caloriesOut.present
          ? data.caloriesOut.value
          : this.caloriesOut,
      source: data.source.present ? data.source.value : this.source,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyEnergyLog(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('steps: $steps, ')
          ..write('caloriesOut: $caloriesOut, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, logDate, steps, caloriesOut, source, notes, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyEnergyLog &&
          other.id == this.id &&
          other.logDate == this.logDate &&
          other.steps == this.steps &&
          other.caloriesOut == this.caloriesOut &&
          other.source == this.source &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt);
}

class DailyEnergyLogsCompanion extends UpdateCompanion<DailyEnergyLog> {
  final Value<int> id;
  final Value<DateTime> logDate;
  final Value<int> steps;
  final Value<double> caloriesOut;
  final Value<String> source;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  const DailyEnergyLogsCompanion({
    this.id = const Value.absent(),
    this.logDate = const Value.absent(),
    this.steps = const Value.absent(),
    this.caloriesOut = const Value.absent(),
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DailyEnergyLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime logDate,
    this.steps = const Value.absent(),
    required double caloriesOut,
    this.source = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : logDate = Value(logDate),
       caloriesOut = Value(caloriesOut);
  static Insertable<DailyEnergyLog> custom({
    Expression<int>? id,
    Expression<DateTime>? logDate,
    Expression<int>? steps,
    Expression<double>? caloriesOut,
    Expression<String>? source,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logDate != null) 'log_date': logDate,
      if (steps != null) 'steps': steps,
      if (caloriesOut != null) 'calories_out': caloriesOut,
      if (source != null) 'source': source,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DailyEnergyLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? logDate,
    Value<int>? steps,
    Value<double>? caloriesOut,
    Value<String>? source,
    Value<String?>? notes,
    Value<DateTime>? updatedAt,
  }) {
    return DailyEnergyLogsCompanion(
      id: id ?? this.id,
      logDate: logDate ?? this.logDate,
      steps: steps ?? this.steps,
      caloriesOut: caloriesOut ?? this.caloriesOut,
      source: source ?? this.source,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (steps.present) {
      map['steps'] = Variable<int>(steps.value);
    }
    if (caloriesOut.present) {
      map['calories_out'] = Variable<double>(caloriesOut.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyEnergyLogsCompanion(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('steps: $steps, ')
          ..write('caloriesOut: $caloriesOut, ')
          ..write('source: $source, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BmrProfilesTable extends BmrProfiles
    with TableInfo<$BmrProfilesTable, BmrProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BmrProfilesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _bmrMeta = const VerificationMeta('bmr');
  @override
  late final GeneratedColumn<double> bmr = GeneratedColumn<double>(
    'bmr',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
  @override
  List<GeneratedColumn> get $columns => [id, bmr, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bmr_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BmrProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bmr')) {
      context.handle(
        _bmrMeta,
        bmr.isAcceptableOrUnknown(data['bmr']!, _bmrMeta),
      );
    } else if (isInserting) {
      context.missing(_bmrMeta);
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
  BmrProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BmrProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bmr: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}bmr'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BmrProfilesTable createAlias(String alias) {
    return $BmrProfilesTable(attachedDatabase, alias);
  }
}

class BmrProfile extends DataClass implements Insertable<BmrProfile> {
  final int id;
  final double bmr;
  final DateTime updatedAt;
  const BmrProfile({
    required this.id,
    required this.bmr,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bmr'] = Variable<double>(bmr);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BmrProfilesCompanion toCompanion(bool nullToAbsent) {
    return BmrProfilesCompanion(
      id: Value(id),
      bmr: Value(bmr),
      updatedAt: Value(updatedAt),
    );
  }

  factory BmrProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BmrProfile(
      id: serializer.fromJson<int>(json['id']),
      bmr: serializer.fromJson<double>(json['bmr']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bmr': serializer.toJson<double>(bmr),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BmrProfile copyWith({int? id, double? bmr, DateTime? updatedAt}) =>
      BmrProfile(
        id: id ?? this.id,
        bmr: bmr ?? this.bmr,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BmrProfile copyWithCompanion(BmrProfilesCompanion data) {
    return BmrProfile(
      id: data.id.present ? data.id.value : this.id,
      bmr: data.bmr.present ? data.bmr.value : this.bmr,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BmrProfile(')
          ..write('id: $id, ')
          ..write('bmr: $bmr, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bmr, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BmrProfile &&
          other.id == this.id &&
          other.bmr == this.bmr &&
          other.updatedAt == this.updatedAt);
}

class BmrProfilesCompanion extends UpdateCompanion<BmrProfile> {
  final Value<int> id;
  final Value<double> bmr;
  final Value<DateTime> updatedAt;
  const BmrProfilesCompanion({
    this.id = const Value.absent(),
    this.bmr = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BmrProfilesCompanion.insert({
    this.id = const Value.absent(),
    required double bmr,
    this.updatedAt = const Value.absent(),
  }) : bmr = Value(bmr);
  static Insertable<BmrProfile> custom({
    Expression<int>? id,
    Expression<double>? bmr,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bmr != null) 'bmr': bmr,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BmrProfilesCompanion copyWith({
    Value<int>? id,
    Value<double>? bmr,
    Value<DateTime>? updatedAt,
  }) {
    return BmrProfilesCompanion(
      id: id ?? this.id,
      bmr: bmr ?? this.bmr,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bmr.present) {
      map['bmr'] = Variable<double>(bmr.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BmrProfilesCompanion(')
          ..write('id: $id, ')
          ..write('bmr: $bmr, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $WeightLogsTable extends WeightLogs
    with TableInfo<$WeightLogsTable, WeightLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, logDate, weightKg, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WeightLogsTable createAlias(String alias) {
    return $WeightLogsTable(attachedDatabase, alias);
  }
}

class WeightLog extends DataClass implements Insertable<WeightLog> {
  final int id;
  final DateTime logDate;
  final double weightKg;
  final String? notes;
  const WeightLog({
    required this.id,
    required this.logDate,
    required this.weightKg,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['log_date'] = Variable<DateTime>(logDate);
    map['weight_kg'] = Variable<double>(weightKg);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WeightLogsCompanion toCompanion(bool nullToAbsent) {
    return WeightLogsCompanion(
      id: Value(id),
      logDate: Value(logDate),
      weightKg: Value(weightKg),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory WeightLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightLog(
      id: serializer.fromJson<int>(json['id']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'logDate': serializer.toJson<DateTime>(logDate),
      'weightKg': serializer.toJson<double>(weightKg),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WeightLog copyWith({
    int? id,
    DateTime? logDate,
    double? weightKg,
    Value<String?> notes = const Value.absent(),
  }) => WeightLog(
    id: id ?? this.id,
    logDate: logDate ?? this.logDate,
    weightKg: weightKg ?? this.weightKg,
    notes: notes.present ? notes.value : this.notes,
  );
  WeightLog copyWithCompanion(WeightLogsCompanion data) {
    return WeightLog(
      id: data.id.present ? data.id.value : this.id,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightLog(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('weightKg: $weightKg, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, logDate, weightKg, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightLog &&
          other.id == this.id &&
          other.logDate == this.logDate &&
          other.weightKg == this.weightKg &&
          other.notes == this.notes);
}

class WeightLogsCompanion extends UpdateCompanion<WeightLog> {
  final Value<int> id;
  final Value<DateTime> logDate;
  final Value<double> weightKg;
  final Value<String?> notes;
  const WeightLogsCompanion({
    this.id = const Value.absent(),
    this.logDate = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WeightLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime logDate,
    required double weightKg,
    this.notes = const Value.absent(),
  }) : logDate = Value(logDate),
       weightKg = Value(weightKg);
  static Insertable<WeightLog> custom({
    Expression<int>? id,
    Expression<DateTime>? logDate,
    Expression<double>? weightKg,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logDate != null) 'log_date': logDate,
      if (weightKg != null) 'weight_kg': weightKg,
      if (notes != null) 'notes': notes,
    });
  }

  WeightLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? logDate,
    Value<double>? weightKg,
    Value<String?>? notes,
  }) {
    return WeightLogsCompanion(
      id: id ?? this.id,
      logDate: logDate ?? this.logDate,
      weightKg: weightKg ?? this.weightKg,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightLogsCompanion(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('weightKg: $weightKg, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $BodyFatLogsTable extends BodyFatLogs
    with TableInfo<$BodyFatLogsTable, BodyFatLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyFatLogsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyFatPercentMeta = const VerificationMeta(
    'bodyFatPercent',
  );
  @override
  late final GeneratedColumn<double> bodyFatPercent = GeneratedColumn<double>(
    'body_fat_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('estimate'),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    logDate,
    bodyFatPercent,
    method,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_fat_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<BodyFatLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('body_fat_percent')) {
      context.handle(
        _bodyFatPercentMeta,
        bodyFatPercent.isAcceptableOrUnknown(
          data['body_fat_percent']!,
          _bodyFatPercentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bodyFatPercentMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyFatLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyFatLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      bodyFatPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_fat_percent'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $BodyFatLogsTable createAlias(String alias) {
    return $BodyFatLogsTable(attachedDatabase, alias);
  }
}

class BodyFatLog extends DataClass implements Insertable<BodyFatLog> {
  final int id;
  final DateTime logDate;
  final double bodyFatPercent;
  final String method;
  final String? notes;
  const BodyFatLog({
    required this.id,
    required this.logDate,
    required this.bodyFatPercent,
    required this.method,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['log_date'] = Variable<DateTime>(logDate);
    map['body_fat_percent'] = Variable<double>(bodyFatPercent);
    map['method'] = Variable<String>(method);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  BodyFatLogsCompanion toCompanion(bool nullToAbsent) {
    return BodyFatLogsCompanion(
      id: Value(id),
      logDate: Value(logDate),
      bodyFatPercent: Value(bodyFatPercent),
      method: Value(method),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory BodyFatLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyFatLog(
      id: serializer.fromJson<int>(json['id']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      bodyFatPercent: serializer.fromJson<double>(json['bodyFatPercent']),
      method: serializer.fromJson<String>(json['method']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'logDate': serializer.toJson<DateTime>(logDate),
      'bodyFatPercent': serializer.toJson<double>(bodyFatPercent),
      'method': serializer.toJson<String>(method),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  BodyFatLog copyWith({
    int? id,
    DateTime? logDate,
    double? bodyFatPercent,
    String? method,
    Value<String?> notes = const Value.absent(),
  }) => BodyFatLog(
    id: id ?? this.id,
    logDate: logDate ?? this.logDate,
    bodyFatPercent: bodyFatPercent ?? this.bodyFatPercent,
    method: method ?? this.method,
    notes: notes.present ? notes.value : this.notes,
  );
  BodyFatLog copyWithCompanion(BodyFatLogsCompanion data) {
    return BodyFatLog(
      id: data.id.present ? data.id.value : this.id,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      bodyFatPercent: data.bodyFatPercent.present
          ? data.bodyFatPercent.value
          : this.bodyFatPercent,
      method: data.method.present ? data.method.value : this.method,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyFatLog(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('bodyFatPercent: $bodyFatPercent, ')
          ..write('method: $method, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, logDate, bodyFatPercent, method, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyFatLog &&
          other.id == this.id &&
          other.logDate == this.logDate &&
          other.bodyFatPercent == this.bodyFatPercent &&
          other.method == this.method &&
          other.notes == this.notes);
}

class BodyFatLogsCompanion extends UpdateCompanion<BodyFatLog> {
  final Value<int> id;
  final Value<DateTime> logDate;
  final Value<double> bodyFatPercent;
  final Value<String> method;
  final Value<String?> notes;
  const BodyFatLogsCompanion({
    this.id = const Value.absent(),
    this.logDate = const Value.absent(),
    this.bodyFatPercent = const Value.absent(),
    this.method = const Value.absent(),
    this.notes = const Value.absent(),
  });
  BodyFatLogsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime logDate,
    required double bodyFatPercent,
    this.method = const Value.absent(),
    this.notes = const Value.absent(),
  }) : logDate = Value(logDate),
       bodyFatPercent = Value(bodyFatPercent);
  static Insertable<BodyFatLog> custom({
    Expression<int>? id,
    Expression<DateTime>? logDate,
    Expression<double>? bodyFatPercent,
    Expression<String>? method,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logDate != null) 'log_date': logDate,
      if (bodyFatPercent != null) 'body_fat_percent': bodyFatPercent,
      if (method != null) 'method': method,
      if (notes != null) 'notes': notes,
    });
  }

  BodyFatLogsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? logDate,
    Value<double>? bodyFatPercent,
    Value<String>? method,
    Value<String?>? notes,
  }) {
    return BodyFatLogsCompanion(
      id: id ?? this.id,
      logDate: logDate ?? this.logDate,
      bodyFatPercent: bodyFatPercent ?? this.bodyFatPercent,
      method: method ?? this.method,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (bodyFatPercent.present) {
      map['body_fat_percent'] = Variable<double>(bodyFatPercent.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyFatLogsCompanion(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('bodyFatPercent: $bodyFatPercent, ')
          ..write('method: $method, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoriesTable extends ExpenseCategories
    with TableInfo<$ExpenseCategoriesTable, ExpenseCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isFoodRelatedMeta = const VerificationMeta(
    'isFoodRelated',
  );
  @override
  late final GeneratedColumn<bool> isFoodRelated = GeneratedColumn<bool>(
    'is_food_related',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_food_related" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, color, isFoodRelated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('is_food_related')) {
      context.handle(
        _isFoodRelatedMeta,
        isFoodRelated.isAcceptableOrUnknown(
          data['is_food_related']!,
          _isFoodRelatedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      isFoodRelated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_food_related'],
      )!,
    );
  }

  @override
  $ExpenseCategoriesTable createAlias(String alias) {
    return $ExpenseCategoriesTable(attachedDatabase, alias);
  }
}

class ExpenseCategory extends DataClass implements Insertable<ExpenseCategory> {
  final int id;
  final String name;
  final String icon;
  final String? color;
  final bool isFoodRelated;
  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.color,
    required this.isFoodRelated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    map['is_food_related'] = Variable<bool>(isFoodRelated);
    return map;
  }

  ExpenseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      isFoodRelated: Value(isFoodRelated),
    );
  }

  factory ExpenseCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<String?>(json['color']),
      isFoodRelated: serializer.fromJson<bool>(json['isFoodRelated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<String?>(color),
      'isFoodRelated': serializer.toJson<bool>(isFoodRelated),
    };
  }

  ExpenseCategory copyWith({
    int? id,
    String? name,
    String? icon,
    Value<String?> color = const Value.absent(),
    bool? isFoodRelated,
  }) => ExpenseCategory(
    id: id ?? this.id,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    color: color.present ? color.value : this.color,
    isFoodRelated: isFoodRelated ?? this.isFoodRelated,
  );
  ExpenseCategory copyWithCompanion(ExpenseCategoriesCompanion data) {
    return ExpenseCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      isFoodRelated: data.isFoodRelated.present
          ? data.isFoodRelated.value
          : this.isFoodRelated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isFoodRelated: $isFoodRelated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, color, isFoodRelated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.isFoodRelated == this.isFoodRelated);
}

class ExpenseCategoriesCompanion extends UpdateCompanion<ExpenseCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<String?> color;
  final Value<bool> isFoodRelated;
  const ExpenseCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isFoodRelated = const Value.absent(),
  });
  ExpenseCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String icon,
    this.color = const Value.absent(),
    this.isFoodRelated = const Value.absent(),
  }) : name = Value(name),
       icon = Value(icon);
  static Insertable<ExpenseCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<bool>? isFoodRelated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (isFoodRelated != null) 'is_food_related': isFoodRelated,
    });
  }

  ExpenseCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? icon,
    Value<String?>? color,
    Value<bool>? isFoodRelated,
  }) {
    return ExpenseCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isFoodRelated: isFoodRelated ?? this.isFoodRelated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (isFoodRelated.present) {
      map['is_food_related'] = Variable<bool>(isFoodRelated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isFoodRelated: $isFoodRelated')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _logDateMeta = const VerificationMeta(
    'logDate',
  );
  @override
  late final GeneratedColumn<DateTime> logDate = GeneratedColumn<DateTime>(
    'log_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES expense_categories (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
  static const VerificationMeta _linkedFoodLogIdMeta = const VerificationMeta(
    'linkedFoodLogId',
  );
  @override
  late final GeneratedColumn<int> linkedFoodLogId = GeneratedColumn<int>(
    'linked_food_log_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES food_logs (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    logDate,
    categoryId,
    amount,
    description,
    linkedFoodLogId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('log_date')) {
      context.handle(
        _logDateMeta,
        logDate.isAcceptableOrUnknown(data['log_date']!, _logDateMeta),
      );
    } else if (isInserting) {
      context.missing(_logDateMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
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
    if (data.containsKey('linked_food_log_id')) {
      context.handle(
        _linkedFoodLogIdMeta,
        linkedFoodLogId.isAcceptableOrUnknown(
          data['linked_food_log_id']!,
          _linkedFoodLogIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      logDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}log_date'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      linkedFoodLogId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}linked_food_log_id'],
      ),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final DateTime logDate;
  final int categoryId;
  final double amount;
  final String? description;
  final int? linkedFoodLogId;
  const Expense({
    required this.id,
    required this.logDate,
    required this.categoryId,
    required this.amount,
    this.description,
    this.linkedFoodLogId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['log_date'] = Variable<DateTime>(logDate);
    map['category_id'] = Variable<int>(categoryId);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || linkedFoodLogId != null) {
      map['linked_food_log_id'] = Variable<int>(linkedFoodLogId);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      logDate: Value(logDate),
      categoryId: Value(categoryId),
      amount: Value(amount),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      linkedFoodLogId: linkedFoodLogId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedFoodLogId),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      logDate: serializer.fromJson<DateTime>(json['logDate']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      amount: serializer.fromJson<double>(json['amount']),
      description: serializer.fromJson<String?>(json['description']),
      linkedFoodLogId: serializer.fromJson<int?>(json['linkedFoodLogId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'logDate': serializer.toJson<DateTime>(logDate),
      'categoryId': serializer.toJson<int>(categoryId),
      'amount': serializer.toJson<double>(amount),
      'description': serializer.toJson<String?>(description),
      'linkedFoodLogId': serializer.toJson<int?>(linkedFoodLogId),
    };
  }

  Expense copyWith({
    int? id,
    DateTime? logDate,
    int? categoryId,
    double? amount,
    Value<String?> description = const Value.absent(),
    Value<int?> linkedFoodLogId = const Value.absent(),
  }) => Expense(
    id: id ?? this.id,
    logDate: logDate ?? this.logDate,
    categoryId: categoryId ?? this.categoryId,
    amount: amount ?? this.amount,
    description: description.present ? description.value : this.description,
    linkedFoodLogId: linkedFoodLogId.present
        ? linkedFoodLogId.value
        : this.linkedFoodLogId,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      logDate: data.logDate.present ? data.logDate.value : this.logDate,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      amount: data.amount.present ? data.amount.value : this.amount,
      description: data.description.present
          ? data.description.value
          : this.description,
      linkedFoodLogId: data.linkedFoodLogId.present
          ? data.linkedFoodLogId.value
          : this.linkedFoodLogId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('linkedFoodLogId: $linkedFoodLogId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    logDate,
    categoryId,
    amount,
    description,
    linkedFoodLogId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.logDate == this.logDate &&
          other.categoryId == this.categoryId &&
          other.amount == this.amount &&
          other.description == this.description &&
          other.linkedFoodLogId == this.linkedFoodLogId);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<DateTime> logDate;
  final Value<int> categoryId;
  final Value<double> amount;
  final Value<String?> description;
  final Value<int?> linkedFoodLogId;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.logDate = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.amount = const Value.absent(),
    this.description = const Value.absent(),
    this.linkedFoodLogId = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime logDate,
    required int categoryId,
    required double amount,
    this.description = const Value.absent(),
    this.linkedFoodLogId = const Value.absent(),
  }) : logDate = Value(logDate),
       categoryId = Value(categoryId),
       amount = Value(amount);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<DateTime>? logDate,
    Expression<int>? categoryId,
    Expression<double>? amount,
    Expression<String>? description,
    Expression<int>? linkedFoodLogId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logDate != null) 'log_date': logDate,
      if (categoryId != null) 'category_id': categoryId,
      if (amount != null) 'amount': amount,
      if (description != null) 'description': description,
      if (linkedFoodLogId != null) 'linked_food_log_id': linkedFoodLogId,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? logDate,
    Value<int>? categoryId,
    Value<double>? amount,
    Value<String?>? description,
    Value<int?>? linkedFoodLogId,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      logDate: logDate ?? this.logDate,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      linkedFoodLogId: linkedFoodLogId ?? this.linkedFoodLogId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (logDate.present) {
      map['log_date'] = Variable<DateTime>(logDate.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (linkedFoodLogId.present) {
      map['linked_food_log_id'] = Variable<int>(linkedFoodLogId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('logDate: $logDate, ')
          ..write('categoryId: $categoryId, ')
          ..write('amount: $amount, ')
          ..write('description: $description, ')
          ..write('linkedFoodLogId: $linkedFoodLogId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $ExerciseLogsTable exerciseLogs = $ExerciseLogsTable(this);
  late final $FoodsTable foods = $FoodsTable(this);
  late final $FoodLogsTable foodLogs = $FoodLogsTable(this);
  late final $SupplementsTable supplements = $SupplementsTable(this);
  late final $SupplementLogsTable supplementLogs = $SupplementLogsTable(this);
  late final $AlcoholLogsTable alcoholLogs = $AlcoholLogsTable(this);
  late final $CaloriePlansTable caloriePlans = $CaloriePlansTable(this);
  late final $CaloriePlanWeeksTable caloriePlanWeeks = $CaloriePlanWeeksTable(
    this,
  );
  late final $DailyEnergyLogsTable dailyEnergyLogs = $DailyEnergyLogsTable(
    this,
  );
  late final $BmrProfilesTable bmrProfiles = $BmrProfilesTable(this);
  late final $WeightLogsTable weightLogs = $WeightLogsTable(this);
  late final $BodyFatLogsTable bodyFatLogs = $BodyFatLogsTable(this);
  late final $ExpenseCategoriesTable expenseCategories =
      $ExpenseCategoriesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    exercises,
    exerciseLogs,
    foods,
    foodLogs,
    supplements,
    supplementLogs,
    alcoholLogs,
    caloriePlans,
    caloriePlanWeeks,
    dailyEnergyLogs,
    bmrProfiles,
    weightLogs,
    bodyFatLogs,
    expenseCategories,
    expenses,
  ];
}

typedef $$ExercisesTableCreateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      required String name,
      required String category,
      Value<String?> muscleGroup,
      Value<bool> isCardio,
      Value<String?> cardioType,
    });
typedef $$ExercisesTableUpdateCompanionBuilder =
    ExercisesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> category,
      Value<String?> muscleGroup,
      Value<bool> isCardio,
      Value<String?> cardioType,
    });

final class $$ExercisesTableReferences
    extends BaseReferences<_$AppDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExerciseLogsTable, List<ExerciseLog>>
  _exerciseLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.exerciseLogs,
    aliasName: $_aliasNameGenerator(
      db.exercises.id,
      db.exerciseLogs.exerciseId,
    ),
  );

  $$ExerciseLogsTableProcessedTableManager get exerciseLogsRefs {
    final manager = $$ExerciseLogsTableTableManager(
      $_db,
      $_db.exerciseLogs,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_exerciseLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCardio => $composableBuilder(
    column: $table.isCardio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardioType => $composableBuilder(
    column: $table.cardioType,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> exerciseLogsRefs(
    Expression<bool> Function($$ExerciseLogsTableFilterComposer f) f,
  ) {
    final $$ExerciseLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseLogs,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseLogsTableFilterComposer(
            $db: $db,
            $table: $db.exerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCardio => $composableBuilder(
    column: $table.isCardio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardioType => $composableBuilder(
    column: $table.cardioType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get muscleGroup => $composableBuilder(
    column: $table.muscleGroup,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCardio =>
      $composableBuilder(column: $table.isCardio, builder: (column) => column);

  GeneratedColumn<String> get cardioType => $composableBuilder(
    column: $table.cardioType,
    builder: (column) => column,
  );

  Expression<T> exerciseLogsRefs<T extends Object>(
    Expression<T> Function($$ExerciseLogsTableAnnotationComposer a) f,
  ) {
    final $$ExerciseLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.exerciseLogs,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.exerciseLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExercisesTable,
          Exercise,
          $$ExercisesTableFilterComposer,
          $$ExercisesTableOrderingComposer,
          $$ExercisesTableAnnotationComposer,
          $$ExercisesTableCreateCompanionBuilder,
          $$ExercisesTableUpdateCompanionBuilder,
          (Exercise, $$ExercisesTableReferences),
          Exercise,
          PrefetchHooks Function({bool exerciseLogsRefs})
        > {
  $$ExercisesTableTableManager(_$AppDatabase db, $ExercisesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> muscleGroup = const Value.absent(),
                Value<bool> isCardio = const Value.absent(),
                Value<String?> cardioType = const Value.absent(),
              }) => ExercisesCompanion(
                id: id,
                name: name,
                category: category,
                muscleGroup: muscleGroup,
                isCardio: isCardio,
                cardioType: cardioType,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String category,
                Value<String?> muscleGroup = const Value.absent(),
                Value<bool> isCardio = const Value.absent(),
                Value<String?> cardioType = const Value.absent(),
              }) => ExercisesCompanion.insert(
                id: id,
                name: name,
                category: category,
                muscleGroup: muscleGroup,
                isCardio: isCardio,
                cardioType: cardioType,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExercisesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (exerciseLogsRefs) db.exerciseLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (exerciseLogsRefs)
                    await $_getPrefetchedData<
                      Exercise,
                      $ExercisesTable,
                      ExerciseLog
                    >(
                      currentTable: table,
                      referencedTable: $$ExercisesTableReferences
                          ._exerciseLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExercisesTableReferences(
                            db,
                            table,
                            p0,
                          ).exerciseLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.exerciseId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExercisesTable,
      Exercise,
      $$ExercisesTableFilterComposer,
      $$ExercisesTableOrderingComposer,
      $$ExercisesTableAnnotationComposer,
      $$ExercisesTableCreateCompanionBuilder,
      $$ExercisesTableUpdateCompanionBuilder,
      (Exercise, $$ExercisesTableReferences),
      Exercise,
      PrefetchHooks Function({bool exerciseLogsRefs})
    >;
typedef $$ExerciseLogsTableCreateCompanionBuilder =
    ExerciseLogsCompanion Function({
      Value<int> id,
      required DateTime logDate,
      required int exerciseId,
      Value<int?> sets,
      Value<int?> reps,
      Value<double?> weight,
      Value<int?> durationMinutes,
      Value<double?> distanceKm,
      Value<String?> notes,
    });
typedef $$ExerciseLogsTableUpdateCompanionBuilder =
    ExerciseLogsCompanion Function({
      Value<int> id,
      Value<DateTime> logDate,
      Value<int> exerciseId,
      Value<int?> sets,
      Value<int?> reps,
      Value<double?> weight,
      Value<int?> durationMinutes,
      Value<double?> distanceKm,
      Value<String?> notes,
    });

final class $$ExerciseLogsTableReferences
    extends BaseReferences<_$AppDatabase, $ExerciseLogsTable, ExerciseLog> {
  $$ExerciseLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExercisesTable _exerciseIdTable(_$AppDatabase db) =>
      db.exercises.createAlias(
        $_aliasNameGenerator(db.exerciseLogs.exerciseId, db.exercises.id),
      );

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExercisesTableTableManager(
      $_db,
      $_db.exercises,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExerciseLogsTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseLogsTable> {
  $$ExerciseLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableFilterComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseLogsTable> {
  $$ExerciseLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableOrderingComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseLogsTable> {
  $$ExerciseLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get distanceKm => $composableBuilder(
    column: $table.distanceKm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exercises,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExercisesTableAnnotationComposer(
            $db: $db,
            $table: $db.exercises,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExerciseLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseLogsTable,
          ExerciseLog,
          $$ExerciseLogsTableFilterComposer,
          $$ExerciseLogsTableOrderingComposer,
          $$ExerciseLogsTableAnnotationComposer,
          $$ExerciseLogsTableCreateCompanionBuilder,
          $$ExerciseLogsTableUpdateCompanionBuilder,
          (ExerciseLog, $$ExerciseLogsTableReferences),
          ExerciseLog,
          PrefetchHooks Function({bool exerciseId})
        > {
  $$ExerciseLogsTableTableManager(_$AppDatabase db, $ExerciseLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExerciseLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExerciseLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExerciseLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int?> sets = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<int?> durationMinutes = const Value.absent(),
                Value<double?> distanceKm = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ExerciseLogsCompanion(
                id: id,
                logDate: logDate,
                exerciseId: exerciseId,
                sets: sets,
                reps: reps,
                weight: weight,
                durationMinutes: durationMinutes,
                distanceKm: distanceKm,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime logDate,
                required int exerciseId,
                Value<int?> sets = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<int?> durationMinutes = const Value.absent(),
                Value<double?> distanceKm = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ExerciseLogsCompanion.insert(
                id: id,
                logDate: logDate,
                exerciseId: exerciseId,
                sets: sets,
                reps: reps,
                weight: weight,
                durationMinutes: durationMinutes,
                distanceKm: distanceKm,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExerciseLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({exerciseId = false}) {
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
                    if (exerciseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.exerciseId,
                                referencedTable: $$ExerciseLogsTableReferences
                                    ._exerciseIdTable(db),
                                referencedColumn: $$ExerciseLogsTableReferences
                                    ._exerciseIdTable(db)
                                    .id,
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

typedef $$ExerciseLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseLogsTable,
      ExerciseLog,
      $$ExerciseLogsTableFilterComposer,
      $$ExerciseLogsTableOrderingComposer,
      $$ExerciseLogsTableAnnotationComposer,
      $$ExerciseLogsTableCreateCompanionBuilder,
      $$ExerciseLogsTableUpdateCompanionBuilder,
      (ExerciseLog, $$ExerciseLogsTableReferences),
      ExerciseLog,
      PrefetchHooks Function({bool exerciseId})
    >;
typedef $$FoodsTableCreateCompanionBuilder =
    FoodsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> barcode,
      required double calories,
      required double protein,
      required double carbs,
      required double fat,
      Value<double?> fiber,
      Value<double?> sugar,
      Value<double> servingSize,
      Value<String> servingUnit,
      Value<String> source,
      Value<String?> imageUrl,
      Value<bool> verified,
      Value<String?> createdBy,
    });
typedef $$FoodsTableUpdateCompanionBuilder =
    FoodsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> barcode,
      Value<double> calories,
      Value<double> protein,
      Value<double> carbs,
      Value<double> fat,
      Value<double?> fiber,
      Value<double?> sugar,
      Value<double> servingSize,
      Value<String> servingUnit,
      Value<String> source,
      Value<String?> imageUrl,
      Value<bool> verified,
      Value<String?> createdBy,
    });

final class $$FoodsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodsTable, Food> {
  $$FoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FoodLogsTable, List<FoodLog>> _foodLogsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.foodLogs,
    aliasName: $_aliasNameGenerator(db.foods.id, db.foodLogs.foodId),
  );

  $$FoodLogsTableProcessedTableManager get foodLogsRefs {
    final manager = $$FoodLogsTableTableManager(
      $_db,
      $_db.foodLogs,
    ).filter((f) => f.foodId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_foodLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FoodsTableFilterComposer extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fiber => $composableBuilder(
    column: $table.fiber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sugar => $composableBuilder(
    column: $table.sugar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servingSize => $composableBuilder(
    column: $table.servingSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get servingUnit => $composableBuilder(
    column: $table.servingUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> foodLogsRefs(
    Expression<bool> Function($$FoodLogsTableFilterComposer f) f,
  ) {
    final $$FoodLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodLogs,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodLogsTableFilterComposer(
            $db: $db,
            $table: $db.foodLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fiber => $composableBuilder(
    column: $table.fiber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sugar => $composableBuilder(
    column: $table.sugar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servingSize => $composableBuilder(
    column: $table.servingSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get servingUnit => $composableBuilder(
    column: $table.servingUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<double> get fiber =>
      $composableBuilder(column: $table.fiber, builder: (column) => column);

  GeneratedColumn<double> get sugar =>
      $composableBuilder(column: $table.sugar, builder: (column) => column);

  GeneratedColumn<double> get servingSize => $composableBuilder(
    column: $table.servingSize,
    builder: (column) => column,
  );

  GeneratedColumn<String> get servingUnit => $composableBuilder(
    column: $table.servingUnit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get verified =>
      $composableBuilder(column: $table.verified, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  Expression<T> foodLogsRefs<T extends Object>(
    Expression<T> Function($$FoodLogsTableAnnotationComposer a) f,
  ) {
    final $$FoodLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.foodLogs,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.foodLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodsTable,
          Food,
          $$FoodsTableFilterComposer,
          $$FoodsTableOrderingComposer,
          $$FoodsTableAnnotationComposer,
          $$FoodsTableCreateCompanionBuilder,
          $$FoodsTableUpdateCompanionBuilder,
          (Food, $$FoodsTableReferences),
          Food,
          PrefetchHooks Function({bool foodLogsRefs})
        > {
  $$FoodsTableTableManager(_$AppDatabase db, $FoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<double?> fiber = const Value.absent(),
                Value<double?> sugar = const Value.absent(),
                Value<double> servingSize = const Value.absent(),
                Value<String> servingUnit = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
              }) => FoodsCompanion(
                id: id,
                name: name,
                barcode: barcode,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                fiber: fiber,
                sugar: sugar,
                servingSize: servingSize,
                servingUnit: servingUnit,
                source: source,
                imageUrl: imageUrl,
                verified: verified,
                createdBy: createdBy,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> barcode = const Value.absent(),
                required double calories,
                required double protein,
                required double carbs,
                required double fat,
                Value<double?> fiber = const Value.absent(),
                Value<double?> sugar = const Value.absent(),
                Value<double> servingSize = const Value.absent(),
                Value<String> servingUnit = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
              }) => FoodsCompanion.insert(
                id: id,
                name: name,
                barcode: barcode,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                fiber: fiber,
                sugar: sugar,
                servingSize: servingSize,
                servingUnit: servingUnit,
                source: source,
                imageUrl: imageUrl,
                verified: verified,
                createdBy: createdBy,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$FoodsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({foodLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (foodLogsRefs) db.foodLogs],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (foodLogsRefs)
                    await $_getPrefetchedData<Food, $FoodsTable, FoodLog>(
                      currentTable: table,
                      referencedTable: $$FoodsTableReferences
                          ._foodLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FoodsTableReferences(db, table, p0).foodLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.foodId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodsTable,
      Food,
      $$FoodsTableFilterComposer,
      $$FoodsTableOrderingComposer,
      $$FoodsTableAnnotationComposer,
      $$FoodsTableCreateCompanionBuilder,
      $$FoodsTableUpdateCompanionBuilder,
      (Food, $$FoodsTableReferences),
      Food,
      PrefetchHooks Function({bool foodLogsRefs})
    >;
typedef $$FoodLogsTableCreateCompanionBuilder =
    FoodLogsCompanion Function({
      Value<int> id,
      required DateTime logDate,
      required int foodId,
      Value<double> servings,
      required String mealType,
      Value<bool> isEaten,
    });
typedef $$FoodLogsTableUpdateCompanionBuilder =
    FoodLogsCompanion Function({
      Value<int> id,
      Value<DateTime> logDate,
      Value<int> foodId,
      Value<double> servings,
      Value<String> mealType,
      Value<bool> isEaten,
    });

final class $$FoodLogsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodLogsTable, FoodLog> {
  $$FoodLogsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FoodsTable _foodIdTable(_$AppDatabase db) => db.foods.createAlias(
    $_aliasNameGenerator(db.foodLogs.foodId, db.foods.id),
  );

  $$FoodsTableProcessedTableManager get foodId {
    final $_column = $_itemColumn<int>('food_id')!;

    final manager = $$FoodsTableTableManager(
      $_db,
      $_db.foods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: $_aliasNameGenerator(
      db.foodLogs.id,
      db.expenses.linkedFoodLogId,
    ),
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.linkedFoodLogId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FoodLogsTableFilterComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEaten => $composableBuilder(
    column: $table.isEaten,
    builder: (column) => ColumnFilters(column),
  );

  $$FoodsTableFilterComposer get foodId {
    final $$FoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableFilterComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.linkedFoodLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEaten => $composableBuilder(
    column: $table.isEaten,
    builder: (column) => ColumnOrderings(column),
  );

  $$FoodsTableOrderingComposer get foodId {
    final $$FoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableOrderingComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FoodLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodLogsTable> {
  $$FoodLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<double> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<bool> get isEaten =>
      $composableBuilder(column: $table.isEaten, builder: (column) => column);

  $$FoodsTableAnnotationComposer get foodId {
    final $$FoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.linkedFoodLogId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodLogsTable,
          FoodLog,
          $$FoodLogsTableFilterComposer,
          $$FoodLogsTableOrderingComposer,
          $$FoodLogsTableAnnotationComposer,
          $$FoodLogsTableCreateCompanionBuilder,
          $$FoodLogsTableUpdateCompanionBuilder,
          (FoodLog, $$FoodLogsTableReferences),
          FoodLog,
          PrefetchHooks Function({bool foodId, bool expensesRefs})
        > {
  $$FoodLogsTableTableManager(_$AppDatabase db, $FoodLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<int> foodId = const Value.absent(),
                Value<double> servings = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<bool> isEaten = const Value.absent(),
              }) => FoodLogsCompanion(
                id: id,
                logDate: logDate,
                foodId: foodId,
                servings: servings,
                mealType: mealType,
                isEaten: isEaten,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime logDate,
                required int foodId,
                Value<double> servings = const Value.absent(),
                required String mealType,
                Value<bool> isEaten = const Value.absent(),
              }) => FoodLogsCompanion.insert(
                id: id,
                logDate: logDate,
                foodId: foodId,
                servings: servings,
                mealType: mealType,
                isEaten: isEaten,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FoodLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({foodId = false, expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
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
                    if (foodId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.foodId,
                                referencedTable: $$FoodLogsTableReferences
                                    ._foodIdTable(db),
                                referencedColumn: $$FoodLogsTableReferences
                                    ._foodIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<FoodLog, $FoodLogsTable, Expense>(
                      currentTable: table,
                      referencedTable: $$FoodLogsTableReferences
                          ._expensesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FoodLogsTableReferences(db, table, p0).expensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.linkedFoodLogId == item.id,
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

typedef $$FoodLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodLogsTable,
      FoodLog,
      $$FoodLogsTableFilterComposer,
      $$FoodLogsTableOrderingComposer,
      $$FoodLogsTableAnnotationComposer,
      $$FoodLogsTableCreateCompanionBuilder,
      $$FoodLogsTableUpdateCompanionBuilder,
      (FoodLog, $$FoodLogsTableReferences),
      FoodLog,
      PrefetchHooks Function({bool foodId, bool expensesRefs})
    >;
typedef $$SupplementsTableCreateCompanionBuilder =
    SupplementsCompanion Function({
      Value<int> id,
      required String name,
      required String type,
      Value<String> dosageUnit,
    });
typedef $$SupplementsTableUpdateCompanionBuilder =
    SupplementsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> type,
      Value<String> dosageUnit,
    });

final class $$SupplementsTableReferences
    extends BaseReferences<_$AppDatabase, $SupplementsTable, Supplement> {
  $$SupplementsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SupplementLogsTable, List<SupplementLog>>
  _supplementLogsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.supplementLogs,
    aliasName: $_aliasNameGenerator(
      db.supplements.id,
      db.supplementLogs.supplementId,
    ),
  );

  $$SupplementLogsTableProcessedTableManager get supplementLogsRefs {
    final manager = $$SupplementLogsTableTableManager(
      $_db,
      $_db.supplementLogs,
    ).filter((f) => f.supplementId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_supplementLogsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SupplementsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosageUnit => $composableBuilder(
    column: $table.dosageUnit,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> supplementLogsRefs(
    Expression<bool> Function($$SupplementLogsTableFilterComposer f) f,
  ) {
    final $$SupplementLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.supplementLogs,
      getReferencedColumn: (t) => t.supplementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplementLogsTableFilterComposer(
            $db: $db,
            $table: $db.supplementLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SupplementsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosageUnit => $composableBuilder(
    column: $table.dosageUnit,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplementsTable> {
  $$SupplementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get dosageUnit => $composableBuilder(
    column: $table.dosageUnit,
    builder: (column) => column,
  );

  Expression<T> supplementLogsRefs<T extends Object>(
    Expression<T> Function($$SupplementLogsTableAnnotationComposer a) f,
  ) {
    final $$SupplementLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.supplementLogs,
      getReferencedColumn: (t) => t.supplementId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplementLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.supplementLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SupplementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplementsTable,
          Supplement,
          $$SupplementsTableFilterComposer,
          $$SupplementsTableOrderingComposer,
          $$SupplementsTableAnnotationComposer,
          $$SupplementsTableCreateCompanionBuilder,
          $$SupplementsTableUpdateCompanionBuilder,
          (Supplement, $$SupplementsTableReferences),
          Supplement,
          PrefetchHooks Function({bool supplementLogsRefs})
        > {
  $$SupplementsTableTableManager(_$AppDatabase db, $SupplementsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> dosageUnit = const Value.absent(),
              }) => SupplementsCompanion(
                id: id,
                name: name,
                type: type,
                dosageUnit: dosageUnit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String type,
                Value<String> dosageUnit = const Value.absent(),
              }) => SupplementsCompanion.insert(
                id: id,
                name: name,
                type: type,
                dosageUnit: dosageUnit,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SupplementsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({supplementLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (supplementLogsRefs) db.supplementLogs,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (supplementLogsRefs)
                    await $_getPrefetchedData<
                      Supplement,
                      $SupplementsTable,
                      SupplementLog
                    >(
                      currentTable: table,
                      referencedTable: $$SupplementsTableReferences
                          ._supplementLogsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SupplementsTableReferences(
                            db,
                            table,
                            p0,
                          ).supplementLogsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.supplementId == item.id,
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

typedef $$SupplementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplementsTable,
      Supplement,
      $$SupplementsTableFilterComposer,
      $$SupplementsTableOrderingComposer,
      $$SupplementsTableAnnotationComposer,
      $$SupplementsTableCreateCompanionBuilder,
      $$SupplementsTableUpdateCompanionBuilder,
      (Supplement, $$SupplementsTableReferences),
      Supplement,
      PrefetchHooks Function({bool supplementLogsRefs})
    >;
typedef $$SupplementLogsTableCreateCompanionBuilder =
    SupplementLogsCompanion Function({
      Value<int> id,
      required DateTime logDate,
      required int supplementId,
      required double dosage,
    });
typedef $$SupplementLogsTableUpdateCompanionBuilder =
    SupplementLogsCompanion Function({
      Value<int> id,
      Value<DateTime> logDate,
      Value<int> supplementId,
      Value<double> dosage,
    });

final class $$SupplementLogsTableReferences
    extends BaseReferences<_$AppDatabase, $SupplementLogsTable, SupplementLog> {
  $$SupplementLogsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SupplementsTable _supplementIdTable(_$AppDatabase db) =>
      db.supplements.createAlias(
        $_aliasNameGenerator(db.supplementLogs.supplementId, db.supplements.id),
      );

  $$SupplementsTableProcessedTableManager get supplementId {
    final $_column = $_itemColumn<int>('supplement_id')!;

    final manager = $$SupplementsTableTableManager(
      $_db,
      $_db.supplements,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supplementIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SupplementLogsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplementLogsTable> {
  $$SupplementLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnFilters(column),
  );

  $$SupplementsTableFilterComposer get supplementId {
    final $$SupplementsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplementId,
      referencedTable: $db.supplements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplementsTableFilterComposer(
            $db: $db,
            $table: $db.supplements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupplementLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplementLogsTable> {
  $$SupplementLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dosage => $composableBuilder(
    column: $table.dosage,
    builder: (column) => ColumnOrderings(column),
  );

  $$SupplementsTableOrderingComposer get supplementId {
    final $$SupplementsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplementId,
      referencedTable: $db.supplements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplementsTableOrderingComposer(
            $db: $db,
            $table: $db.supplements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupplementLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplementLogsTable> {
  $$SupplementLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<double> get dosage =>
      $composableBuilder(column: $table.dosage, builder: (column) => column);

  $$SupplementsTableAnnotationComposer get supplementId {
    final $$SupplementsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supplementId,
      referencedTable: $db.supplements,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupplementsTableAnnotationComposer(
            $db: $db,
            $table: $db.supplements,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupplementLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplementLogsTable,
          SupplementLog,
          $$SupplementLogsTableFilterComposer,
          $$SupplementLogsTableOrderingComposer,
          $$SupplementLogsTableAnnotationComposer,
          $$SupplementLogsTableCreateCompanionBuilder,
          $$SupplementLogsTableUpdateCompanionBuilder,
          (SupplementLog, $$SupplementLogsTableReferences),
          SupplementLog,
          PrefetchHooks Function({bool supplementId})
        > {
  $$SupplementLogsTableTableManager(
    _$AppDatabase db,
    $SupplementLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplementLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplementLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplementLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<int> supplementId = const Value.absent(),
                Value<double> dosage = const Value.absent(),
              }) => SupplementLogsCompanion(
                id: id,
                logDate: logDate,
                supplementId: supplementId,
                dosage: dosage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime logDate,
                required int supplementId,
                required double dosage,
              }) => SupplementLogsCompanion.insert(
                id: id,
                logDate: logDate,
                supplementId: supplementId,
                dosage: dosage,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SupplementLogsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({supplementId = false}) {
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
                    if (supplementId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.supplementId,
                                referencedTable: $$SupplementLogsTableReferences
                                    ._supplementIdTable(db),
                                referencedColumn:
                                    $$SupplementLogsTableReferences
                                        ._supplementIdTable(db)
                                        .id,
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

typedef $$SupplementLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplementLogsTable,
      SupplementLog,
      $$SupplementLogsTableFilterComposer,
      $$SupplementLogsTableOrderingComposer,
      $$SupplementLogsTableAnnotationComposer,
      $$SupplementLogsTableCreateCompanionBuilder,
      $$SupplementLogsTableUpdateCompanionBuilder,
      (SupplementLog, $$SupplementLogsTableReferences),
      SupplementLog,
      PrefetchHooks Function({bool supplementId})
    >;
typedef $$AlcoholLogsTableCreateCompanionBuilder =
    AlcoholLogsCompanion Function({
      Value<int> id,
      required DateTime logDate,
      required String drinkType,
      required double units,
      required double calories,
      Value<double?> volumeMl,
      Value<double> protein,
      Value<double> carbs,
      Value<double> fat,
      Value<bool> isEaten,
    });
typedef $$AlcoholLogsTableUpdateCompanionBuilder =
    AlcoholLogsCompanion Function({
      Value<int> id,
      Value<DateTime> logDate,
      Value<String> drinkType,
      Value<double> units,
      Value<double> calories,
      Value<double?> volumeMl,
      Value<double> protein,
      Value<double> carbs,
      Value<double> fat,
      Value<bool> isEaten,
    });

class $$AlcoholLogsTableFilterComposer
    extends Composer<_$AppDatabase, $AlcoholLogsTable> {
  $$AlcoholLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get drinkType => $composableBuilder(
    column: $table.drinkType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volumeMl => $composableBuilder(
    column: $table.volumeMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEaten => $composableBuilder(
    column: $table.isEaten,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlcoholLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlcoholLogsTable> {
  $$AlcoholLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get drinkType => $composableBuilder(
    column: $table.drinkType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get units => $composableBuilder(
    column: $table.units,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volumeMl => $composableBuilder(
    column: $table.volumeMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEaten => $composableBuilder(
    column: $table.isEaten,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlcoholLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlcoholLogsTable> {
  $$AlcoholLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<String> get drinkType =>
      $composableBuilder(column: $table.drinkType, builder: (column) => column);

  GeneratedColumn<double> get units =>
      $composableBuilder(column: $table.units, builder: (column) => column);

  GeneratedColumn<double> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<double> get volumeMl =>
      $composableBuilder(column: $table.volumeMl, builder: (column) => column);

  GeneratedColumn<double> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<double> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<double> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<bool> get isEaten =>
      $composableBuilder(column: $table.isEaten, builder: (column) => column);
}

class $$AlcoholLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlcoholLogsTable,
          AlcoholLog,
          $$AlcoholLogsTableFilterComposer,
          $$AlcoholLogsTableOrderingComposer,
          $$AlcoholLogsTableAnnotationComposer,
          $$AlcoholLogsTableCreateCompanionBuilder,
          $$AlcoholLogsTableUpdateCompanionBuilder,
          (
            AlcoholLog,
            BaseReferences<_$AppDatabase, $AlcoholLogsTable, AlcoholLog>,
          ),
          AlcoholLog,
          PrefetchHooks Function()
        > {
  $$AlcoholLogsTableTableManager(_$AppDatabase db, $AlcoholLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlcoholLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlcoholLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlcoholLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<String> drinkType = const Value.absent(),
                Value<double> units = const Value.absent(),
                Value<double> calories = const Value.absent(),
                Value<double?> volumeMl = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<bool> isEaten = const Value.absent(),
              }) => AlcoholLogsCompanion(
                id: id,
                logDate: logDate,
                drinkType: drinkType,
                units: units,
                calories: calories,
                volumeMl: volumeMl,
                protein: protein,
                carbs: carbs,
                fat: fat,
                isEaten: isEaten,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime logDate,
                required String drinkType,
                required double units,
                required double calories,
                Value<double?> volumeMl = const Value.absent(),
                Value<double> protein = const Value.absent(),
                Value<double> carbs = const Value.absent(),
                Value<double> fat = const Value.absent(),
                Value<bool> isEaten = const Value.absent(),
              }) => AlcoholLogsCompanion.insert(
                id: id,
                logDate: logDate,
                drinkType: drinkType,
                units: units,
                calories: calories,
                volumeMl: volumeMl,
                protein: protein,
                carbs: carbs,
                fat: fat,
                isEaten: isEaten,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlcoholLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlcoholLogsTable,
      AlcoholLog,
      $$AlcoholLogsTableFilterComposer,
      $$AlcoholLogsTableOrderingComposer,
      $$AlcoholLogsTableAnnotationComposer,
      $$AlcoholLogsTableCreateCompanionBuilder,
      $$AlcoholLogsTableUpdateCompanionBuilder,
      (
        AlcoholLog,
        BaseReferences<_$AppDatabase, $AlcoholLogsTable, AlcoholLog>,
      ),
      AlcoholLog,
      PrefetchHooks Function()
    >;
typedef $$CaloriePlansTableCreateCompanionBuilder =
    CaloriePlansCompanion Function({
      Value<int> id,
      required String name,
      Value<String> goalType,
      required DateTime startDate,
      required DateTime endDate,
      Value<int?> targetDailyCalories,
      Value<int?> targetWeeklyDeficit,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$CaloriePlansTableUpdateCompanionBuilder =
    CaloriePlansCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> goalType,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int?> targetDailyCalories,
      Value<int?> targetWeeklyDeficit,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$CaloriePlansTableReferences
    extends BaseReferences<_$AppDatabase, $CaloriePlansTable, CaloriePlan> {
  $$CaloriePlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CaloriePlanWeeksTable, List<CaloriePlanWeek>>
  _caloriePlanWeeksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.caloriePlanWeeks,
    aliasName: $_aliasNameGenerator(
      db.caloriePlans.id,
      db.caloriePlanWeeks.planId,
    ),
  );

  $$CaloriePlanWeeksTableProcessedTableManager get caloriePlanWeeksRefs {
    final manager = $$CaloriePlanWeeksTableTableManager(
      $_db,
      $_db.caloriePlanWeeks,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _caloriePlanWeeksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CaloriePlansTableFilterComposer
    extends Composer<_$AppDatabase, $CaloriePlansTable> {
  $$CaloriePlansTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDailyCalories => $composableBuilder(
    column: $table.targetDailyCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetWeeklyDeficit => $composableBuilder(
    column: $table.targetWeeklyDeficit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> caloriePlanWeeksRefs(
    Expression<bool> Function($$CaloriePlanWeeksTableFilterComposer f) f,
  ) {
    final $$CaloriePlanWeeksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.caloriePlanWeeks,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaloriePlanWeeksTableFilterComposer(
            $db: $db,
            $table: $db.caloriePlanWeeks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CaloriePlansTableOrderingComposer
    extends Composer<_$AppDatabase, $CaloriePlansTable> {
  $$CaloriePlansTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDailyCalories => $composableBuilder(
    column: $table.targetDailyCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetWeeklyDeficit => $composableBuilder(
    column: $table.targetWeeklyDeficit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CaloriePlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $CaloriePlansTable> {
  $$CaloriePlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get targetDailyCalories => $composableBuilder(
    column: $table.targetDailyCalories,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetWeeklyDeficit => $composableBuilder(
    column: $table.targetWeeklyDeficit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> caloriePlanWeeksRefs<T extends Object>(
    Expression<T> Function($$CaloriePlanWeeksTableAnnotationComposer a) f,
  ) {
    final $$CaloriePlanWeeksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.caloriePlanWeeks,
      getReferencedColumn: (t) => t.planId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaloriePlanWeeksTableAnnotationComposer(
            $db: $db,
            $table: $db.caloriePlanWeeks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CaloriePlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CaloriePlansTable,
          CaloriePlan,
          $$CaloriePlansTableFilterComposer,
          $$CaloriePlansTableOrderingComposer,
          $$CaloriePlansTableAnnotationComposer,
          $$CaloriePlansTableCreateCompanionBuilder,
          $$CaloriePlansTableUpdateCompanionBuilder,
          (CaloriePlan, $$CaloriePlansTableReferences),
          CaloriePlan,
          PrefetchHooks Function({bool caloriePlanWeeksRefs})
        > {
  $$CaloriePlansTableTableManager(_$AppDatabase db, $CaloriePlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaloriePlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaloriePlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaloriePlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> goalType = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int?> targetDailyCalories = const Value.absent(),
                Value<int?> targetWeeklyDeficit = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CaloriePlansCompanion(
                id: id,
                name: name,
                goalType: goalType,
                startDate: startDate,
                endDate: endDate,
                targetDailyCalories: targetDailyCalories,
                targetWeeklyDeficit: targetWeeklyDeficit,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> goalType = const Value.absent(),
                required DateTime startDate,
                required DateTime endDate,
                Value<int?> targetDailyCalories = const Value.absent(),
                Value<int?> targetWeeklyDeficit = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CaloriePlansCompanion.insert(
                id: id,
                name: name,
                goalType: goalType,
                startDate: startDate,
                endDate: endDate,
                targetDailyCalories: targetDailyCalories,
                targetWeeklyDeficit: targetWeeklyDeficit,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CaloriePlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({caloriePlanWeeksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (caloriePlanWeeksRefs) db.caloriePlanWeeks,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (caloriePlanWeeksRefs)
                    await $_getPrefetchedData<
                      CaloriePlan,
                      $CaloriePlansTable,
                      CaloriePlanWeek
                    >(
                      currentTable: table,
                      referencedTable: $$CaloriePlansTableReferences
                          ._caloriePlanWeeksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CaloriePlansTableReferences(
                            db,
                            table,
                            p0,
                          ).caloriePlanWeeksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.planId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CaloriePlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CaloriePlansTable,
      CaloriePlan,
      $$CaloriePlansTableFilterComposer,
      $$CaloriePlansTableOrderingComposer,
      $$CaloriePlansTableAnnotationComposer,
      $$CaloriePlansTableCreateCompanionBuilder,
      $$CaloriePlansTableUpdateCompanionBuilder,
      (CaloriePlan, $$CaloriePlansTableReferences),
      CaloriePlan,
      PrefetchHooks Function({bool caloriePlanWeeksRefs})
    >;
typedef $$CaloriePlanWeeksTableCreateCompanionBuilder =
    CaloriePlanWeeksCompanion Function({
      Value<int> id,
      required int planId,
      required int weekNumber,
      required DateTime weekStartDate,
      required DateTime weekEndDate,
      Value<int?> targetDailyCalories,
      Value<int?> targetWeeklyDeficit,
    });
typedef $$CaloriePlanWeeksTableUpdateCompanionBuilder =
    CaloriePlanWeeksCompanion Function({
      Value<int> id,
      Value<int> planId,
      Value<int> weekNumber,
      Value<DateTime> weekStartDate,
      Value<DateTime> weekEndDate,
      Value<int?> targetDailyCalories,
      Value<int?> targetWeeklyDeficit,
    });

final class $$CaloriePlanWeeksTableReferences
    extends
        BaseReferences<_$AppDatabase, $CaloriePlanWeeksTable, CaloriePlanWeek> {
  $$CaloriePlanWeeksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CaloriePlansTable _planIdTable(_$AppDatabase db) =>
      db.caloriePlans.createAlias(
        $_aliasNameGenerator(db.caloriePlanWeeks.planId, db.caloriePlans.id),
      );

  $$CaloriePlansTableProcessedTableManager get planId {
    final $_column = $_itemColumn<int>('plan_id')!;

    final manager = $$CaloriePlansTableTableManager(
      $_db,
      $_db.caloriePlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CaloriePlanWeeksTableFilterComposer
    extends Composer<_$AppDatabase, $CaloriePlanWeeksTable> {
  $$CaloriePlanWeeksTableFilterComposer({
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

  ColumnFilters<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get weekStartDate => $composableBuilder(
    column: $table.weekStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get weekEndDate => $composableBuilder(
    column: $table.weekEndDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDailyCalories => $composableBuilder(
    column: $table.targetDailyCalories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetWeeklyDeficit => $composableBuilder(
    column: $table.targetWeeklyDeficit,
    builder: (column) => ColumnFilters(column),
  );

  $$CaloriePlansTableFilterComposer get planId {
    final $$CaloriePlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.caloriePlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaloriePlansTableFilterComposer(
            $db: $db,
            $table: $db.caloriePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CaloriePlanWeeksTableOrderingComposer
    extends Composer<_$AppDatabase, $CaloriePlanWeeksTable> {
  $$CaloriePlanWeeksTableOrderingComposer({
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

  ColumnOrderings<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get weekStartDate => $composableBuilder(
    column: $table.weekStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get weekEndDate => $composableBuilder(
    column: $table.weekEndDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDailyCalories => $composableBuilder(
    column: $table.targetDailyCalories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetWeeklyDeficit => $composableBuilder(
    column: $table.targetWeeklyDeficit,
    builder: (column) => ColumnOrderings(column),
  );

  $$CaloriePlansTableOrderingComposer get planId {
    final $$CaloriePlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.caloriePlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaloriePlansTableOrderingComposer(
            $db: $db,
            $table: $db.caloriePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CaloriePlanWeeksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CaloriePlanWeeksTable> {
  $$CaloriePlanWeeksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekNumber => $composableBuilder(
    column: $table.weekNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get weekStartDate => $composableBuilder(
    column: $table.weekStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get weekEndDate => $composableBuilder(
    column: $table.weekEndDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetDailyCalories => $composableBuilder(
    column: $table.targetDailyCalories,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetWeeklyDeficit => $composableBuilder(
    column: $table.targetWeeklyDeficit,
    builder: (column) => column,
  );

  $$CaloriePlansTableAnnotationComposer get planId {
    final $$CaloriePlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.caloriePlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CaloriePlansTableAnnotationComposer(
            $db: $db,
            $table: $db.caloriePlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CaloriePlanWeeksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CaloriePlanWeeksTable,
          CaloriePlanWeek,
          $$CaloriePlanWeeksTableFilterComposer,
          $$CaloriePlanWeeksTableOrderingComposer,
          $$CaloriePlanWeeksTableAnnotationComposer,
          $$CaloriePlanWeeksTableCreateCompanionBuilder,
          $$CaloriePlanWeeksTableUpdateCompanionBuilder,
          (CaloriePlanWeek, $$CaloriePlanWeeksTableReferences),
          CaloriePlanWeek,
          PrefetchHooks Function({bool planId})
        > {
  $$CaloriePlanWeeksTableTableManager(
    _$AppDatabase db,
    $CaloriePlanWeeksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CaloriePlanWeeksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CaloriePlanWeeksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CaloriePlanWeeksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> planId = const Value.absent(),
                Value<int> weekNumber = const Value.absent(),
                Value<DateTime> weekStartDate = const Value.absent(),
                Value<DateTime> weekEndDate = const Value.absent(),
                Value<int?> targetDailyCalories = const Value.absent(),
                Value<int?> targetWeeklyDeficit = const Value.absent(),
              }) => CaloriePlanWeeksCompanion(
                id: id,
                planId: planId,
                weekNumber: weekNumber,
                weekStartDate: weekStartDate,
                weekEndDate: weekEndDate,
                targetDailyCalories: targetDailyCalories,
                targetWeeklyDeficit: targetWeeklyDeficit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int planId,
                required int weekNumber,
                required DateTime weekStartDate,
                required DateTime weekEndDate,
                Value<int?> targetDailyCalories = const Value.absent(),
                Value<int?> targetWeeklyDeficit = const Value.absent(),
              }) => CaloriePlanWeeksCompanion.insert(
                id: id,
                planId: planId,
                weekNumber: weekNumber,
                weekStartDate: weekStartDate,
                weekEndDate: weekEndDate,
                targetDailyCalories: targetDailyCalories,
                targetWeeklyDeficit: targetWeeklyDeficit,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CaloriePlanWeeksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planId = false}) {
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
                    if (planId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.planId,
                                referencedTable:
                                    $$CaloriePlanWeeksTableReferences
                                        ._planIdTable(db),
                                referencedColumn:
                                    $$CaloriePlanWeeksTableReferences
                                        ._planIdTable(db)
                                        .id,
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

typedef $$CaloriePlanWeeksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CaloriePlanWeeksTable,
      CaloriePlanWeek,
      $$CaloriePlanWeeksTableFilterComposer,
      $$CaloriePlanWeeksTableOrderingComposer,
      $$CaloriePlanWeeksTableAnnotationComposer,
      $$CaloriePlanWeeksTableCreateCompanionBuilder,
      $$CaloriePlanWeeksTableUpdateCompanionBuilder,
      (CaloriePlanWeek, $$CaloriePlanWeeksTableReferences),
      CaloriePlanWeek,
      PrefetchHooks Function({bool planId})
    >;
typedef $$DailyEnergyLogsTableCreateCompanionBuilder =
    DailyEnergyLogsCompanion Function({
      Value<int> id,
      required DateTime logDate,
      Value<int> steps,
      required double caloriesOut,
      Value<String> source,
      Value<String?> notes,
      Value<DateTime> updatedAt,
    });
typedef $$DailyEnergyLogsTableUpdateCompanionBuilder =
    DailyEnergyLogsCompanion Function({
      Value<int> id,
      Value<DateTime> logDate,
      Value<int> steps,
      Value<double> caloriesOut,
      Value<String> source,
      Value<String?> notes,
      Value<DateTime> updatedAt,
    });

class $$DailyEnergyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyEnergyLogsTable> {
  $$DailyEnergyLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get caloriesOut => $composableBuilder(
    column: $table.caloriesOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyEnergyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyEnergyLogsTable> {
  $$DailyEnergyLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get caloriesOut => $composableBuilder(
    column: $table.caloriesOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyEnergyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyEnergyLogsTable> {
  $$DailyEnergyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<int> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<double> get caloriesOut => $composableBuilder(
    column: $table.caloriesOut,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyEnergyLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyEnergyLogsTable,
          DailyEnergyLog,
          $$DailyEnergyLogsTableFilterComposer,
          $$DailyEnergyLogsTableOrderingComposer,
          $$DailyEnergyLogsTableAnnotationComposer,
          $$DailyEnergyLogsTableCreateCompanionBuilder,
          $$DailyEnergyLogsTableUpdateCompanionBuilder,
          (
            DailyEnergyLog,
            BaseReferences<
              _$AppDatabase,
              $DailyEnergyLogsTable,
              DailyEnergyLog
            >,
          ),
          DailyEnergyLog,
          PrefetchHooks Function()
        > {
  $$DailyEnergyLogsTableTableManager(
    _$AppDatabase db,
    $DailyEnergyLogsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyEnergyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyEnergyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyEnergyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<int> steps = const Value.absent(),
                Value<double> caloriesOut = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyEnergyLogsCompanion(
                id: id,
                logDate: logDate,
                steps: steps,
                caloriesOut: caloriesOut,
                source: source,
                notes: notes,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime logDate,
                Value<int> steps = const Value.absent(),
                required double caloriesOut,
                Value<String> source = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DailyEnergyLogsCompanion.insert(
                id: id,
                logDate: logDate,
                steps: steps,
                caloriesOut: caloriesOut,
                source: source,
                notes: notes,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyEnergyLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyEnergyLogsTable,
      DailyEnergyLog,
      $$DailyEnergyLogsTableFilterComposer,
      $$DailyEnergyLogsTableOrderingComposer,
      $$DailyEnergyLogsTableAnnotationComposer,
      $$DailyEnergyLogsTableCreateCompanionBuilder,
      $$DailyEnergyLogsTableUpdateCompanionBuilder,
      (
        DailyEnergyLog,
        BaseReferences<_$AppDatabase, $DailyEnergyLogsTable, DailyEnergyLog>,
      ),
      DailyEnergyLog,
      PrefetchHooks Function()
    >;
typedef $$BmrProfilesTableCreateCompanionBuilder =
    BmrProfilesCompanion Function({
      Value<int> id,
      required double bmr,
      Value<DateTime> updatedAt,
    });
typedef $$BmrProfilesTableUpdateCompanionBuilder =
    BmrProfilesCompanion Function({
      Value<int> id,
      Value<double> bmr,
      Value<DateTime> updatedAt,
    });

class $$BmrProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $BmrProfilesTable> {
  $$BmrProfilesTableFilterComposer({
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

  ColumnFilters<double> get bmr => $composableBuilder(
    column: $table.bmr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BmrProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $BmrProfilesTable> {
  $$BmrProfilesTableOrderingComposer({
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

  ColumnOrderings<double> get bmr => $composableBuilder(
    column: $table.bmr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BmrProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BmrProfilesTable> {
  $$BmrProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get bmr =>
      $composableBuilder(column: $table.bmr, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BmrProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BmrProfilesTable,
          BmrProfile,
          $$BmrProfilesTableFilterComposer,
          $$BmrProfilesTableOrderingComposer,
          $$BmrProfilesTableAnnotationComposer,
          $$BmrProfilesTableCreateCompanionBuilder,
          $$BmrProfilesTableUpdateCompanionBuilder,
          (
            BmrProfile,
            BaseReferences<_$AppDatabase, $BmrProfilesTable, BmrProfile>,
          ),
          BmrProfile,
          PrefetchHooks Function()
        > {
  $$BmrProfilesTableTableManager(_$AppDatabase db, $BmrProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BmrProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BmrProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BmrProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> bmr = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) =>
                  BmrProfilesCompanion(id: id, bmr: bmr, updatedAt: updatedAt),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double bmr,
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BmrProfilesCompanion.insert(
                id: id,
                bmr: bmr,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BmrProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BmrProfilesTable,
      BmrProfile,
      $$BmrProfilesTableFilterComposer,
      $$BmrProfilesTableOrderingComposer,
      $$BmrProfilesTableAnnotationComposer,
      $$BmrProfilesTableCreateCompanionBuilder,
      $$BmrProfilesTableUpdateCompanionBuilder,
      (
        BmrProfile,
        BaseReferences<_$AppDatabase, $BmrProfilesTable, BmrProfile>,
      ),
      BmrProfile,
      PrefetchHooks Function()
    >;
typedef $$WeightLogsTableCreateCompanionBuilder =
    WeightLogsCompanion Function({
      Value<int> id,
      required DateTime logDate,
      required double weightKg,
      Value<String?> notes,
    });
typedef $$WeightLogsTableUpdateCompanionBuilder =
    WeightLogsCompanion Function({
      Value<int> id,
      Value<DateTime> logDate,
      Value<double> weightKg,
      Value<String?> notes,
    });

class $$WeightLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$WeightLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightLogsTable,
          WeightLog,
          $$WeightLogsTableFilterComposer,
          $$WeightLogsTableOrderingComposer,
          $$WeightLogsTableAnnotationComposer,
          $$WeightLogsTableCreateCompanionBuilder,
          $$WeightLogsTableUpdateCompanionBuilder,
          (
            WeightLog,
            BaseReferences<_$AppDatabase, $WeightLogsTable, WeightLog>,
          ),
          WeightLog,
          PrefetchHooks Function()
        > {
  $$WeightLogsTableTableManager(_$AppDatabase db, $WeightLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WeightLogsCompanion(
                id: id,
                logDate: logDate,
                weightKg: weightKg,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime logDate,
                required double weightKg,
                Value<String?> notes = const Value.absent(),
              }) => WeightLogsCompanion.insert(
                id: id,
                logDate: logDate,
                weightKg: weightKg,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightLogsTable,
      WeightLog,
      $$WeightLogsTableFilterComposer,
      $$WeightLogsTableOrderingComposer,
      $$WeightLogsTableAnnotationComposer,
      $$WeightLogsTableCreateCompanionBuilder,
      $$WeightLogsTableUpdateCompanionBuilder,
      (WeightLog, BaseReferences<_$AppDatabase, $WeightLogsTable, WeightLog>),
      WeightLog,
      PrefetchHooks Function()
    >;
typedef $$BodyFatLogsTableCreateCompanionBuilder =
    BodyFatLogsCompanion Function({
      Value<int> id,
      required DateTime logDate,
      required double bodyFatPercent,
      Value<String> method,
      Value<String?> notes,
    });
typedef $$BodyFatLogsTableUpdateCompanionBuilder =
    BodyFatLogsCompanion Function({
      Value<int> id,
      Value<DateTime> logDate,
      Value<double> bodyFatPercent,
      Value<String> method,
      Value<String?> notes,
    });

class $$BodyFatLogsTableFilterComposer
    extends Composer<_$AppDatabase, $BodyFatLogsTable> {
  $$BodyFatLogsTableFilterComposer({
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

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BodyFatLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $BodyFatLogsTable> {
  $$BodyFatLogsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BodyFatLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BodyFatLogsTable> {
  $$BodyFatLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<double> get bodyFatPercent => $composableBuilder(
    column: $table.bodyFatPercent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$BodyFatLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BodyFatLogsTable,
          BodyFatLog,
          $$BodyFatLogsTableFilterComposer,
          $$BodyFatLogsTableOrderingComposer,
          $$BodyFatLogsTableAnnotationComposer,
          $$BodyFatLogsTableCreateCompanionBuilder,
          $$BodyFatLogsTableUpdateCompanionBuilder,
          (
            BodyFatLog,
            BaseReferences<_$AppDatabase, $BodyFatLogsTable, BodyFatLog>,
          ),
          BodyFatLog,
          PrefetchHooks Function()
        > {
  $$BodyFatLogsTableTableManager(_$AppDatabase db, $BodyFatLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyFatLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyFatLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyFatLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<double> bodyFatPercent = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => BodyFatLogsCompanion(
                id: id,
                logDate: logDate,
                bodyFatPercent: bodyFatPercent,
                method: method,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime logDate,
                required double bodyFatPercent,
                Value<String> method = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => BodyFatLogsCompanion.insert(
                id: id,
                logDate: logDate,
                bodyFatPercent: bodyFatPercent,
                method: method,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BodyFatLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BodyFatLogsTable,
      BodyFatLog,
      $$BodyFatLogsTableFilterComposer,
      $$BodyFatLogsTableOrderingComposer,
      $$BodyFatLogsTableAnnotationComposer,
      $$BodyFatLogsTableCreateCompanionBuilder,
      $$BodyFatLogsTableUpdateCompanionBuilder,
      (
        BodyFatLog,
        BaseReferences<_$AppDatabase, $BodyFatLogsTable, BodyFatLog>,
      ),
      BodyFatLog,
      PrefetchHooks Function()
    >;
typedef $$ExpenseCategoriesTableCreateCompanionBuilder =
    ExpenseCategoriesCompanion Function({
      Value<int> id,
      required String name,
      required String icon,
      Value<String?> color,
      Value<bool> isFoodRelated,
    });
typedef $$ExpenseCategoriesTableUpdateCompanionBuilder =
    ExpenseCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> icon,
      Value<String?> color,
      Value<bool> isFoodRelated,
    });

final class $$ExpenseCategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ExpenseCategoriesTable,
          ExpenseCategory
        > {
  $$ExpenseCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: $_aliasNameGenerator(
      db.expenseCategories.id,
      db.expenses.categoryId,
    ),
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExpenseCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFoodRelated => $composableBuilder(
    column: $table.isFoodRelated,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpenseCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFoodRelated => $composableBuilder(
    column: $table.isFoodRelated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpenseCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isFoodRelated => $composableBuilder(
    column: $table.isFoodRelated,
    builder: (column) => column,
  );

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExpenseCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseCategoriesTable,
          ExpenseCategory,
          $$ExpenseCategoriesTableFilterComposer,
          $$ExpenseCategoriesTableOrderingComposer,
          $$ExpenseCategoriesTableAnnotationComposer,
          $$ExpenseCategoriesTableCreateCompanionBuilder,
          $$ExpenseCategoriesTableUpdateCompanionBuilder,
          (ExpenseCategory, $$ExpenseCategoriesTableReferences),
          ExpenseCategory,
          PrefetchHooks Function({bool expensesRefs})
        > {
  $$ExpenseCategoriesTableTableManager(
    _$AppDatabase db,
    $ExpenseCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<bool> isFoodRelated = const Value.absent(),
              }) => ExpenseCategoriesCompanion(
                id: id,
                name: name,
                icon: icon,
                color: color,
                isFoodRelated: isFoodRelated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String icon,
                Value<String?> color = const Value.absent(),
                Value<bool> isFoodRelated = const Value.absent(),
              }) => ExpenseCategoriesCompanion.insert(
                id: id,
                name: name,
                icon: icon,
                color: color,
                isFoodRelated: isFoodRelated,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpenseCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<
                      ExpenseCategory,
                      $ExpenseCategoriesTable,
                      Expense
                    >(
                      currentTable: table,
                      referencedTable: $$ExpenseCategoriesTableReferences
                          ._expensesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ExpenseCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).expensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExpenseCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseCategoriesTable,
      ExpenseCategory,
      $$ExpenseCategoriesTableFilterComposer,
      $$ExpenseCategoriesTableOrderingComposer,
      $$ExpenseCategoriesTableAnnotationComposer,
      $$ExpenseCategoriesTableCreateCompanionBuilder,
      $$ExpenseCategoriesTableUpdateCompanionBuilder,
      (ExpenseCategory, $$ExpenseCategoriesTableReferences),
      ExpenseCategory,
      PrefetchHooks Function({bool expensesRefs})
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required DateTime logDate,
      required int categoryId,
      required double amount,
      Value<String?> description,
      Value<int?> linkedFoodLogId,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<DateTime> logDate,
      Value<int> categoryId,
      Value<double> amount,
      Value<String?> description,
      Value<int?> linkedFoodLogId,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExpenseCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.expenseCategories.createAlias(
        $_aliasNameGenerator(db.expenses.categoryId, db.expenseCategories.id),
      );

  $$ExpenseCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$ExpenseCategoriesTableTableManager(
      $_db,
      $_db.expenseCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FoodLogsTable _linkedFoodLogIdTable(_$AppDatabase db) =>
      db.foodLogs.createAlias(
        $_aliasNameGenerator(db.expenses.linkedFoodLogId, db.foodLogs.id),
      );

  $$FoodLogsTableProcessedTableManager? get linkedFoodLogId {
    final $_column = $_itemColumn<int>('linked_food_log_id');
    if ($_column == null) return null;
    final manager = $$FoodLogsTableTableManager(
      $_db,
      $_db.foodLogs,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_linkedFoodLogIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
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

  ColumnFilters<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  $$ExpenseCategoriesTableFilterComposer get categoryId {
    final $$ExpenseCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.expenseCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.expenseCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodLogsTableFilterComposer get linkedFoodLogId {
    final $$FoodLogsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedFoodLogId,
      referencedTable: $db.foodLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodLogsTableFilterComposer(
            $db: $db,
            $table: $db.foodLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get logDate => $composableBuilder(
    column: $table.logDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$ExpenseCategoriesTableOrderingComposer get categoryId {
    final $$ExpenseCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.expenseCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpenseCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.expenseCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodLogsTableOrderingComposer get linkedFoodLogId {
    final $$FoodLogsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedFoodLogId,
      referencedTable: $db.foodLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodLogsTableOrderingComposer(
            $db: $db,
            $table: $db.foodLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get logDate =>
      $composableBuilder(column: $table.logDate, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  $$ExpenseCategoriesTableAnnotationComposer get categoryId {
    final $$ExpenseCategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.categoryId,
          referencedTable: $db.expenseCategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ExpenseCategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.expenseCategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$FoodLogsTableAnnotationComposer get linkedFoodLogId {
    final $$FoodLogsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.linkedFoodLogId,
      referencedTable: $db.foodLogs,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodLogsTableAnnotationComposer(
            $db: $db,
            $table: $db.foodLogs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, $$ExpensesTableReferences),
          Expense,
          PrefetchHooks Function({bool categoryId, bool linkedFoodLogId})
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> logDate = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int?> linkedFoodLogId = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                logDate: logDate,
                categoryId: categoryId,
                amount: amount,
                description: description,
                linkedFoodLogId: linkedFoodLogId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime logDate,
                required int categoryId,
                required double amount,
                Value<String?> description = const Value.absent(),
                Value<int?> linkedFoodLogId = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                logDate: logDate,
                categoryId: categoryId,
                amount: amount,
                description: description,
                linkedFoodLogId: linkedFoodLogId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, linkedFoodLogId = false}) {
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
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (linkedFoodLogId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.linkedFoodLogId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._linkedFoodLogIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._linkedFoodLogIdTable(db)
                                        .id,
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

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, $$ExpensesTableReferences),
      Expense,
      PrefetchHooks Function({bool categoryId, bool linkedFoodLogId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$ExerciseLogsTableTableManager get exerciseLogs =>
      $$ExerciseLogsTableTableManager(_db, _db.exerciseLogs);
  $$FoodsTableTableManager get foods =>
      $$FoodsTableTableManager(_db, _db.foods);
  $$FoodLogsTableTableManager get foodLogs =>
      $$FoodLogsTableTableManager(_db, _db.foodLogs);
  $$SupplementsTableTableManager get supplements =>
      $$SupplementsTableTableManager(_db, _db.supplements);
  $$SupplementLogsTableTableManager get supplementLogs =>
      $$SupplementLogsTableTableManager(_db, _db.supplementLogs);
  $$AlcoholLogsTableTableManager get alcoholLogs =>
      $$AlcoholLogsTableTableManager(_db, _db.alcoholLogs);
  $$CaloriePlansTableTableManager get caloriePlans =>
      $$CaloriePlansTableTableManager(_db, _db.caloriePlans);
  $$CaloriePlanWeeksTableTableManager get caloriePlanWeeks =>
      $$CaloriePlanWeeksTableTableManager(_db, _db.caloriePlanWeeks);
  $$DailyEnergyLogsTableTableManager get dailyEnergyLogs =>
      $$DailyEnergyLogsTableTableManager(_db, _db.dailyEnergyLogs);
  $$BmrProfilesTableTableManager get bmrProfiles =>
      $$BmrProfilesTableTableManager(_db, _db.bmrProfiles);
  $$WeightLogsTableTableManager get weightLogs =>
      $$WeightLogsTableTableManager(_db, _db.weightLogs);
  $$BodyFatLogsTableTableManager get bodyFatLogs =>
      $$BodyFatLogsTableTableManager(_db, _db.bodyFatLogs);
  $$ExpenseCategoriesTableTableManager get expenseCategories =>
      $$ExpenseCategoriesTableTableManager(_db, _db.expenseCategories);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
}
