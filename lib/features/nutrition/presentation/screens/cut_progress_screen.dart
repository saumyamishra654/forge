import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/repositories/calorie_planning_repository.dart';
import '../../providers/food_providers.dart';

class CutProgressScreen extends ConsumerStatefulWidget {
  final int planId;

  const CutProgressScreen({super.key, required this.planId});

  @override
  ConsumerState<CutProgressScreen> createState() => _CutProgressScreenState();
}

class _CutProgressScreenState extends ConsumerState<CutProgressScreen> {
  bool _isLoading = true;
  PlanDeficitSummary? _summary;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(caloriePlanningRepositoryProvider);
      final plan = await repo.getPlanById(widget.planId);
      if (plan == null) {
        if (!mounted) return;
        setState(() {
          _summary = null;
          _error = 'Plan not found';
          _isLoading = false;
        });
        return;
      }

      final summary = await repo.getPlanSummary(plan);
      if (!mounted) return;
      setState(() {
        _summary = summary;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load cut progress: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Cut Progress')),
      body: SafeArea(
        child: RefreshIndicator(onRefresh: _load, child: _buildBody()),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          Center(child: Text(_error!)),
        ],
      );
    }

    final summary = _summary;
    if (summary == null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 120),
          Center(child: Text('No data available')),
        ],
      );
    }

    final double? completion =
        summary.targetTotalDeficit == null || summary.targetTotalDeficit == 0
        ? null
        : (summary.totalDeficit / summary.targetTotalDeficit!.toDouble())
              .clamp(0, 2)
              .toDouble();

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          summary.plan.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
        Text(
          '${_goalLabel(summary.plan.goalType)} • Week ${summary.elapsedWeeks}/${summary.totalWeeks}',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.textMuted),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _metricCard(
                label: 'Total Deficit',
                value: _signed(summary.totalDeficit),
                color: _deficitColor(summary.totalDeficit),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _metricCard(
                label: 'Avg / Day',
                value: _signed(summary.averageDailyDeficit),
                color: _deficitColor(summary.averageDailyDeficit),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _metricCard(
                label: 'Total Steps',
                value: '${summary.totalSteps}',
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _metricCard(
                label: 'Target Total',
                value: summary.targetTotalDeficit == null
                    ? '--'
                    : _signed(summary.targetTotalDeficit!.toDouble()),
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        if (completion != null) ...[
          const SizedBox(height: 14),
          LinearProgressIndicator(
            value: completion > 1 ? 1 : completion,
            minHeight: 8,
            backgroundColor: AppTheme.surfaceLight,
            valueColor: AlwaysStoppedAnimation<Color>(
              completion >= 1 ? Colors.green.shade500 : AppTheme.nutritionColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${(completion * 100).toStringAsFixed(1)}% of target deficit',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textMuted),
          ),
        ],
        const SizedBox(height: 20),
        _chartCard(
          title: 'Cumulative Deficit',
          child: SizedBox(height: 220, child: _buildCumulativeChart(summary)),
        ),
        const SizedBox(height: 14),
        _chartCard(
          title: 'Weekly Deficit vs Target',
          child: SizedBox(
            height: 240,
            child: _buildWeeklyComparisonChart(summary),
          ),
        ),
      ],
    );
  }

  Widget _metricCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textMuted),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chartCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildCumulativeChart(PlanDeficitSummary summary) {
    if (summary.weeklySummaries.isEmpty) {
      return const Center(child: Text('No week data'));
    }

    final actualSpots = <FlSpot>[];
    final targetSpots = <FlSpot>[];
    double cumulativeActual = 0;
    double cumulativeTarget = 0;
    bool hasTargetLine = false;

    for (final week in summary.weeklySummaries) {
      cumulativeActual += week.deficit;
      actualSpots.add(FlSpot(week.weekNumber.toDouble(), cumulativeActual));

      if (week.targetWeeklyDeficit != null) {
        cumulativeTarget += week.targetWeeklyDeficit!.toDouble();
        hasTargetLine = true;
      }
      targetSpots.add(FlSpot(week.weekNumber.toDouble(), cumulativeTarget));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) => Text(
                'W${value.toInt()}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 10),
              ),
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: actualSpots,
            isCurved: false,
            barWidth: 3,
            color: AppTheme.nutritionColor,
            dotData: const FlDotData(show: true),
          ),
          if (hasTargetLine)
            LineChartBarData(
              spots: targetSpots,
              isCurved: false,
              barWidth: 2,
              color: Colors.orange.shade400,
              dotData: const FlDotData(show: false),
              dashArray: [6, 4],
            ),
        ],
      ),
    );
  }

  Widget _buildWeeklyComparisonChart(PlanDeficitSummary summary) {
    if (summary.weeklySummaries.isEmpty) {
      return const Center(child: Text('No week data'));
    }

    final groups = summary.weeklySummaries.map((week) {
      final target = week.targetWeeklyDeficit?.toDouble() ?? 0;
      return BarChartGroupData(
        x: week.weekNumber,
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            toY: week.deficit,
            width: 10,
            color: AppTheme.nutritionColor,
            borderRadius: BorderRadius.circular(3),
          ),
          BarChartRodData(
            toY: target,
            width: 10,
            color: Colors.orange.shade400.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        gridData: FlGridData(show: true, drawVerticalLine: false),
        borderData: FlBorderData(show: false),
        barGroups: groups,
        titlesData: FlTitlesData(
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (value, meta) => Text(
                'W${value.toInt()}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 10),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _signed(double value) {
    final rounded = value.round();
    if (rounded > 0) return '+$rounded';
    return '$rounded';
  }

  String _goalLabel(String goalType) {
    switch (nutritionGoalTypeFromDb(goalType)) {
      case NutritionGoalType.maintain:
        return 'Maintain';
      case NutritionGoalType.gain:
        return 'Gain';
      case NutritionGoalType.cut:
        return 'Cut';
    }
  }

  Color _deficitColor(double deficit) {
    if (deficit > 0) return Colors.green.shade500;
    if (deficit < 0) return Colors.red.shade400;
    return AppTheme.textSecondary;
  }
}
