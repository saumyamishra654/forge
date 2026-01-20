import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../main.dart'; // for databaseProvider
import '../data/repositories/exercise_repository.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ExerciseRepository(db);
});
