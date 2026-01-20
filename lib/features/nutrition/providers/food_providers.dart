import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart'; // for databaseProvider
import '../data/food_repository.dart';

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return FoodRepository(db);
});
