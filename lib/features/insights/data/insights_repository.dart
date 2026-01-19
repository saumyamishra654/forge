import 'package:drift/drift.dart';
import '../../../core/database/database.dart';

/// Repository for calculating cross-domain insights
class InsightsRepository {
  final AppDatabase db;
  
  InsightsRepository(this.db);

  /// Get insights for a date range (default: last 7 days)
  Future<CrossDomainInsights> getInsights({int days = 7}) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    
    // Get food expenses (categories marked as food-related)
    final foodExpenses = await _getFoodExpenses(startDate, endDate);
    final totalFoodSpend = foodExpenses.fold<double>(0, (sum, e) => sum + e.amount);
    
    // Get total calories from food logs
    final totalCalories = await _getTotalCalories(startDate, endDate);
    final totalProtein = await _getTotalProtein(startDate, endDate);
    
    // Get exercise stats
    final workoutCount = await _getWorkoutCount(startDate, endDate);
    final fitnessSpend = await _getFitnessSpend(startDate, endDate);
    
    // Calculate metrics
    final rupeePerCalorie = totalCalories > 0 ? totalFoodSpend / totalCalories : 0.0;
    final rupeePerProtein = totalProtein > 0 ? totalFoodSpend / totalProtein : 0.0;
    final rupeePerWorkout = workoutCount > 0 ? fitnessSpend / workoutCount : 0.0;
    
    return CrossDomainInsights(
      totalFoodSpend: totalFoodSpend,
      totalCalories: totalCalories,
      totalProtein: totalProtein,
      rupeePerCalorie: rupeePerCalorie,
      rupeePerProtein: rupeePerProtein,
      rupeePerWorkout: rupeePerWorkout,
      workoutCount: workoutCount,
      fitnessSpend: fitnessSpend,
      daysAnalyzed: days,
    );
  }

  Future<List<Expense>> _getFoodExpenses(DateTime start, DateTime end) async {
    // Get food-related category IDs
    final foodCategories = await (db.select(db.expenseCategories)
      ..where((t) => t.isFoodRelated.equals(true)))
      .get();
    
    if (foodCategories.isEmpty) return [];
    
    final categoryIds = foodCategories.map((c) => c.id).toList();
    
    final expenses = await (db.select(db.expenses)
      ..where((t) => t.logDate.isBiggerOrEqualValue(start) & 
                     t.logDate.isSmallerThanValue(end)))
      .get();
    
    return expenses.where((e) => categoryIds.contains(e.categoryId)).toList();
  }

  Future<double> _getTotalCalories(DateTime start, DateTime end) async {
    final logs = await (db.select(db.foodLogs)
      ..where((t) => t.logDate.isBiggerOrEqualValue(start) & 
                     t.logDate.isSmallerThanValue(end)))
      .get();
    
    double total = 0;
    for (final log in logs) {
      final food = await (db.select(db.foods)
        ..where((t) => t.id.equals(log.foodId)))
        .getSingleOrNull();
      if (food != null) {
        total += food.calories * log.servings;
      }
    }
    
    return total;
  }

  Future<double> _getTotalProtein(DateTime start, DateTime end) async {
    final logs = await (db.select(db.foodLogs)
      ..where((t) => t.logDate.isBiggerOrEqualValue(start) & 
                     t.logDate.isSmallerThanValue(end)))
      .get();
    
    double total = 0;
    for (final log in logs) {
      final food = await (db.select(db.foods)
        ..where((t) => t.id.equals(log.foodId)))
        .getSingleOrNull();
      if (food != null) {
        total += food.protein * log.servings;
      }
    }
    
    return total;
  }

  Future<int> _getWorkoutCount(DateTime start, DateTime end) async {
    final logs = await (db.select(db.exerciseLogs)
      ..where((t) => t.logDate.isBiggerOrEqualValue(start) & 
                     t.logDate.isSmallerThanValue(end)))
      .get();
    
    // Count unique dates with workouts
    final uniqueDates = logs.map((l) => 
      DateTime(l.logDate.year, l.logDate.month, l.logDate.day)
    ).toSet();
    
    return uniqueDates.length;
  }

  Future<double> _getFitnessSpend(DateTime start, DateTime end) async {
    // Get fitness category
    final fitnessCategory = await (db.select(db.expenseCategories)
      ..where((t) => t.name.equals('Fitness')))
      .getSingleOrNull();
    
    if (fitnessCategory == null) return 0;
    
    final expenses = await (db.select(db.expenses)
      ..where((t) => t.categoryId.equals(fitnessCategory.id) &
                     t.logDate.isBiggerOrEqualValue(start) & 
                     t.logDate.isSmallerThanValue(end)))
      .get();
    
    return expenses.fold<double>(0, (sum, e) => sum + e.amount);
  }

  /// Get a motivational insight based on the data
  String getInsightMessage(CrossDomainInsights insights) {
    if (insights.totalCalories == 0 && insights.workoutCount == 0) {
      return 'Start tracking food and workouts to unlock insights!';
    }
    
    if (insights.rupeePerCalorie > 0 && insights.rupeePerCalorie < 0.5) {
      return 'Great value! You\'re spending less than ₹0.50 per calorie.';
    }
    
    if (insights.rupeePerProtein > 0 && insights.rupeePerProtein < 10) {
      return 'Excellent protein value! Under ₹10 per gram of protein.';
    }
    
    if (insights.workoutCount >= 5) {
      return 'Crushing it! ${insights.workoutCount} workouts in ${insights.daysAnalyzed} days.';
    }
    
    if (insights.workoutCount > 0) {
      return 'Keep going! Each workout costs ₹${insights.rupeePerWorkout.toStringAsFixed(0)}.';
    }
    
    return 'Track both food expenses and workouts to see your ROI!';
  }
}

/// Cross-domain insights data class
class CrossDomainInsights {
  final double totalFoodSpend;
  final double totalCalories;
  final double totalProtein;
  final double rupeePerCalorie;
  final double rupeePerProtein;
  final double rupeePerWorkout;
  final int workoutCount;
  final double fitnessSpend;
  final int daysAnalyzed;

  CrossDomainInsights({
    required this.totalFoodSpend,
    required this.totalCalories,
    required this.totalProtein,
    required this.rupeePerCalorie,
    required this.rupeePerProtein,
    required this.rupeePerWorkout,
    required this.workoutCount,
    required this.fitnessSpend,
    required this.daysAnalyzed,
  });
  
  bool get hasData => totalCalories > 0 || workoutCount > 0 || totalFoodSpend > 0;
}
