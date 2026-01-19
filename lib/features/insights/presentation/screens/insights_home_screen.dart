import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../../data/insights_repository.dart';

/// Provider for insights repository
final insightsRepositoryProvider = Provider<InsightsRepository>((ref) {
  return InsightsRepository(ref.watch(databaseProvider));
});

/// Provider for insights data
final insightsProvider = FutureProvider<CrossDomainInsights>((ref) async {
  final repo = ref.watch(insightsRepositoryProvider);
  return repo.getInsights(days: 7);
});

class InsightsHomeScreen extends ConsumerWidget {
  const InsightsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(insightsProvider);
    
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Insights',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Last 7 days',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.insightsGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.insights_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms),
            
            const SizedBox(height: 24),
            
            insightsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (insights) => _buildInsightsContent(context, ref, insights),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsContent(BuildContext context, WidgetRef ref, CrossDomainInsights insights) {
    final repo = ref.read(insightsRepositoryProvider);
    final message = repo.getInsightMessage(insights);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Motivational Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.lightbulb_rounded, color: Colors.white, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
        
        const SizedBox(height: 24),
        
        // Metric Cards
        _buildMetricCard(
          context,
          '₹/Calorie',
          insights.rupeePerCalorie > 0 
              ? '₹${insights.rupeePerCalorie.toStringAsFixed(2)}'
              : '—',
          'Cost per calorie consumed',
          Icons.local_fire_department_rounded,
          AppTheme.nutritionColor,
          insights.totalCalories > 0,
        ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
        
        const SizedBox(height: 12),
        
        _buildMetricCard(
          context,
          '₹/gram Protein',
          insights.rupeePerProtein > 0 
              ? '₹${insights.rupeePerProtein.toStringAsFixed(1)}'
              : '—',
          'Cost per gram of protein',
          Icons.fitness_center_rounded,
          AppTheme.proteinColor,
          insights.totalProtein > 0,
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
        
        const SizedBox(height: 12),
        
        _buildMetricCard(
          context,
          'Cost/Workout',
          insights.rupeePerWorkout > 0 
              ? '₹${insights.rupeePerWorkout.toStringAsFixed(0)}'
              : '—',
          '${insights.workoutCount} workouts this week',
          Icons.sports_gymnastics_rounded,
          AppTheme.exerciseColor,
          insights.workoutCount > 0,
        ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
        
        const SizedBox(height: 24),
        
        // Summary Stats
        Text(
          'Summary',
          style: Theme.of(context).textTheme.titleMedium,
        ).animate().fadeIn(delay: 300.ms),
        
        const SizedBox(height: 12),
        
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildSummaryRow(context, 'Total Food Spend', '₹${insights.totalFoodSpend.toStringAsFixed(0)}'),
              const Divider(height: 24),
              _buildSummaryRow(context, 'Calories Consumed', '${insights.totalCalories.toStringAsFixed(0)} kcal'),
              const Divider(height: 24),
              _buildSummaryRow(context, 'Protein Consumed', '${insights.totalProtein.toStringAsFixed(1)}g'),
              const Divider(height: 24),
              _buildSummaryRow(context, 'Fitness Spend', '₹${insights.fitnessSpend.toStringAsFixed(0)}'),
            ],
          ),
        ).animate().fadeIn(delay: 350.ms, duration: 400.ms),
        
        const SizedBox(height: 24),
        
        // Refresh Button
        Center(
          child: TextButton.icon(
            onPressed: () => ref.invalidate(insightsProvider),
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
    bool hasData,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: hasData ? color.withValues(alpha: 0.15) : AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: hasData ? color : AppTheme.textMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }
}
