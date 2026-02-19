import 'package:drift/drift.dart';

import '../../../../core/database/database.dart';

enum NutritionGoalType { maintain, gain, cut }

NutritionGoalType nutritionGoalTypeFromDb(String value) {
  switch (value) {
    case 'gain':
      return NutritionGoalType.gain;
    case 'cut':
      return NutritionGoalType.cut;
    case 'maintain':
    default:
      return NutritionGoalType.maintain;
  }
}

String nutritionGoalTypeToDb(NutritionGoalType value) {
  switch (value) {
    case NutritionGoalType.gain:
      return 'gain';
    case NutritionGoalType.cut:
      return 'cut';
    case NutritionGoalType.maintain:
      return 'maintain';
  }
}

class PlanWeekTargetInput {
  final int weekNumber;
  final int? targetDailyCalories;
  final int? targetWeeklyDeficit;

  const PlanWeekTargetInput({
    required this.weekNumber,
    this.targetDailyCalories,
    this.targetWeeklyDeficit,
  });
}

class DailyDeficitSummary {
  final DateTime date;
  final double caloriesIn;
  final double caloriesOut;
  final double deficit;
  final int steps;

  const DailyDeficitSummary({
    required this.date,
    required this.caloriesIn,
    required this.caloriesOut,
    required this.deficit,
    required this.steps,
  });
}

class WeeklyDeficitSummary {
  final int weekNumber;
  final DateTime startDate;
  final DateTime endDate;
  final double caloriesIn;
  final double caloriesOut;
  final double deficit;
  final int steps;
  final int? targetWeeklyDeficit;
  final int? targetDailyCalories;

  const WeeklyDeficitSummary({
    required this.weekNumber,
    required this.startDate,
    required this.endDate,
    required this.caloriesIn,
    required this.caloriesOut,
    required this.deficit,
    required this.steps,
    this.targetWeeklyDeficit,
    this.targetDailyCalories,
  });
}

class PlanDeficitSummary {
  final CaloriePlan plan;
  final double totalCaloriesIn;
  final double totalCaloriesOut;
  final double totalDeficit;
  final int totalSteps;
  final int elapsedDays;
  final int totalDays;
  final int elapsedWeeks;
  final int totalWeeks;
  final double averageDailyDeficit;
  final int? targetTotalDeficit;
  final List<WeeklyDeficitSummary> weeklySummaries;

  const PlanDeficitSummary({
    required this.plan,
    required this.totalCaloriesIn,
    required this.totalCaloriesOut,
    required this.totalDeficit,
    required this.totalSteps,
    required this.elapsedDays,
    required this.totalDays,
    required this.elapsedWeeks,
    required this.totalWeeks,
    required this.averageDailyDeficit,
    required this.targetTotalDeficit,
    required this.weeklySummaries,
  });
}

class CaloriePlanningRepository {
  final AppDatabase db;

  CaloriePlanningRepository(this.db);

  Future<double?> getCurrentBmr() async {
    final latest =
        await (db.select(db.bmrProfiles)
              ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
              ..limit(1))
            .getSingleOrNull();
    return latest?.bmr;
  }

  Future<void> upsertCurrentBmr(double bmr) async {
    final latest =
        await (db.select(db.bmrProfiles)
              ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
              ..limit(1))
            .getSingleOrNull();

    if (latest == null) {
      await db
          .into(db.bmrProfiles)
          .insert(
            BmrProfilesCompanion.insert(
              bmr: bmr,
              updatedAt: Value(DateTime.now()),
            ),
          );
      return;
    }

    await (db.update(
      db.bmrProfiles,
    )..where((t) => t.id.equals(latest.id))).write(
      BmrProfilesCompanion(bmr: Value(bmr), updatedAt: Value(DateTime.now())),
    );
  }

  Future<DailyEnergyLog?> getDailyEnergyLog(DateTime date) {
    final normalizedDate = _startOfDay(date);
    return (db.select(
      db.dailyEnergyLogs,
    )..where((t) => t.logDate.equals(normalizedDate))).getSingleOrNull();
  }

  Future<void> upsertDailyEnergyLog({
    required DateTime date,
    required double caloriesOut,
    required int steps,
    String? notes,
  }) async {
    final normalizedDate = _startOfDay(date);
    final existing = await getDailyEnergyLog(normalizedDate);

    if (existing == null) {
      await db
          .into(db.dailyEnergyLogs)
          .insert(
            DailyEnergyLogsCompanion.insert(
              logDate: normalizedDate,
              caloriesOut: caloriesOut,
              steps: Value(steps),
              notes: Value(notes),
              updatedAt: Value(DateTime.now()),
            ),
          );
      return;
    }

    await (db.update(
      db.dailyEnergyLogs,
    )..where((t) => t.id.equals(existing.id))).write(
      DailyEnergyLogsCompanion(
        caloriesOut: Value(caloriesOut),
        steps: Value(steps),
        notes: Value(notes),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> createPlan({
    required String name,
    required NutritionGoalType goalType,
    required DateTime startDate,
    required int totalWeeks,
    int? targetDailyCalories,
    int? targetWeeklyDeficit,
    List<PlanWeekTargetInput> weekTargets = const [],
    bool setActive = true,
  }) async {
    final normalizedStart = _startOfDay(startDate);
    final safeWeeks = totalWeeks <= 0 ? 1 : totalWeeks;
    final endDate = normalizedStart.add(Duration(days: (safeWeeks * 7) - 1));

    return db.transaction(() async {
      if (setActive) {
        await (db.update(db.caloriePlans)
              ..where((t) => t.isActive.equals(true)))
            .write(const CaloriePlansCompanion(isActive: Value(false)));
      }

      final planId = await db
          .into(db.caloriePlans)
          .insert(
            CaloriePlansCompanion.insert(
              name: name.trim().isEmpty ? 'Nutrition Plan' : name.trim(),
              goalType: Value(nutritionGoalTypeToDb(goalType)),
              startDate: normalizedStart,
              endDate: endDate,
              targetDailyCalories: Value(targetDailyCalories),
              targetWeeklyDeficit: Value(targetWeeklyDeficit),
              isActive: Value(setActive),
            ),
          );

      final targetMap = {for (final week in weekTargets) week.weekNumber: week};

      for (int i = 0; i < safeWeeks; i++) {
        final weekNumber = i + 1;
        final weekStart = normalizedStart.add(Duration(days: i * 7));
        final weekEnd = weekStart.add(const Duration(days: 6));
        final override = targetMap[weekNumber];

        await db
            .into(db.caloriePlanWeeks)
            .insert(
              CaloriePlanWeeksCompanion.insert(
                planId: planId,
                weekNumber: weekNumber,
                weekStartDate: weekStart,
                weekEndDate: weekEnd,
                targetDailyCalories: Value(
                  override?.targetDailyCalories ?? targetDailyCalories,
                ),
                targetWeeklyDeficit: Value(
                  override?.targetWeeklyDeficit ?? targetWeeklyDeficit,
                ),
              ),
            );
      }

      return planId;
    });
  }

  Future<void> setActivePlan(int planId) async {
    await db.transaction(() async {
      await (db.update(db.caloriePlans)..where((t) => t.isActive.equals(true)))
          .write(const CaloriePlansCompanion(isActive: Value(false)));
      await (db.update(db.caloriePlans)..where((t) => t.id.equals(planId)))
          .write(const CaloriePlansCompanion(isActive: Value(true)));
    });
  }

  Future<void> clearActivePlan() async {
    await (db.update(db.caloriePlans)..where((t) => t.isActive.equals(true)))
        .write(const CaloriePlansCompanion(isActive: Value(false)));
  }

  Future<CaloriePlan?> getActivePlan() {
    return (db.select(db.caloriePlans)
          ..where((t) => t.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<CaloriePlan?> getPlanById(int planId) {
    return (db.select(db.caloriePlans)
          ..where((t) => t.id.equals(planId))
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<CaloriePlanWeek>> getPlanWeeks(int planId) {
    return (db.select(db.caloriePlanWeeks)
          ..where((t) => t.planId.equals(planId))
          ..orderBy([(t) => OrderingTerm.asc(t.weekNumber)]))
        .get();
  }

  Future<void> updateWeekTarget({
    required int weekId,
    int? targetDailyCalories,
    int? targetWeeklyDeficit,
  }) async {
    await (db.update(
      db.caloriePlanWeeks,
    )..where((t) => t.id.equals(weekId))).write(
      CaloriePlanWeeksCompanion(
        targetDailyCalories: Value(targetDailyCalories),
        targetWeeklyDeficit: Value(targetWeeklyDeficit),
      ),
    );
  }

  Future<void> updatePlanWeekTargets({
    required int planId,
    required List<PlanWeekTargetInput> weekTargets,
  }) async {
    if (weekTargets.isEmpty) return;

    await db.transaction(() async {
      final weeks = await getPlanWeeks(planId);
      final weekByNumber = {for (final week in weeks) week.weekNumber: week};

      for (final target in weekTargets) {
        final week = weekByNumber[target.weekNumber];
        if (week == null) continue;
        await updateWeekTarget(
          weekId: week.id,
          targetDailyCalories: target.targetDailyCalories,
          targetWeeklyDeficit: target.targetWeeklyDeficit,
        );
      }

      await _syncPlanFallbackTargetsFromWeeks(planId);
    });
  }

  Future<DailyDeficitSummary> getDailyDeficit(DateTime date) async {
    final normalizedDate = _startOfDay(date);
    final caloriesInMap = await _getCaloriesInByDate(
      normalizedDate,
      normalizedDate.add(const Duration(days: 1)),
    );
    final energyMap = await _getEnergyLogsByDate(
      normalizedDate,
      normalizedDate.add(const Duration(days: 1)),
    );

    final caloriesIn = caloriesInMap[normalizedDate] ?? 0;
    final energy = energyMap[normalizedDate];
    final caloriesOut = energy?.caloriesOut ?? 0;
    final steps = energy?.steps ?? 0;

    return DailyDeficitSummary(
      date: normalizedDate,
      caloriesIn: caloriesIn,
      caloriesOut: caloriesOut,
      deficit: caloriesOut - caloriesIn,
      steps: steps,
    );
  }

  Future<WeeklyDeficitSummary> getWeeklyDeficit(DateTime date) async {
    final weekStart = _startOfWeek(date);
    final weekEnd = weekStart.add(const Duration(days: 6));
    final range = await _calculateRangeSummary(
      startDate: weekStart,
      endDate: weekEnd,
      weekNumber: 1,
    );
    return range;
  }

  Future<PlanDeficitSummary?> getActivePlanSummary({
    DateTime? referenceDate,
  }) async {
    final activePlan = await getActivePlan();
    if (activePlan == null) return null;
    return getPlanSummary(activePlan, referenceDate: referenceDate);
  }

  Future<PlanDeficitSummary> getPlanSummary(
    CaloriePlan plan, {
    DateTime? referenceDate,
  }) async {
    final planStart = _startOfDay(plan.startDate);
    final planEnd = _startOfDay(plan.endDate);
    final endExclusive = planEnd.add(const Duration(days: 1));

    final caloriesInMap = await _getCaloriesInByDate(planStart, endExclusive);
    final energyMap = await _getEnergyLogsByDate(planStart, endExclusive);
    final weeks = await getPlanWeeks(plan.id);

    final weeklySummaries = <WeeklyDeficitSummary>[];
    for (final week in weeks) {
      weeklySummaries.add(
        await _calculateRangeSummary(
          startDate: _startOfDay(week.weekStartDate),
          endDate: _startOfDay(week.weekEndDate),
          weekNumber: week.weekNumber,
          caloriesInByDate: caloriesInMap,
          energyByDate: energyMap,
          targetWeeklyDeficit: week.targetWeeklyDeficit,
          targetDailyCalories: week.targetDailyCalories,
        ),
      );
    }

    double totalCaloriesIn = 0;
    double totalCaloriesOut = 0;
    int totalSteps = 0;

    DateTime cursor = planStart;
    while (!cursor.isAfter(planEnd)) {
      final intake = caloriesInMap[cursor] ?? 0;
      final energy = energyMap[cursor];
      totalCaloriesIn += intake;
      totalCaloriesOut += energy?.caloriesOut ?? 0;
      totalSteps += energy?.steps ?? 0;
      cursor = cursor.add(const Duration(days: 1));
    }

    final totalDays = planEnd.difference(planStart).inDays + 1;
    final now = _startOfDay(referenceDate ?? DateTime.now());

    final elapsedDays = _calculateElapsedDays(planStart, planEnd, now);
    final elapsedWeeks = _calculateElapsedWeeks(planStart, planEnd, now);
    final targetTotalDeficit = _calculateTargetTotalDeficit(
      weeklySummaries,
      plan.targetWeeklyDeficit,
    );
    final totalDeficit = totalCaloriesOut - totalCaloriesIn;

    return PlanDeficitSummary(
      plan: plan,
      totalCaloriesIn: totalCaloriesIn,
      totalCaloriesOut: totalCaloriesOut,
      totalDeficit: totalDeficit,
      totalSteps: totalSteps,
      elapsedDays: elapsedDays,
      totalDays: totalDays,
      elapsedWeeks: elapsedWeeks,
      totalWeeks: weeks.length,
      averageDailyDeficit: totalDays == 0 ? 0 : totalDeficit / totalDays,
      targetTotalDeficit: targetTotalDeficit,
      weeklySummaries: weeklySummaries,
    );
  }

  int _calculateElapsedDays(DateTime start, DateTime end, DateTime now) {
    if (now.isBefore(start)) return 0;
    if (now.isAfter(end)) return end.difference(start).inDays + 1;
    return now.difference(start).inDays + 1;
  }

  int _calculateElapsedWeeks(DateTime start, DateTime end, DateTime now) {
    if (now.isBefore(start)) return 0;
    final lastDay = now.isAfter(end) ? end : now;
    return (lastDay.difference(start).inDays ~/ 7) + 1;
  }

  int? _calculateTargetTotalDeficit(
    List<WeeklyDeficitSummary> weeks,
    int? fallbackTarget,
  ) {
    final hasWeekTargets = weeks.any((w) => w.targetWeeklyDeficit != null);
    if (hasWeekTargets) {
      int total = 0;
      for (final week in weeks) {
        total += week.targetWeeklyDeficit ?? 0;
      }
      return total;
    }
    if (fallbackTarget == null) return null;
    return fallbackTarget * weeks.length;
  }

  Future<WeeklyDeficitSummary> _calculateRangeSummary({
    required DateTime startDate,
    required DateTime endDate,
    required int weekNumber,
    Map<DateTime, double>? caloriesInByDate,
    Map<DateTime, DailyEnergyLog>? energyByDate,
    int? targetWeeklyDeficit,
    int? targetDailyCalories,
  }) async {
    final start = _startOfDay(startDate);
    final end = _startOfDay(endDate);
    final endExclusive = end.add(const Duration(days: 1));

    final intakeMap =
        caloriesInByDate ?? await _getCaloriesInByDate(start, endExclusive);
    final logsMap =
        energyByDate ?? await _getEnergyLogsByDate(start, endExclusive);

    double caloriesIn = 0;
    double caloriesOut = 0;
    int steps = 0;

    DateTime cursor = start;
    while (!cursor.isAfter(end)) {
      caloriesIn += intakeMap[cursor] ?? 0;
      final energy = logsMap[cursor];
      caloriesOut += energy?.caloriesOut ?? 0;
      steps += energy?.steps ?? 0;
      cursor = cursor.add(const Duration(days: 1));
    }

    return WeeklyDeficitSummary(
      weekNumber: weekNumber,
      startDate: start,
      endDate: end,
      caloriesIn: caloriesIn,
      caloriesOut: caloriesOut,
      deficit: caloriesOut - caloriesIn,
      steps: steps,
      targetWeeklyDeficit: targetWeeklyDeficit,
      targetDailyCalories: targetDailyCalories,
    );
  }

  Future<Map<DateTime, double>> _getCaloriesInByDate(
    DateTime startInclusive,
    DateTime endExclusive,
  ) async {
    final intakeByDate = <DateTime, double>{};

    final foodRows =
        await (db.select(db.foodLogs).join([
              innerJoin(db.foods, db.foods.id.equalsExp(db.foodLogs.foodId)),
            ])..where(
              db.foodLogs.logDate.isBiggerOrEqualValue(startInclusive) &
                  db.foodLogs.logDate.isSmallerThanValue(endExclusive) &
                  db.foodLogs.isEaten.equals(true),
            ))
            .get();

    for (final row in foodRows) {
      final log = row.readTable(db.foodLogs);
      final food = row.readTable(db.foods);
      final day = _startOfDay(log.logDate);
      final calories = food.calories * log.servings;
      intakeByDate[day] = (intakeByDate[day] ?? 0) + calories;
    }

    final alcoholRows =
        await (db.select(db.alcoholLogs)..where(
              (t) =>
                  t.logDate.isBiggerOrEqualValue(startInclusive) &
                  t.logDate.isSmallerThanValue(endExclusive) &
                  t.isEaten.equals(true),
            ))
            .get();

    for (final alcohol in alcoholRows) {
      final day = _startOfDay(alcohol.logDate);
      intakeByDate[day] = (intakeByDate[day] ?? 0) + alcohol.calories;
    }

    return intakeByDate;
  }

  Future<Map<DateTime, DailyEnergyLog>> _getEnergyLogsByDate(
    DateTime startInclusive,
    DateTime endExclusive,
  ) async {
    final logs =
        await (db.select(db.dailyEnergyLogs)..where(
              (t) =>
                  t.logDate.isBiggerOrEqualValue(startInclusive) &
                  t.logDate.isSmallerThanValue(endExclusive),
            ))
            .get();

    return {for (final log in logs) _startOfDay(log.logDate): log};
  }

  DateTime _startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _startOfWeek(DateTime date) {
    final day = _startOfDay(date);
    return day.subtract(Duration(days: day.weekday - DateTime.monday));
  }

  Future<void> _syncPlanFallbackTargetsFromWeeks(int planId) async {
    final weeks = await getPlanWeeks(planId);
    if (weeks.isEmpty) return;

    final dailyTargets = weeks
        .map((week) => week.targetDailyCalories)
        .whereType<int>()
        .toSet();
    final weeklyTargets = weeks
        .map((week) => week.targetWeeklyDeficit)
        .whereType<int>()
        .toSet();

    await (db.update(db.caloriePlans)..where((t) => t.id.equals(planId))).write(
      CaloriePlansCompanion(
        targetDailyCalories: Value(
          dailyTargets.length == 1 ? dailyTargets.first : null,
        ),
        targetWeeklyDeficit: Value(
          weeklyTargets.length == 1 ? weeklyTargets.first : null,
        ),
      ),
    );
  }
}
