import 'connection/connection.dart' as impl;
import 'package:drift/drift.dart';

part 'database.g.dart';

// EXERCISE TABLES
// ============================================================================

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get category => text()(); // Push, Pull, Legs, Cardio
  TextColumn get muscleGroup => text().nullable()(); // Comma-separated: "Chest,Shoulders,Triceps"
  BoolColumn get isCardio => boolean().withDefault(const Constant(false))();
  TextColumn get cardioType => text().nullable()(); // LISS, HIIT, or null for non-cardio
}

class ExerciseLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get logDate => dateTime()();
  IntColumn get exerciseId => integer().references(Exercises, #id)();
  IntColumn get sets => integer().nullable()();
  IntColumn get reps => integer().nullable()();
  RealColumn get weight => real().nullable()(); // in kg
  // Cardio specific
  IntColumn get durationMinutes => integer().nullable()();
  RealColumn get distanceKm => real().nullable()();
  TextColumn get notes => text().nullable()();
  // Sync columns
  TextColumn get remoteId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))(); // 0=local, 1=syncing, 2=synced
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

// ============================================================================
// FOOD & NUTRITION TABLES
// ============================================================================

class Foods extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get barcode => text().nullable()();
  RealColumn get calories => real()(); // per serving
  RealColumn get protein => real()(); // grams
  RealColumn get carbs => real()(); // grams
  RealColumn get fat => real()(); // grams
  RealColumn get fiber => real().nullable()();
  RealColumn get sugar => real().nullable()();
  RealColumn get servingSize => real().withDefault(const Constant(100))(); // grams
  TextColumn get servingUnit => text().withDefault(const Constant('g'))();
  TextColumn get source => text().withDefault(const Constant('custom'))(); // openfoodfacts, usda, user_contributed, custom
  TextColumn get imageUrl => text().nullable()();
  BoolColumn get verified => boolean().withDefault(const Constant(false))();
  TextColumn get createdBy => text().nullable()(); // user id for contributed foods
}

class FoodLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get logDate => dateTime()();
  IntColumn get foodId => integer().references(Foods, #id)();
  RealColumn get servings => real().withDefault(const Constant(1))();
  TextColumn get mealType => text()(); // breakfast, lunch, dinner, snack
  // Sync columns
  TextColumn get remoteId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

class Supplements extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get type => text()(); // vitamin, mineral, protein, other
  TextColumn get dosageUnit => text().withDefault(const Constant('mg'))();
}

class SupplementLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get logDate => dateTime()();
  IntColumn get supplementId => integer().references(Supplements, #id)();
  RealColumn get dosage => real()();
  // Sync columns
  TextColumn get remoteId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

class AlcoholLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get logDate => dateTime()();
  TextColumn get drinkType => text()(); // beer, wine, whiskey, etc.
  RealColumn get units => real()(); // standard drink units
  RealColumn get calories => real()();
  RealColumn get volumeMl => real().nullable()();
  // Sync columns
  TextColumn get remoteId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

// ============================================================================
// BODY TRACKING TABLES
// ============================================================================

class WeightLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get logDate => dateTime()();
  RealColumn get weightKg => real()();
  TextColumn get notes => text().nullable()();
  // Sync columns
  TextColumn get remoteId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

class BodyFatLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get logDate => dateTime()();
  RealColumn get bodyFatPercent => real()();
  TextColumn get method => text().withDefault(const Constant('estimate'))(); // scale, caliper, dexa, estimate
  TextColumn get notes => text().nullable()();
  // Sync columns
  TextColumn get remoteId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

// ============================================================================
// FINANCE TABLES
// ============================================================================

class ExpenseCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get icon => text()(); // emoji or icon name
  TextColumn get color => text().nullable()(); // hex color
  BoolColumn get isFoodRelated => boolean().withDefault(const Constant(false))();
}

class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get logDate => dateTime()();
  IntColumn get categoryId => integer().references(ExpenseCategories, #id)();
  RealColumn get amount => real()(); // in rupees
  TextColumn get description => text().nullable()();
  IntColumn get linkedFoodLogId => integer().nullable().references(FoodLogs, #id)(); // for cross-domain linking
  // Sync columns
  TextColumn get remoteId => text().nullable()();
  IntColumn get syncStatus => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

// ============================================================================
// SYNC QUEUE TABLE
// ============================================================================

/// Tracks pending sync operations for offline-first architecture
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get targetTable => text()();  // e.g. 'exerciseLogs', 'foodLogs'
  IntColumn get recordId => integer()(); // ID of the record in that table
  TextColumn get action => text()();     // 'create', 'update', 'delete'
  DateTimeColumn get queuedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
}

// ============================================================================
// DATABASE CLASS
// ============================================================================

@DriftDatabase(tables: [
  Exercises,
  ExerciseLogs,
  Foods,
  FoodLogs,
  Supplements,
  SupplementLogs,
  AlcoholLogs,
  WeightLogs,
  BodyFatLogs,
  ExpenseCategories,
  Expenses,
  SyncQueue,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(impl.connect());

  @override
  int get schemaVersion => 2; // Bumped for sync columns

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedInitialData();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Migration from v1 to v2: Add sync columns to all log tables
        if (from < 2) {
          await _addSyncColumnsIfNeeded();
          
          // Create SyncQueue table if it doesn't exist
          try {
            await m.createTable(syncQueue);
          } catch (e) {
            // Table might already exist from partial migration
            print('SyncQueue table already exists or error: $e');
          }
        }
      },
    );
  }

  /// Idempotent helper to add sync columns - skips if column already exists
  Future<void> _addSyncColumnsIfNeeded() async {
    final tables = [
      'exercise_logs',
      'food_logs', 
      'supplement_logs',
      'alcohol_logs',
      'weight_logs',
      'body_fat_logs',
      'expenses',
    ];
    
    final columns = [
      ('remote_id', 'TEXT'),
      ('sync_status', 'INTEGER NOT NULL DEFAULT 0'),
      ('created_at', 'INTEGER NOT NULL DEFAULT 0'),
      ('updated_at', 'INTEGER NOT NULL DEFAULT 0'),
      ('is_deleted', 'INTEGER NOT NULL DEFAULT 0'),
    ];
    
    for (final table in tables) {
      for (final (colName, colDef) in columns) {
        try {
          await customStatement('ALTER TABLE "$table" ADD COLUMN "$colName" $colDef');
        } catch (e) {
          // Column already exists - this is fine
          print('Column $colName on $table: ${e.toString().contains('duplicate') ? 'already exists' : e}');
        }
      }
      
      // Set createdAt/updatedAt to logDate for existing records (if they're still 0)
      try {
        await customStatement('UPDATE "$table" SET "created_at" = "log_date", "updated_at" = "log_date" WHERE "created_at" = 0');
      } catch (e) {
        print('Update timestamps for $table failed: $e');
      }
    }
  }

  /// One-time migration to update existing exercises with proper muscle groups and cardio types
  Future<void> _migrateExercisesOnce() async {
    // Map of exercise names to their updated data
    final updates = {
      // Push
      'Bench Press': {'muscleGroup': 'Chest,Triceps,Shoulders'},
      'Incline Bench Press': {'muscleGroup': 'Chest,Shoulders,Triceps'},
      'Overhead Press': {'muscleGroup': 'Shoulders,Triceps'},
      'Dumbbell Shoulder Press': {'muscleGroup': 'Shoulders,Triceps'},
      'Tricep Pushdown': {'muscleGroup': 'Triceps'},
      'Dips': {'muscleGroup': 'Chest,Triceps,Shoulders'},
      // Pull
      'Deadlift': {'muscleGroup': 'Back,Hamstrings,Glutes'},
      'Pull-ups': {'muscleGroup': 'Back,Biceps'},
      'Barbell Row': {'muscleGroup': 'Back,Biceps'},
      'Lat Pulldown': {'muscleGroup': 'Back,Biceps'},
      'Bicep Curls': {'muscleGroup': 'Biceps,Forearms'},
      'Face Pulls': {'muscleGroup': 'Shoulders,Back'},
      // Legs
      'Squat': {'muscleGroup': 'Quads,Glutes,Hamstrings'},
      'Leg Press': {'muscleGroup': 'Quads,Glutes'},
      'Romanian Deadlift': {'muscleGroup': 'Hamstrings,Glutes,Back'},
      'Leg Curl': {'muscleGroup': 'Hamstrings'},
      'Leg Extension': {'muscleGroup': 'Quads'},
      'Calf Raises': {'muscleGroup': 'Calves'},
      // Cardio - LISS
      'Running': {'cardioType': 'LISS'},
      'Cycling': {'cardioType': 'LISS'},
      'Swimming': {'cardioType': 'LISS'},
      'Walking': {'cardioType': 'LISS'},
      'Rowing': {'cardioType': 'LISS'},
      // Cardio - HIIT  
      'Jump Rope': {'cardioType': 'HIIT'},
      'Sprints': {'cardioType': 'HIIT'},
      'Burpees': {'cardioType': 'HIIT'},
      'Mountain Climbers': {'cardioType': 'HIIT'},
    };

    for (final entry in updates.entries) {
      final name = entry.key;
      final data = entry.value;
      
      await (update(exercises)..where((e) => e.name.equals(name))).write(
        ExercisesCompanion(
          muscleGroup: data.containsKey('muscleGroup') 
              ? Value(data['muscleGroup']) 
              : const Value.absent(),
          cardioType: data.containsKey('cardioType') 
              ? Value(data['cardioType']) 
              : const Value.absent(),
        ),
      );
    }
  }

  Future<void> _seedInitialData() async {
    // Seed default exercise categories
    await _seedExercises();
    // Seed expense categories
    await _seedExpenseCategories();
    // Seed common Indian foods
    await _seedIndianFoods();
    // Seed common supplements
    await _seedSupplements();
  }

  Future<void> _seedExercises() async {
    final exercises = [
      // Push
      ExercisesCompanion.insert(name: 'Bench Press', category: 'Push', muscleGroup: const Value('Chest,Triceps,Shoulders')),
      ExercisesCompanion.insert(name: 'Incline Bench Press', category: 'Push', muscleGroup: const Value('Chest,Shoulders,Triceps')),
      ExercisesCompanion.insert(name: 'Overhead Press', category: 'Push', muscleGroup: const Value('Shoulders,Triceps')),
      ExercisesCompanion.insert(name: 'Dumbbell Shoulder Press', category: 'Push', muscleGroup: const Value('Shoulders,Triceps')),
      ExercisesCompanion.insert(name: 'Tricep Pushdown', category: 'Push', muscleGroup: const Value('Triceps')),
      ExercisesCompanion.insert(name: 'Dips', category: 'Push', muscleGroup: const Value('Chest,Triceps,Shoulders')),
      // Pull
      ExercisesCompanion.insert(name: 'Deadlift', category: 'Pull', muscleGroup: const Value('Back,Hamstrings,Glutes')),
      ExercisesCompanion.insert(name: 'Pull-ups', category: 'Pull', muscleGroup: const Value('Back,Biceps')),
      ExercisesCompanion.insert(name: 'Barbell Row', category: 'Pull', muscleGroup: const Value('Back,Biceps')),
      ExercisesCompanion.insert(name: 'Lat Pulldown', category: 'Pull', muscleGroup: const Value('Back,Biceps')),
      ExercisesCompanion.insert(name: 'Bicep Curls', category: 'Pull', muscleGroup: const Value('Biceps,Forearms')),
      ExercisesCompanion.insert(name: 'Face Pulls', category: 'Pull', muscleGroup: const Value('Shoulders,Back')),
      // Legs
      ExercisesCompanion.insert(name: 'Squat', category: 'Legs', muscleGroup: const Value('Quads,Glutes,Hamstrings')),
      ExercisesCompanion.insert(name: 'Leg Press', category: 'Legs', muscleGroup: const Value('Quads,Glutes')),
      ExercisesCompanion.insert(name: 'Romanian Deadlift', category: 'Legs', muscleGroup: const Value('Hamstrings,Glutes,Back')),
      ExercisesCompanion.insert(name: 'Leg Curl', category: 'Legs', muscleGroup: const Value('Hamstrings')),
      ExercisesCompanion.insert(name: 'Leg Extension', category: 'Legs', muscleGroup: const Value('Quads')),
      ExercisesCompanion.insert(name: 'Calf Raises', category: 'Legs', muscleGroup: const Value('Calves')),
      // Cardio - LISS
      ExercisesCompanion.insert(name: 'Running', category: 'Cardio', isCardio: const Value(true), cardioType: const Value('LISS')),
      ExercisesCompanion.insert(name: 'Cycling', category: 'Cardio', isCardio: const Value(true), cardioType: const Value('LISS')),
      ExercisesCompanion.insert(name: 'Swimming', category: 'Cardio', isCardio: const Value(true), cardioType: const Value('LISS')),
      ExercisesCompanion.insert(name: 'Walking', category: 'Cardio', isCardio: const Value(true), cardioType: const Value('LISS')),
      // Cardio - HIIT
      ExercisesCompanion.insert(name: 'Jump Rope', category: 'Cardio', isCardio: const Value(true), cardioType: const Value('HIIT')),
      ExercisesCompanion.insert(name: 'Sprints', category: 'Cardio', isCardio: const Value(true), cardioType: const Value('HIIT')),
      ExercisesCompanion.insert(name: 'Burpees', category: 'Cardio', isCardio: const Value(true), cardioType: const Value('HIIT')),
      ExercisesCompanion.insert(name: 'Mountain Climbers', category: 'Cardio', isCardio: const Value(true), cardioType: const Value('HIIT')),
      ExercisesCompanion.insert(name: 'Rowing', category: 'Cardio', isCardio: const Value(true), cardioType: const Value('HIIT'))

    ];
    await batch((batch) => batch.insertAll(this.exercises, exercises));
  }

  Future<void> _seedExpenseCategories() async {
    final categories = [
      ExpenseCategoriesCompanion.insert(name: 'Food & Dining', icon: '🍽️', isFoodRelated: const Value(true)),
      ExpenseCategoriesCompanion.insert(name: 'Groceries', icon: '🛒', isFoodRelated: const Value(true)),
      ExpenseCategoriesCompanion.insert(name: 'Supplements', icon: '💊', isFoodRelated: const Value(true)),
      ExpenseCategoriesCompanion.insert(name: 'Fitness', icon: '🏋️'),
      ExpenseCategoriesCompanion.insert(name: 'Transport', icon: '🚗'),
      ExpenseCategoriesCompanion.insert(name: 'Entertainment', icon: '🎬'),
      ExpenseCategoriesCompanion.insert(name: 'Utilities', icon: '🏠'),
      ExpenseCategoriesCompanion.insert(name: 'Shopping', icon: '🛍️'),
      ExpenseCategoriesCompanion.insert(name: 'Health', icon: '🏥'),
      ExpenseCategoriesCompanion.insert(name: 'Other', icon: '📦'),
    ];
    await batch((batch) => batch.insertAll(expenseCategories, categories));
  }

  Future<void> _seedIndianFoods() async {
    final foods = [
      // Staples
      FoodsCompanion.insert(name: 'White Rice (Cooked)', calories: 130, protein: 2.7, carbs: 28, fat: 0.3, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Roti (Wheat)', calories: 71, protein: 2.7, carbs: 15, fat: 0.4, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Paratha', calories: 260, protein: 6, carbs: 36, fat: 10, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Naan', calories: 262, protein: 8.7, carbs: 45, fat: 5.1, source: const Value('seed')),
      // Dals
      FoodsCompanion.insert(name: 'Dal (Yellow Lentils)', calories: 116, protein: 9, carbs: 20, fat: 0.4, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Chana Dal', calories: 164, protein: 8.9, carbs: 27, fat: 2.6, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Rajma (Kidney Beans)', calories: 127, protein: 8.7, carbs: 22.8, fat: 0.5, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Chole (Chickpeas)', calories: 164, protein: 8.9, carbs: 27, fat: 2.6, source: const Value('seed')),
      // Proteins
      FoodsCompanion.insert(name: 'Paneer', calories: 265, protein: 18.3, carbs: 1.2, fat: 20.8, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Chicken Breast', calories: 165, protein: 31, carbs: 0, fat: 3.6, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Egg (Whole)', calories: 155, protein: 13, carbs: 1.1, fat: 11, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Egg White', calories: 52, protein: 11, carbs: 0.7, fat: 0.2, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Mutton', calories: 294, protein: 25, carbs: 0, fat: 21, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Fish (Rohu)', calories: 97, protein: 16.6, carbs: 0, fat: 3.2, source: const Value('seed')),
      // Dairy
      FoodsCompanion.insert(name: 'Milk (Full Fat)', calories: 61, protein: 3.2, carbs: 4.8, fat: 3.3, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Curd/Yogurt', calories: 98, protein: 11, carbs: 3.4, fat: 4.3, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Lassi', calories: 72, protein: 2.9, carbs: 12, fat: 1.5, source: const Value('seed')),
      // Vegetables
      FoodsCompanion.insert(name: 'Aloo Sabzi', calories: 93, protein: 2, carbs: 18, fat: 2, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Palak (Spinach)', calories: 23, protein: 2.9, carbs: 3.6, fat: 0.4, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Bhindi (Okra)', calories: 33, protein: 1.9, carbs: 7, fat: 0.2, source: const Value('seed')),
      // Snacks
      FoodsCompanion.insert(name: 'Samosa', calories: 262, protein: 3.5, carbs: 24, fat: 17, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Pakora', calories: 175, protein: 4.5, carbs: 15, fat: 11, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Idli', calories: 39, protein: 2, carbs: 8, fat: 0.1, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Dosa', calories: 133, protein: 4, carbs: 19, fat: 5, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Upma', calories: 165, protein: 4, carbs: 26, fat: 5, source: const Value('seed')),
      FoodsCompanion.insert(name: 'Poha', calories: 158, protein: 3, carbs: 32, fat: 2, source: const Value('seed')),
    ];
    await batch((batch) => batch.insertAll(this.foods, foods));
  }

  Future<void> _seedSupplements() async {
    final supps = [
      SupplementsCompanion.insert(name: 'Whey Protein', type: 'protein', dosageUnit: const Value('scoop')),
      SupplementsCompanion.insert(name: 'Creatine', type: 'performance', dosageUnit: const Value('g')),
      SupplementsCompanion.insert(name: 'Vitamin D3', type: 'vitamin', dosageUnit: const Value('IU')),
      SupplementsCompanion.insert(name: 'Vitamin B12', type: 'vitamin', dosageUnit: const Value('mcg')),
      SupplementsCompanion.insert(name: 'Omega-3 Fish Oil', type: 'fatty_acid', dosageUnit: const Value('capsule')),
      SupplementsCompanion.insert(name: 'Zinc', type: 'mineral', dosageUnit: const Value('mg')),
      SupplementsCompanion.insert(name: 'Magnesium', type: 'mineral', dosageUnit: const Value('mg')),
      SupplementsCompanion.insert(name: 'Multivitamin', type: 'vitamin', dosageUnit: const Value('tablet')),
      SupplementsCompanion.insert(name: 'Ashwagandha', type: 'adaptogen', dosageUnit: const Value('mg')),
      SupplementsCompanion.insert(name: 'Caffeine', type: 'stimulant', dosageUnit: const Value('mg')),
    ];
    await batch((batch) => batch.insertAll(supplements, supps));
  }
}


