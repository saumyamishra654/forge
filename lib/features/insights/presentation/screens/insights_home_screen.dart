import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../main.dart';
import '../../data/repositories/insights_repository.dart';

class InsightsHomeScreen extends ConsumerStatefulWidget {
  const InsightsHomeScreen({super.key});

  @override
  ConsumerState<InsightsHomeScreen> createState() => _InsightsHomeScreenState();
}

class _InsightsHomeScreenState extends ConsumerState<InsightsHomeScreen> {
  String _selectedPeriod = 'All Time';
  
  // Finance Metrics
  double? _costPerCalorie;
  double? _costPerProtein;
  
  // Food Efficiency
  List<FoodEfficiencyItem> _bestProteinPerRupee = [];
  List<FoodEfficiencyItem> _bestCaloriesPerRupee = [];
  
  // Macro Breakdown
  FoodProteinPercent? _highestProtein;
  FoodProteinPercent? _lowestProtein;
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    setState(() => _isLoading = true);
    
    final db = ref.read(databaseProvider);
    final repo = InsightsRepository(db);
    
    // Determine date range
    DateTime? start;
    final now = DateTime.now();
    
    if (_selectedPeriod == '7 Days') {
      start = now.subtract(const Duration(days: 7));
    } else if (_selectedPeriod == '30 Days') {
      start = now.subtract(const Duration(days: 30));
    }
    // 'All Time' = null start
    
    try {
      final results = await Future.wait([
        repo.getCostPerCalorie(start: start),
        repo.getCostPerProtein(start: start),
        repo.getBestProteinPerRupee(limit: 3),
        repo.getBestCaloriesPerRupee(limit: 3),
        repo.getHighestProteinPercent(),
        repo.getLowestProteinPercent(),
      ]);
      
      if (mounted) {
        setState(() {
          _costPerCalorie = results[0] as double?;
          _costPerProtein = results[1] as double?;
          _bestProteinPerRupee = results[2] as List<FoodEfficiencyItem>;
          _bestCaloriesPerRupee = results[3] as List<FoodEfficiencyItem>;
          _highestProtein = results[4] as FoodProteinPercent?;
          _lowestProtein = results[5] as FoodProteinPercent?;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading insights: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Insights'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadInsights,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Filter Chips
                _buildTimeFilterChips(),
                const SizedBox(height: 24),
                
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  // Section 1: Spending Efficiency
                  _buildSectionHeader('Spending Efficiency', Icons.attach_money_rounded),
                  const SizedBox(height: 12),
                  _buildSpendingCards(),
                  const SizedBox(height: 28),
                  
                  // Section 2: Food Efficiency
                  _buildSectionHeader('Food Efficiency', Icons.restaurant_rounded),
                  const SizedBox(height: 12),
                  _buildFoodEfficiencyCard(),
                  const SizedBox(height: 28),
                  
                  // Section 3: Macro Breakdown
                  _buildSectionHeader('Macro Breakdown', Icons.pie_chart_rounded),
                  const SizedBox(height: 12),
                  _buildMacroBreakdownCard(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeFilterChips() {
    return Row(
      children: ['7 Days', '30 Days', 'All Time'].map((period) {
        final isSelected = _selectedPeriod == period;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(period),
            selected: isSelected,
            onSelected: (_) {
              setState(() => _selectedPeriod = period);
              _loadInsights();
            },
            selectedColor: AppTheme.insightsColor.withValues(alpha: 0.2),
            labelStyle: TextStyle(
              color: isSelected ? AppTheme.insightsColor : AppTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            side: BorderSide(
              color: isSelected ? AppTheme.insightsColor : AppTheme.surfaceLight,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.insightsColor, size: 20),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppTheme.insightsColor,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingCards() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            label: 'Per 100 kcal',
            value: _costPerCalorie != null 
                ? _costPerCalorie!.toStringAsFixed(1)
                : '--',
            prefix: 'Rs',
            color: AppTheme.financeColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildMetricCard(
            label: 'Per 10g Protein',
            value: _costPerProtein != null 
                ? _costPerProtein!.toStringAsFixed(1)
                : '--',
            prefix: 'Rs',
            color: AppTheme.proteinColor,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required String prefix,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                prefix,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFoodEfficiencyCard() {
    if (_bestProteinPerRupee.isEmpty && _bestCaloriesPerRupee.isEmpty) {
      return _buildEmptyCard('Log food with cost to see efficiency metrics');
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_bestProteinPerRupee.isNotEmpty) ...[
            Text(
              'Best Protein/Rs',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.proteinColor,
              ),
            ),
            const SizedBox(height: 8),
            ..._bestProteinPerRupee.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.foodName, style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    '${item.value.toStringAsFixed(2)}g/Rs',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),
          ],
          if (_bestCaloriesPerRupee.isNotEmpty) ...[
            Text(
              'Best Calories/Rs',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppTheme.nutritionColor,
              ),
            ),
            const SizedBox(height: 8),
            ..._bestCaloriesPerRupee.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item.foodName, style: Theme.of(context).textTheme.bodyMedium),
                  Text(
                    '${item.value.toStringAsFixed(1)} kcal/Rs',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildMacroBreakdownCard() {
    if (_highestProtein == null && _lowestProtein == null) {
      return _buildEmptyCard('Log foods to see macro breakdown');
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if (_highestProtein != null)
            _buildMacroRow(
              icon: Icons.arrow_upward_rounded,
              iconColor: AppTheme.success,
              label: 'Highest Protein %',
              foodName: _highestProtein!.foodName,
              percent: _highestProtein!.proteinPercent,
            ),
          if (_highestProtein != null && _lowestProtein != null)
            const Divider(height: 24),
          if (_lowestProtein != null)
            _buildMacroRow(
              icon: Icons.arrow_downward_rounded,
              iconColor: AppTheme.error,
              label: 'Lowest Protein %',
              foodName: _lowestProtein!.foodName,
              percent: _lowestProtein!.proteinPercent,
            ),
        ],
      ),
    );
  }

  Widget _buildMacroRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String foodName,
    required double percent,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.textMuted,
                ),
              ),
              Text(
                foodName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        Text(
          '${percent.toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: iconColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.surfaceLight),
      ),
      child: Column(
        children: [
          Icon(Icons.insights_rounded, color: AppTheme.textMuted, size: 40),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
