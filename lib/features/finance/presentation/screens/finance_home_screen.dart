import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';

class FinanceHomeScreen extends ConsumerStatefulWidget {
  const FinanceHomeScreen({super.key});

  @override
  ConsumerState<FinanceHomeScreen> createState() => _FinanceHomeScreenState();
}

class _FinanceHomeScreenState extends ConsumerState<FinanceHomeScreen> {
  double _totalSpentToday = 0;
  double _totalSpentWeek = 0;
  double _totalSpentMonth = 0;

  @override
  Widget build(BuildContext context) {
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
                      'Finance',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Track your spending',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.financeGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms),
            
            const SizedBox(height: 24),
            
            // Spending Summary Cards
            Row(
              children: [
                Expanded(child: _buildSpendingCard('Today', _totalSpentToday)),
                const SizedBox(width: 12),
                Expanded(child: _buildSpendingCard('This Week', _totalSpentWeek)),
                const SizedBox(width: 12),
                Expanded(child: _buildSpendingCard('This Month', _totalSpentMonth)),
              ],
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms),
            
            const SizedBox(height: 24),
            
            // Category Breakdown
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category Breakdown',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 50,
                        sections: [
                          PieChartSectionData(
                            value: 1,
                            color: AppTheme.financeColor.withOpacity(0.3),
                            radius: 25,
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'No expenses logged yet',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
            
            const SizedBox(height: 24),
            
            // Add Expense Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showAddExpenseSheet(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Expense'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.financeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
            
            const SizedBox(height: 24),
            
            // Recent Expenses
            Text(
              'Recent Expenses',
              style: Theme.of(context).textTheme.titleMedium,
            ).animate().fadeIn(delay: 250.ms),
            
            const SizedBox(height: 12),
            
            _buildEmptyExpensesState(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpendingCard(String period, double amount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            period,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            '₹${amount.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.financeColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyExpensesState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 48,
              color: AppTheme.financeColor.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No expenses yet',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking to see insights',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }

  void _showAddExpenseSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddExpenseSheet(),
    );
  }
}

class AddExpenseSheet extends ConsumerStatefulWidget {
  const AddExpenseSheet({super.key});

  @override
  ConsumerState<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  ExpenseCategory? _selectedCategory;
  List<ExpenseCategory> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final db = ref.read(databaseProvider);
    final cats = await db.select(db.expenseCategories).get();
    setState(() => _categories = cats);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Expense',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount
                  Text('Amount (₹)', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: Theme.of(context).textTheme.headlineMedium,
                    decoration: const InputDecoration(
                      hintText: '0',
                      prefixText: '₹ ',
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Category
                  Text('Category', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory?.id == cat.id;
                      return FilterChip(
                        label: Text('${cat.icon} ${cat.name}'),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _selectedCategory = cat),
                        backgroundColor: AppTheme.surfaceLight,
                        selectedColor: AppTheme.financeColor.withOpacity(0.3),
                        labelStyle: TextStyle(
                          color: isSelected ? AppTheme.financeColor : AppTheme.textSecondary,
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Description
                  Text('Description (optional)', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'What was this for?',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveExpense,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.financeColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Expense'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveExpense() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0 || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter amount and select category')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    await db.into(db.expenses).insert(
      ExpensesCompanion.insert(
        logDate: DateTime.now(),
        categoryId: _selectedCategory!.id,
        amount: amount,
        description: Value(_descriptionController.text.isNotEmpty 
            ? _descriptionController.text 
            : null),
      ),
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense saved!')),
      );
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
