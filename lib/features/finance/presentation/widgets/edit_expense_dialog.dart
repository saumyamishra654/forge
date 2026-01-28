import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../screens/finance_home_screen.dart';

class EditExpenseDialog extends ConsumerStatefulWidget {
  final ExpenseWithCategory item;
  const EditExpenseDialog({super.key, required this.item});

  @override
  ConsumerState<EditExpenseDialog> createState() => _EditExpenseDialogState();
}

class _EditExpenseDialogState extends ConsumerState<EditExpenseDialog> {
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late ExpenseCategory _selectedCategory;
  late DateTime _selectedDate;
  List<ExpenseCategory> _categories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.item.expense.amount.toStringAsFixed(0));
    _descriptionController = TextEditingController(text: widget.item.expense.description ?? '');
    _selectedCategory = widget.item.category;
    _selectedDate = widget.item.expense.logDate;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final db = ref.read(databaseProvider);
    final cats = await db.select(db.expenseCategories).get();
    if (mounted) {
      setState(() {
        _categories = cats;
        _isLoadingCategories = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Expense',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Padding(
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
                    if (_isLoadingCategories)
                      const Center(child: CircularProgressIndicator())
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _categories.map((cat) {
                          final isSelected = _selectedCategory.id == cat.id;
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
                              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const Spacer(),
                            const Icon(Icons.edit_rounded, size: 16, color: AppTheme.textMuted),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: _deleteExpense,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red.shade400,
                          side: BorderSide(color: Colors.red.shade400),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Icon(Icons.delete_outline_rounded),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: ElevatedButton(
                        onPressed: _updateExpense,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.financeColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _updateExpense() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    await (db.update(db.expenses)..where((t) => t.id.equals(widget.item.expense.id))).write(
      ExpensesCompanion(
        amount: Value(amount),
        categoryId: Value(_selectedCategory.id),
        description: Value(_descriptionController.text.isNotEmpty ? _descriptionController.text : null),
        logDate: Value(_selectedDate),
      ),
    );

    if (mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense updated!')),
      );
    }
  }

  Future<void> _deleteExpense() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final db = ref.read(databaseProvider);
      await (db.delete(db.expenses)..where((t) => t.id.equals(widget.item.expense.id))).go();
      
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense deleted')),
        );
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
