import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:drift/drift.dart' show Value, OrderingTerm;
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import 'package:intl/intl.dart';

class BodyTrackingScreen extends ConsumerStatefulWidget {
  const BodyTrackingScreen({super.key});

  @override
  ConsumerState<BodyTrackingScreen> createState() => _BodyTrackingScreenState();
}

class _BodyTrackingScreenState extends ConsumerState<BodyTrackingScreen> {
  List<WeightLog> _weightLogs = [];
  List<BodyFatLog> _bodyFatLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);
    
    final weights = await (db.select(db.weightLogs)
      ..orderBy([(t) => OrderingTerm.desc(t.logDate)])
      ..limit(30))
      .get();
    
    final bodyFats = await (db.select(db.bodyFatLogs)
      ..orderBy([(t) => OrderingTerm.desc(t.logDate)])
      ..limit(30))
      .get();
    
    setState(() {
      _weightLogs = weights;
      _bodyFatLogs = bodyFats;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Body Tracking'),
        actions: [
          IconButton(
            onPressed: () => _showAddWeightSheet(context),
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Current Weight',
                          _weightLogs.isNotEmpty 
                              ? '${_weightLogs.first.weightKg.toStringAsFixed(1)} kg'
                              : '-- kg',
                          Icons.monitor_weight_rounded,
                          AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Body Fat',
                          _bodyFatLogs.isNotEmpty
                              ? '${_bodyFatLogs.first.bodyFatPercent.toStringAsFixed(1)}%'
                              : '--%',
                          Icons.percent_rounded,
                          AppTheme.secondary,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                  
                  const SizedBox(height: 16),
                  
                  // Weight Change
                  if (_weightLogs.length >= 2)
                    _buildChangeCard().animate().fadeIn(delay: 100.ms, duration: 400.ms),
                  
                  const SizedBox(height: 24),
                  
                  // Weight Chart
                  Text(
                    'Weight Trend',
                    style: Theme.of(context).textTheme.titleMedium,
                  ).animate().fadeIn(delay: 150.ms),
                  
                  const SizedBox(height: 12),
                  
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _weightLogs.isEmpty
                        ? Center(
                            child: Text(
                              'Log your weight to see trends',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : _buildWeightChart(),
                  ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  
                  const SizedBox(height: 24),
                  
                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          'Log Weight',
                          Icons.monitor_weight_rounded,
                          AppTheme.primaryGradient,
                          () => _showAddWeightSheet(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          'Log Body Fat',
                          Icons.percent_rounded,
                          AppTheme.primaryGradient,
                          () => _showAddBodyFatSheet(context),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
                  
                  const SizedBox(height: 24),
                  
                  // Recent Entries
                  Text(
                    'Recent Entries',
                    style: Theme.of(context).textTheme.titleMedium,
                  ).animate().fadeIn(delay: 300.ms),
                  
                  const SizedBox(height: 12),
                  
                  if (_weightLogs.isEmpty && _bodyFatLogs.isEmpty)
                    _buildEmptyState()
                  else
                    ..._buildRecentEntries(),
                ],
              ),
            ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeCard() {
    final latest = _weightLogs.first.weightKg;
    final oldest = _weightLogs.last.weightKg;
    final change = latest - oldest;
    final isGain = change > 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: (isGain ? AppTheme.warning : AppTheme.success).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isGain ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              color: isGain ? AppTheme.warning : AppTheme.success,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)} kg',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isGain ? AppTheme.warning : AppTheme.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Change over ${_weightLogs.length} entries',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChart() {
    if (_weightLogs.isEmpty) return const SizedBox();
    
    final spots = _weightLogs.reversed.toList().asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.weightKg);
    }).toList();
    
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) - 2;
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 2;
    
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.primary,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppTheme.primary,
                  strokeWidth: 2,
                  strokeColor: AppTheme.background,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, LinearGradient gradient, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
              Icons.monitor_weight_outlined,
              size: 48,
              color: AppTheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No entries yet',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking your weight and body fat',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 350.ms, duration: 400.ms);
  }

  List<Widget> _buildRecentEntries() {
    final allEntries = <MapEntry<DateTime, Widget>>[];
    
    for (final log in _weightLogs.take(10)) {
      allEntries.add(MapEntry(
        log.logDate,
        _buildWeightEntry(log),
      ));
    }
    
    for (final log in _bodyFatLogs.take(10)) {
      allEntries.add(MapEntry(
        log.logDate,
        _buildBodyFatEntry(log),
      ));
    }
    
    allEntries.sort((a, b) => b.key.compareTo(a.key));
    
    return allEntries.take(10).map((e) => e.value).toList();
  }

  Widget _buildWeightEntry(WeightLog log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.monitor_weight_rounded, color: AppTheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${log.weightKg.toStringAsFixed(1)} kg',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  DateFormat('MMM d, yyyy • h:mm a').format(log.logDate),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (log.notes != null)
            Icon(Icons.note_rounded, color: AppTheme.textMuted, size: 16),
        ],
      ),
    ).animate().fadeIn(delay: 350.ms, duration: 300.ms);
  }

  Widget _buildBodyFatEntry(BodyFatLog log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.percent_rounded, color: AppTheme.secondary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${log.bodyFatPercent.toStringAsFixed(1)}% body fat',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Text(
                  '${log.method} • ${DateFormat('MMM d, yyyy').format(log.logDate)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 350.ms, duration: 300.ms);
  }

  void _showAddWeightSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddWeightSheet(onSaved: _loadData),
    );
  }

  void _showAddBodyFatSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddBodyFatSheet(onSaved: _loadData),
    );
  }
}

/// Add Weight Bottom Sheet
class AddWeightSheet extends ConsumerStatefulWidget {
  final VoidCallback onSaved;
  
  const AddWeightSheet({super.key, required this.onSaved});

  @override
  ConsumerState<AddWeightSheet> createState() => _AddWeightSheetState();
}

class _AddWeightSheetState extends ConsumerState<AddWeightSheet> {
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            Text(
              'Log Weight',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            
            // Weight Input
            Text('Weight (kg)', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: const InputDecoration(
                hintText: '70.0',
                suffixText: 'kg',
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Notes
            Text('Notes (optional)', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Morning, after workout, etc.',
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveWeight,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveWeight() async {
    final weight = double.tryParse(_weightController.text);
    if (weight == null || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid weight')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    await db.into(db.weightLogs).insert(
      WeightLogsCompanion.insert(
        logDate: DateTime.now(),
        weightKg: weight,
        notes: Value(_notesController.text.isNotEmpty ? _notesController.text : null),
      ),
    );

    widget.onSaved();
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Weight logged!')),
      );
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

/// Add Body Fat Bottom Sheet
class AddBodyFatSheet extends ConsumerStatefulWidget {
  final VoidCallback onSaved;
  
  const AddBodyFatSheet({super.key, required this.onSaved});

  @override
  ConsumerState<AddBodyFatSheet> createState() => _AddBodyFatSheetState();
}

class _AddBodyFatSheetState extends ConsumerState<AddBodyFatSheet> {
  final _bodyFatController = TextEditingController();
  final _notesController = TextEditingController();
  String _selectedMethod = 'estimate';

  final _methods = [
    ('estimate', 'Estimate'),
    ('scale', 'Smart Scale'),
    ('caliper', 'Caliper'),
    ('dexa', 'DEXA Scan'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            Text(
              'Log Body Fat',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            
            // Body Fat Input
            Text('Body Fat %', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _bodyFatController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              style: Theme.of(context).textTheme.headlineMedium,
              decoration: const InputDecoration(
                hintText: '15.0',
                suffixText: '%',
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Method Selection
            Text('Measurement Method', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _methods.map((method) {
                final isSelected = _selectedMethod == method.$1;
                return FilterChip(
                  label: Text(method.$2),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedMethod = method.$1),
                  backgroundColor: AppTheme.surfaceLight,
                  selectedColor: AppTheme.secondary.withValues(alpha: 0.3),
                  labelStyle: TextStyle(
                    color: isSelected ? AppTheme.secondary : AppTheme.textSecondary,
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 16),
            
            // Notes
            Text('Notes (optional)', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                hintText: 'Additional notes...',
              ),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveBodyFat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondary,
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBodyFat() async {
    final bodyFat = double.tryParse(_bodyFatController.text);
    if (bodyFat == null || bodyFat <= 0 || bodyFat > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid body fat percentage')),
      );
      return;
    }

    final db = ref.read(databaseProvider);
    await db.into(db.bodyFatLogs).insert(
      BodyFatLogsCompanion.insert(
        logDate: DateTime.now(),
        bodyFatPercent: bodyFat,
        method: Value(_selectedMethod),
        notes: Value(_notesController.text.isNotEmpty ? _notesController.text : null),
      ),
    );

    widget.onSaved();
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Body fat logged!')),
      );
    }
  }

  @override
  void dispose() {
    _bodyFatController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
