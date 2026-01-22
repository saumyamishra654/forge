import 'package:drift/drift.dart';
import '../../../../core/database/database.dart';

/// Data class for food efficiency metrics
class FoodEfficiencyItem {
  final String foodName;
  final double value; // protein per rupee or calories per rupee
  final double amount; // cost in rupees
  
  FoodEfficiencyItem({
    required this.foodName,
    required this.value,
    required this.amount,
  });
}

/// Data class for protein percentage metrics
class FoodProteinPercent {
  final String foodName;
  final double proteinPercent; // (protein * 4) / calories
  final double protein;
  final double calories;
  
  FoodProteinPercent({
    required this.foodName,
    required this.proteinPercent,
    required this.protein,
    required this.calories,
  });
}

class InsightsRepository {
  final AppDatabase db;
  
  InsightsRepository(this.db);

  // ============================================================================
  // FINANCE INSIGHTS
  // ============================================================================

  /// Calculate average cost per 100 calories
  Future<double?> getCostPerCalorie({DateTime? start, DateTime? end}) async {
    final query = db.selectOnly(db.foodLogs).join([
      innerJoin(db.foods, db.foods.id.equalsExp(db.foodLogs.foodId)),
      innerJoin(db.expenses, db.expenses.linkedFoodLogId.equalsExp(db.foodLogs.id)),
    ]);

    if (start != null) {
      query.where(db.foodLogs.logDate.isBiggerOrEqualValue(start));
    }
    if (end != null) {
      query.where(db.foodLogs.logDate.isSmallerOrEqualValue(end));
    }

    query.addColumns([
      db.foods.calories.sum(),
      db.expenses.amount.sum(),
    ]);

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    final totalCal = result.read(db.foods.calories.sum()) ?? 0;
    final totalCost = result.read(db.expenses.amount.sum()) ?? 0;

    if (totalCal == 0) return null;
    return (totalCost / totalCal) * 100; // Cost per 100 kcal
  }

  /// Calculate average cost per 10g protein
  Future<double?> getCostPerProtein({DateTime? start, DateTime? end}) async {
    final query = db.selectOnly(db.foodLogs).join([
      innerJoin(db.foods, db.foods.id.equalsExp(db.foodLogs.foodId)),
      innerJoin(db.expenses, db.expenses.linkedFoodLogId.equalsExp(db.foodLogs.id)),
    ]);

    if (start != null) {
      query.where(db.foodLogs.logDate.isBiggerOrEqualValue(start));
    }
    if (end != null) {
      query.where(db.foodLogs.logDate.isSmallerOrEqualValue(end));
    }

    query.addColumns([
      db.foods.protein.sum(),
      db.expenses.amount.sum(),
    ]);

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    final totalProtein = result.read(db.foods.protein.sum()) ?? 0;
    final totalCost = result.read(db.expenses.amount.sum()) ?? 0;

    if (totalProtein == 0) return null;
    return (totalCost / totalProtein) * 10; // Cost per 10g protein
  }

  // ============================================================================
  // FOOD EFFICIENCY INSIGHTS (Personalized)
  // ============================================================================

  /// Get foods with best protein per rupee (highest value = best)
  Future<List<FoodEfficiencyItem>> getBestProteinPerRupee({int limit = 3}) async {
    // We need foods that have been logged AND have linked expenses
    final query = db.selectOnly(db.foodLogs).join([
      innerJoin(db.foods, db.foods.id.equalsExp(db.foodLogs.foodId)),
      innerJoin(db.expenses, db.expenses.linkedFoodLogId.equalsExp(db.foodLogs.id)),
    ]);

    query.addColumns([
      db.foods.name,
      db.foods.protein,
      db.expenses.amount,
    ]);

    // Filter out zero-cost items
    query.where(db.expenses.amount.isBiggerThanValue(0));

    final results = await query.get();

    // Calculate protein per rupee for each result
    final items = results.map((row) {
      final name = row.read(db.foods.name) ?? 'Unknown';
      final protein = row.read(db.foods.protein) ?? 0;
      final amount = row.read(db.expenses.amount) ?? 1;
      
      return FoodEfficiencyItem(
        foodName: name,
        value: protein / amount, // protein per rupee
        amount: amount,
      );
    }).toList();

    // Sort by value descending and take top N
    items.sort((a, b) => b.value.compareTo(a.value));
    return items.take(limit).toList();
  }

  /// Get foods with best calories per rupee (highest value = best)
  Future<List<FoodEfficiencyItem>> getBestCaloriesPerRupee({int limit = 3}) async {
    final query = db.selectOnly(db.foodLogs).join([
      innerJoin(db.foods, db.foods.id.equalsExp(db.foodLogs.foodId)),
      innerJoin(db.expenses, db.expenses.linkedFoodLogId.equalsExp(db.foodLogs.id)),
    ]);

    query.addColumns([
      db.foods.name,
      db.foods.calories,
      db.expenses.amount,
    ]);

    query.where(db.expenses.amount.isBiggerThanValue(0));

    final results = await query.get();

    final items = results.map((row) {
      final name = row.read(db.foods.name) ?? 'Unknown';
      final calories = row.read(db.foods.calories) ?? 0;
      final amount = row.read(db.expenses.amount) ?? 1;
      
      return FoodEfficiencyItem(
        foodName: name,
        value: calories / amount, // calories per rupee
        amount: amount,
      );
    }).toList();

    items.sort((a, b) => b.value.compareTo(a.value));
    return items.take(limit).toList();
  }

  // ============================================================================
  // MACRO BREAKDOWN INSIGHTS
  // ============================================================================

  /// Get food with highest protein percentage (protein calories / total calories)
  Future<FoodProteinPercent?> getHighestProteinPercent() async {
    // Query all logged foods
    final foods = await (db.select(db.foods)
      ..where((f) => f.calories.isBiggerThanValue(0)))
      .get();

    if (foods.isEmpty) return null;

    Food? bestFood;
    double bestPercent = 0;

    for (final food in foods) {
      final proteinCalories = food.protein * 4;
      final percent = proteinCalories / food.calories;
      
      if (percent > bestPercent) {
        bestPercent = percent;
        bestFood = food;
      }
    }

    if (bestFood == null) return null;

    return FoodProteinPercent(
      foodName: bestFood.name,
      proteinPercent: bestPercent * 100,
      protein: bestFood.protein,
      calories: bestFood.calories,
    );
  }

  /// Get food with lowest protein percentage
  Future<FoodProteinPercent?> getLowestProteinPercent() async {
    final foods = await (db.select(db.foods)
      ..where((f) => f.calories.isBiggerThanValue(0)))
      .get();

    if (foods.isEmpty) return null;

    Food? worstFood;
    double worstPercent = double.infinity;

    for (final food in foods) {
      final proteinCalories = food.protein * 4;
      final percent = proteinCalories / food.calories;
      
      if (percent < worstPercent) {
        worstPercent = percent;
        worstFood = food;
      }
    }

    if (worstFood == null) return null;

    return FoodProteinPercent(
      foodName: worstFood.name,
      proteinPercent: worstPercent * 100,
      protein: worstFood.protein,
      calories: worstFood.calories,
    );
  }
}
