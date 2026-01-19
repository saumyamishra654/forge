import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';

class SetData {
  final int reps;
  final double weight;
  final bool completed;
  
  SetData({required this.reps, required this.weight, this.completed = false});
  
  SetData copyWith({int? reps, double? weight, bool? completed}) {
    return SetData(
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      completed: completed ?? this.completed,
    );
  }
}

class SetLogger extends StatefulWidget {
  final Exercise exercise;
  final double? initialWeight;
  final List<SetData>? initialSets;
  final Function(List<SetData>) onSetsChanged;
  
  const SetLogger({
    super.key,
    required this.exercise,
    this.initialWeight,
    this.initialSets,
    required this.onSetsChanged,
  });

  @override
  State<SetLogger> createState() => _SetLoggerState();
}

class _SetLoggerState extends State<SetLogger> {
  final List<SetData> _sets = [];
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Load initial sets if editing
    if (widget.initialSets != null) {
      _sets.addAll(widget.initialSets!);
    }
    // Pre-fill with last weight if available
    if (widget.initialWeight != null) {
      _weightController.text = widget.initialWeight.toString();
    } else if (widget.initialSets?.isNotEmpty == true) {
      _weightController.text = widget.initialSets!.last.weight.toString();
    }
    _repsController.text = '10'; // Default reps
  }

  void _addSet() {
    final weight = double.tryParse(_weightController.text) ?? 0;
    final reps = int.tryParse(_repsController.text) ?? 0;
    
    if (weight > 0 && reps > 0) {
      setState(() {
        _sets.add(SetData(reps: reps, weight: weight));
      });
      widget.onSetsChanged(_sets);
      HapticFeedback.lightImpact();
    }
  }

  void _removeSet(int index) {
    setState(() {
      _sets.removeAt(index);
    });
    widget.onSetsChanged(_sets);
  }

  void _toggleComplete(int index) {
    setState(() {
      _sets[index] = _sets[index].copyWith(completed: !_sets[index].completed);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              // Weight Input
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight (kg)',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _weightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: InputDecoration(
                        hintText: '0',
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        filled: true,
                        fillColor: AppTheme.surfaceLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Reps Input
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reps',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _repsController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: InputDecoration(
                        hintText: '0',
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        filled: true,
                        fillColor: AppTheme.surfaceLight,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Add Button
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('', style: TextStyle(fontSize: 12)), // Spacer
                  const SizedBox(height: 8),
                  IconButton(
                    onPressed: _addSet,
                    icon: const Icon(Icons.add_rounded),
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.exerciseColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Sets List Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Sets',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              if (_sets.isNotEmpty)
                Text(
                  'Total: ${_calculateVolume()} kg',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.exerciseColor,
                  ),
                ),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Sets List
        Expanded(
          child: _sets.isEmpty
              ? Center(
                  child: Text(
                    'Add your first set',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _sets.length,
                  itemBuilder: (context, index) {
                    return _buildSetCard(index);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildSetCard(int index) {
    final set = _sets[index];
    final volume = set.reps * set.weight;
    
    return Dismissible(
      key: Key('set_$index'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _removeSet(index),
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppTheme.error.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_rounded, color: AppTheme.error),
      ),
      child: GestureDetector(
        onTap: () => _toggleComplete(index),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: set.completed 
                ? AppTheme.success.withOpacity(0.15) 
                : AppTheme.card,
            borderRadius: BorderRadius.circular(12),
            border: set.completed 
                ? Border.all(color: AppTheme.success.withOpacity(0.3))
                : null,
          ),
          child: Row(
            children: [
              // Set Number
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: set.completed 
                      ? AppTheme.success 
                      : AppTheme.surfaceLight,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: set.completed
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
                    : Text(
                        '${index + 1}',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
              ),
              const SizedBox(width: 16),
              // Weight & Reps
              Expanded(
                child: Row(
                  children: [
                    _buildSetDetail(Icons.fitness_center_rounded, '${set.weight} kg'),
                    const SizedBox(width: 24),
                    _buildSetDetail(Icons.repeat_rounded, '${set.reps} reps'),
                  ],
                ),
              ),
              // Volume
              Text(
                '${volume.toStringAsFixed(1)} kg',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppTheme.exerciseColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetDetail(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppTheme.textMuted),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }

  double _calculateVolume() {
    return _sets.fold(0.0, (sum, set) => sum + (set.reps * set.weight));
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }
}
