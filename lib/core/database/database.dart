import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// ============================================================================
// EXERCISE TABLES
// ============================================================================

class Exercises extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get category => text()(); // Push, Pull, Legs, Cardio
  TextColumn get muscleGroup => text().nullable()();
  BoolColumn get isCardio => boolean().withDefault(const Constant(false))();
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
}

class AlcoholLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get logDate => dateTime()();
  TextColumn get drinkType => text()(); // beer, wine, whiskey, etc.
  RealColumn get units => real()(); // standard drink units
  RealColumn get calories => real()();
  RealColumn get volumeMl => real().nullable()();
}

// ============================================================================
// BODY TRACKING TABLES
// ============================================================================

class WeightLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get logDate => dateTime()();
  RealColumn get weightKg => real()();
  TextColumn get notes => text().nullable()();
}

class BodyFatLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get logDate => dateTime()();
  RealColumn get bodyFatPercent => real()();
  TextColumn get method => text().withDefault(const Constant('estimate'))(); // scale, caliper, dexa, estimate
  TextColumn get notes => text().nullable()();
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
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _seedInitialData();
      },
    );
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
      ExercisesCompanion.insert(name: 'Bench Press', category: 'Push', muscleGroup: const Value('Chest')),
      ExercisesCompanion.insert(name: 'Incline Bench Press', category: 'Push', muscleGroup: const Value('Upper Chest')),
      ExercisesCompanion.insert(name: 'Overhead Press', category: 'Push', muscleGroup: const Value('Shoulders')),
      ExercisesCompanion.insert(name: 'Dumbbell Shoulder Press', category: 'Push', muscleGroup: const Value('Shoulders')),
      ExercisesCompanion.insert(name: 'Tricep Pushdown', category: 'Push', muscleGroup: const Value('Triceps')),
      ExercisesCompanion.insert(name: 'Dips', category: 'Push', muscleGroup: const Value('Chest/Triceps')),
      // Pull
      ExercisesCompanion.insert(name: 'Deadlift', category: 'Pull', muscleGroup: const Value('Back/Hamstrings')),
      ExercisesCompanion.insert(name: 'Pull-ups', category: 'Pull', muscleGroup: const Value('Back')),
      ExercisesCompanion.insert(name: 'Barbell Row', category: 'Pull', muscleGroup: const Value('Back')),
      ExercisesCompanion.insert(name: 'Lat Pulldown', category: 'Pull', muscleGroup: const Value('Lats')),
      ExercisesCompanion.insert(name: 'Bicep Curls', category: 'Pull', muscleGroup: const Value('Biceps')),
      ExercisesCompanion.insert(name: 'Face Pulls', category: 'Pull', muscleGroup: const Value('Rear Delts')),
      // Legs
      ExercisesCompanion.insert(name: 'Squat', category: 'Legs', muscleGroup: const Value('Quads/Glutes')),
      ExercisesCompanion.insert(name: 'Leg Press', category: 'Legs', muscleGroup: const Value('Quads')),
      ExercisesCompanion.insert(name: 'Romanian Deadlift', category: 'Legs', muscleGroup: const Value('Hamstrings')),
      ExercisesCompanion.insert(name: 'Leg Curl', category: 'Legs', muscleGroup: const Value('Hamstrings')),
      ExercisesCompanion.insert(name: 'Leg Extension', category: 'Legs', muscleGroup: const Value('Quads')),
      ExercisesCompanion.insert(name: 'Calf Raises', category: 'Legs', muscleGroup: const Value('Calves')),
      // Cardio
      ExercisesCompanion.insert(name: 'Running', category: 'Cardio', isCardio: const Value(true)),
      ExercisesCompanion.insert(name: 'Cycling', category: 'Cardio', isCardio: const Value(true)),
      ExercisesCompanion.insert(name: 'Swimming', category: 'Cardio', isCardio: const Value(true)),
      ExercisesCompanion.insert(name: 'Jump Rope', category: 'Cardio', isCardio: const Value(true)),
      ExercisesCompanion.insert(name: 'Rowing', category: 'Cardio', isCardio: const Value(true)),
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

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'forge.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
