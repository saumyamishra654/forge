import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:drift/drift.dart' show Value, innerJoin, OrderingTerm, OrderingMode;
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


  bool _isLoading = true;
  List<CategoryData> _categoryData = [];
  List<ExpenseWithCategory> _recentExpenses = [];

  @override
  void initState() {
    super.initState();
    _loadFinancialData();
  }

  Future<void> _loadFinancialData() async {
    setState(() => _isLoading = true);
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    
    // Date Ranges
    final startToday = DateTime(now.year, now.month, now.day);
    final startWeek = now.subtract(const Duration(days: 7));
    final startMonth = DateTime(now.year, now.month, 1);
    
    final expenses = await db.select(db.expenses).get();
    
    double today = 0;
    double week = 0;
    double month = 0;
    Map<int, double> categoryMap = {};
    
    for (var e in expenses) {
      if (e.logDate.isAfter(startToday)) today += e.amount;
      if (e.logDate.isAfter(startWeek)) week += e.amount;
      if (e.logDate.isAfter(startMonth)) month += e.amount;
      
      // Category Breakdown (using month data for chart or all time? Let's use Month)
      if (e.logDate.isAfter(startMonth)) {
        categoryMap[e.categoryId] = (categoryMap[e.categoryId] ?? 0) + e.amount;
      }
    }
    
    // Load Categories for Chart Labels
    final categories = await db.select(db.expenseCategories).get();
    List<CategoryData> chartData = [];
    
    categoryMap.forEach((id, amount) {
      final cat = categories.firstWhere((c) => c.id == id, orElse: () => const ExpenseCategory(id: -1, name: 'Unknown', icon: '?', color: '0xFF000000', isFoodRelated: false));
      chartData.add(CategoryData(cat.name, amount, Color(int.parse(cat.color ?? '0xFF000000'))));
    });

    // Load recent expenses for list
    final recentQuery = db.select(db.expenses).join([
      innerJoin(db.expenseCategories, db.expenseCategories.id.equalsExp(db.expenses.categoryId)),
    ]);
    recentQuery.orderBy([OrderingTerm(expression: db.expenses.logDate, mode: OrderingMode.desc)]);
    recentQuery.limit(20);
    
    final recentResults = await recentQuery.get();
    final recentList = recentResults.map((row) => ExpenseWithCategory(
      expense: row.readTable(db.expenses),
      category: row.readTable(db.expenseCategories),
    )).toList();

    if (mounted) {
      setState(() {
        _totalSpentToday = today;
        _totalSpentWeek = week;
        _totalSpentMonth = month;
        _categoryData = chartData;
        _recentExpenses = recentList;
        _isLoading = false;
      });
    }
  }

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
                    'Monthly Breakdown',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: _categoryData.isEmpty 
                      ? Center(child: Text('No entries this month', style: Theme.of(context).textTheme.bodySmall))
                      : PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 50,
                        sections: _categoryData.map((data) {
                          return PieChartSectionData(
                            value: data.amount,
                            color: data.color,
                            radius: 25,
                            showTitle: false,
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_categoryData.isNotEmpty)
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: _categoryData.map((data) => _buildLegendItem(data)).toList(),
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
            
            _recentExpenses.isEmpty
                ? _buildEmptyExpensesState()
                : _buildExpenseList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(CategoryData data) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: data.color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(data.name, style: Theme.of(context).textTheme.bodySmall),
      ],
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
              color: AppTheme.financeColor.withValues(alpha: 0.5),
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

  void _showAddExpenseSheet(BuildContext context) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddExpenseSheet(),
    );
    
    if (result == true) {
      _loadFinancialData();
    }
  }

  Widget _buildExpenseList() {
    return Column(
      children: _recentExpenses.map((e) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.financeColor.withValues(alpha:0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(e.category.icon, style: const TextStyle(fontSize: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.category.name, style: Theme.of(context).textTheme.titleSmall),
                  if (e.expense.description != null)
                    Text(e.expense.description!, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${e.expense.amount.toStringAsFixed(0)}', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppTheme.financeColor)),
                Text(_formatDate(e.expense.logDate), style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      )).toList(),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms);
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month && date.year == now.year) {
      return 'Today';
    } else if (date.day == now.day - 1 && date.month == now.month && date.year == now.year) {
      return 'Yesterday';
    }
    return '${date.day}/${date.month}';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();

  Future<void> _loadCategories() async {
    final db = ref.read(databaseProvider);
    final cats = await db.select(db.expenseCategories).get();
    if (mounted) {
      setState(() {
        _categories = cats;
        _isLoading = false;
      });
    }
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
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_categories.isEmpty)
                    Text('No categories found', style: Theme.of(context).textTheme.bodySmall)
                  else
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
                          selectedColor: AppTheme.financeColor.withValues(alpha: 0.3),
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
                  
                  const SizedBox(height: 20),
                  
                  // Date
                  Text('Date', style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.surfaceLight),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded, size: 20, color: AppTheme.textSecondary),
                          const SizedBox(width: 12),
                          Text(
                            _selectedDate.day == DateTime.now().day &&
                                    _selectedDate.month == DateTime.now().month &&
                                    _selectedDate.year == DateTime.now().year
                                ? 'Today'
                                : '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          const Icon(Icons.edit_rounded, size: 16, color: AppTheme.textMuted),
                        ],
                      ),
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
        logDate: _selectedDate,
        categoryId: _selectedCategory!.id,
        amount: amount,
        description: Value(_descriptionController.text.isNotEmpty 
            ? _descriptionController.text 
            : null),
      ),
    );

    if (mounted) {
      Navigator.pop(context, true);
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(data: Theme.of(context), child: child!),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }
}

class CategoryData {
  final String name;
  final double amount;
  final Color color;
  CategoryData(this.name, this.amount, this.color);
}

class ExpenseWithCategory {
  final Expense expense;
  final ExpenseCategory category;
  ExpenseWithCategory({required this.expense, required this.category});
}
