import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart'; // for databaseProvider
import '../data/repositories/calorie_planning_repository.dart';
import '../data/repositories/food_repository.dart';

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return FoodRepository(db);
});

final caloriePlanningRepositoryProvider = Provider<CaloriePlanningRepository>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return CaloriePlanningRepository(db);
});
