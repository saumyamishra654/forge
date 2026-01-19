import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:drift/drift.dart';
import '../../../core/database/database.dart';

/// Repository for food search with fallback chain:
/// 1. Local Database
/// 2. OpenFoodFacts API
/// 3. USDA FoodData Central (future)
class FoodRepository {
  final AppDatabase db;
  
  FoodRepository(this.db);

  /// Search foods by name (local database first, then API)
  Future<List<FoodSearchResult>> searchFoods(String query) async {
    if (query.trim().isEmpty) return [];
    
    final results = <FoodSearchResult>[];
    
    // 1. Search local database
    final localFoods = await _searchLocalDatabase(query);
    results.addAll(localFoods.map((f) => FoodSearchResult(
      food: f,
      source: FoodSource.local,
    )));
    
    // 2. If less than 5 local results, search OpenFoodFacts
    if (results.length < 5) {
      final apiFoods = await _searchOpenFoodFacts(query);
      results.addAll(apiFoods);
    }
    
    return results;
  }

  /// Lookup food by barcode
  Future<FoodSearchResult?> lookupBarcode(String barcode) async {
    // 1. Check local database first
    final localFood = await _lookupLocalBarcode(barcode);
    if (localFood != null) {
      return FoodSearchResult(food: localFood, source: FoodSource.local);
    }
    
    // 2. Search OpenFoodFacts
    final apiFood = await _lookupOpenFoodFactsBarcode(barcode);
    if (apiFood != null) {
      return apiFood;
    }
    
    // 3. Not found
    return null;
  }

  /// Search local database
  Future<List<Food>> _searchLocalDatabase(String query) async {
    final searchTerm = '%${query.toLowerCase()}%';
    return await (db.select(db.foods)
      ..where((t) => t.name.contains(query))
      ..limit(10))
      .get();
  }

  /// Lookup barcode in local database
  Future<Food?> _lookupLocalBarcode(String barcode) async {
    final results = await (db.select(db.foods)
      ..where((t) => t.barcode.equals(barcode))
      ..limit(1))
      .get();
    return results.isNotEmpty ? results.first : null;
  }

  /// Search OpenFoodFacts API
  Future<List<FoodSearchResult>> _searchOpenFoodFacts(String query) async {
    try {
      final uri = Uri.parse(
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&action=process&json=1&page_size=10'
      );
      
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = data['products'] as List<dynamic>?;
        
        if (products == null) return [];
        
        return products.map((p) => _parseOpenFoodFactsProduct(p)).whereType<FoodSearchResult>().toList();
      }
    } catch (e) {
      // Silent fail - just return empty
    }
    return [];
  }

  /// Lookup barcode on OpenFoodFacts
  Future<FoodSearchResult?> _lookupOpenFoodFactsBarcode(String barcode) async {
    try {
      final uri = Uri.parse(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json'
      );
      
      final response = await http.get(uri).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1 && data['product'] != null) {
          return _parseOpenFoodFactsProduct(data['product']);
        }
      }
    } catch (e) {
      // Silent fail
    }
    return null;
  }

  /// Parse OpenFoodFacts product into FoodSearchResult
  FoodSearchResult? _parseOpenFoodFactsProduct(Map<String, dynamic> product) {
    try {
      final nutriments = product['nutriments'] as Map<String, dynamic>?;
      if (nutriments == null) return null;
      
      final name = product['product_name'] ?? product['product_name_en'] ?? 'Unknown';
      if (name == 'Unknown' || name.toString().trim().isEmpty) return null;
      
      final calories = _parseDouble(nutriments['energy-kcal_100g'] ?? nutriments['energy-kcal']);
      final protein = _parseDouble(nutriments['proteins_100g'] ?? nutriments['proteins']);
      final carbs = _parseDouble(nutriments['carbohydrates_100g'] ?? nutriments['carbohydrates']);
      final fat = _parseDouble(nutriments['fat_100g'] ?? nutriments['fat']);
      
      // Skip if no meaningful nutrition data
      if (calories == 0 && protein == 0 && carbs == 0 && fat == 0) return null;
      
      final food = Food(
        id: 0, // Temporary ID for API results
        name: name.toString().trim(),
        barcode: product['code']?.toString(),
        calories: calories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        fiber: _parseDouble(nutriments['fiber_100g']),
        sugar: _parseDouble(nutriments['sugars_100g']),
        servingSize: 100,
        servingUnit: 'g',
        source: 'openfoodfacts',
        imageUrl: product['image_url']?.toString(),
        verified: true,
        createdBy: null,
      );
      
      return FoodSearchResult(food: food, source: FoodSource.openFoodFacts);
    } catch (e) {
      return null;
    }
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  /// Save a food to local database (for user contributions or caching API results)
  Future<int> saveFood(Food food) async {
    return await db.into(db.foods).insert(
      FoodsCompanion.insert(
        name: food.name,
        barcode: Value(food.barcode),
        calories: food.calories,
        protein: food.protein,
        carbs: food.carbs,
        fat: food.fat,
        fiber: Value(food.fiber),
        sugar: Value(food.sugar),
        servingSize: Value(food.servingSize),
        servingUnit: Value(food.servingUnit),
        source: Value(food.source),
        imageUrl: Value(food.imageUrl),
        verified: Value(food.verified),
        createdBy: Value(food.createdBy),
      ),
    );
  }

  /// Log food consumption
  Future<void> logFood({
    required int foodId,
    required double servings,
    required String mealType,
    DateTime? logDate,
  }) async {
    await db.into(db.foodLogs).insert(
      FoodLogsCompanion.insert(
        logDate: logDate ?? DateTime.now(),
        foodId: foodId,
        servings: Value(servings),
        mealType: mealType,
      ),
    );
  }

  /// Get food logs for a specific date
  Future<List<FoodLogWithFood>> getFoodLogsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final logs = await (db.select(db.foodLogs)
      ..where((t) => t.logDate.isBiggerOrEqualValue(startOfDay) & t.logDate.isSmallerThanValue(endOfDay))
      ..orderBy([(t) => OrderingTerm.desc(t.logDate)]))
      .get();
    
    final result = <FoodLogWithFood>[];
    for (final log in logs) {
      final food = await (db.select(db.foods)
        ..where((t) => t.id.equals(log.foodId)))
        .getSingleOrNull();
      if (food != null) {
        result.add(FoodLogWithFood(log: log, food: food));
      }
    }
    
    return result;
  }

  /// Get today's macros summary
  Future<MacrosSummary> getTodaysMacros() async {
    final logs = await getFoodLogsForDate(DateTime.now());
    
    double calories = 0;
    double protein = 0;
    double carbs = 0;
    double fat = 0;
    
    for (final entry in logs) {
      final multiplier = entry.log.servings;
      calories += entry.food.calories * multiplier;
      protein += entry.food.protein * multiplier;
      carbs += entry.food.carbs * multiplier;
      fat += entry.food.fat * multiplier;
    }
    
    return MacrosSummary(
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
    );
  }
}

/// Food search result with source information
class FoodSearchResult {
  final Food food;
  final FoodSource source;
  
  FoodSearchResult({required this.food, required this.source});
}

/// Source of food data
enum FoodSource {
  local,
  openFoodFacts,
  usda,
  userContributed,
}

/// Food log with associated food details
class FoodLogWithFood {
  final FoodLog log;
  final Food food;
  
  FoodLogWithFood({required this.log, required this.food});
}

/// Today's macro summary
class MacrosSummary {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  
  MacrosSummary({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });
}
