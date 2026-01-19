import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/database/database.dart';
import '../../../../main.dart';
import '../../data/food_repository.dart';

/// Provider for food repository
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepository(ref.watch(databaseProvider));
});

class FoodSearchScreen extends ConsumerStatefulWidget {
  const FoodSearchScreen({super.key});

  @override
  ConsumerState<FoodSearchScreen> createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends ConsumerState<FoodSearchScreen> {
  final _searchController = TextEditingController();
  List<FoodSearchResult> _searchResults = [];
  bool _isSearching = false;
  bool _showScanner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Add Food'),
        actions: [
          IconButton(
            onPressed: () => setState(() => _showScanner = !_showScanner),
            icon: Icon(_showScanner ? Icons.search : Icons.qr_code_scanner),
          ),
        ],
      ),
      body: _showScanner ? _buildScannerView() : _buildSearchView(),
    );
  }

  Widget _buildSearchView() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: 'Search foods...',
              prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchResults = []);
                      },
                    )
                  : null,
            ),
          ),
        ),
        
        // Results
        Expanded(
          child: _isSearching
              ? const Center(child: CircularProgressIndicator())
              : _searchResults.isEmpty
                  ? _buildEmptyState()
                  : _buildResultsList(),
        ),
      ],
    );
  }

  Widget _buildScannerView() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primary, width: 2),
            ),
            clipBehavior: Clip.hardEdge,
            child: MobileScanner(
              onDetect: _onBarcodeDetected,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.qr_code_scanner, size: 48, color: AppTheme.primary),
              const SizedBox(height: 12),
              Text(
                'Scan a barcode',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Point your camera at a product barcode',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: AppTheme.nutritionColor.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Search for foods',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Or scan a barcode to find products',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildResultsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return _buildFoodCard(result);
      },
    );
  }

  Widget _buildFoodCard(FoodSearchResult result) {
    final food = result.food;
    final sourceLabel = result.source == FoodSource.local 
        ? 'Local' 
        : 'OpenFoodFacts';
    final sourceColor = result.source == FoodSource.local 
        ? AppTheme.success 
        : AppTheme.accent;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showFoodSheet(result),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Food Icon
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.nutritionColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.restaurant_rounded,
                  color: AppTheme.nutritionColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              
              // Food Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.name,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${food.calories.toStringAsFixed(0)} kcal',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.nutritionColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${food.protein.toStringAsFixed(1)}g protein',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Source Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: sourceColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  sourceLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: sourceColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  void _onSearchChanged(String query) async {
    if (query.length < 2) {
      setState(() => _searchResults = []);
      return;
    }
    
    setState(() => _isSearching = true);
    
    try {
      final repo = ref.read(foodRepositoryProvider);
      final results = await repo.searchFoods(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  void _onBarcodeDetected(BarcodeCapture capture) async {
    final barcode = capture.barcodes.firstOrNull?.rawValue;
    if (barcode == null) return;
    
    // Pause scanner to prevent multiple scans
    setState(() => _showScanner = false);
    
    // Lookup barcode
    final repo = ref.read(foodRepositoryProvider);
    final result = await repo.lookupBarcode(barcode);
    
    if (result != null && mounted) {
      _showFoodSheet(result);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product not found: $barcode'),
          action: SnackBarAction(
            label: 'Add Manually',
            onPressed: () => _showManualAddSheet(barcode),
          ),
        ),
      );
    }
  }

  void _showFoodSheet(FoodSearchResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LogFoodSheet(result: result),
    );
  }

  void _showManualAddSheet(String barcode) {
    // TODO: Implement manual food addition with OCR
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Manual add coming soon!')),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

/// Bottom sheet for logging a food
class LogFoodSheet extends ConsumerStatefulWidget {
  final FoodSearchResult result;
  
  const LogFoodSheet({super.key, required this.result});

  @override
  ConsumerState<LogFoodSheet> createState() => _LogFoodSheetState();
}

class _LogFoodSheetState extends ConsumerState<LogFoodSheet> {
  final _servingsController = TextEditingController(text: '1');
  String _selectedMeal = 'lunch';
  
  final _meals = [
    ('breakfast', 'Breakfast', Icons.wb_sunny_rounded),
    ('lunch', 'Lunch', Icons.restaurant_rounded),
    ('dinner', 'Dinner', Icons.nightlight_rounded),
    ('snack', 'Snack', Icons.cookie_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final food = widget.result.food;
    final servings = double.tryParse(_servingsController.text) ?? 1;
    
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
            
            // Food Name
            Text(
              food.name,
              style: Theme.of(context).textTheme.headlineSmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              'Per ${food.servingSize}${food.servingUnit}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            
            const SizedBox(height: 20),
            
            // Macro Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMacro('Calories', (food.calories * servings).toStringAsFixed(0), 'kcal', AppTheme.nutritionColor),
                  _buildMacro('Protein', (food.protein * servings).toStringAsFixed(1), 'g', AppTheme.proteinColor),
                  _buildMacro('Carbs', (food.carbs * servings).toStringAsFixed(1), 'g', AppTheme.carbsColor),
                  _buildMacro('Fat', (food.fat * servings).toStringAsFixed(1), 'g', AppTheme.fatColor),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Servings
            Text('Servings', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    final current = double.tryParse(_servingsController.text) ?? 1;
                    if (current > 0.5) {
                      _servingsController.text = (current - 0.5).toStringAsFixed(1);
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                  color: AppTheme.primary,
                ),
                Expanded(
                  child: TextField(
                    controller: _servingsController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final current = double.tryParse(_servingsController.text) ?? 1;
                    _servingsController.text = (current + 0.5).toStringAsFixed(1);
                    setState(() {});
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  color: AppTheme.primary,
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Meal Type
            Text('Meal', style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _meals.map((meal) {
                final isSelected = _selectedMeal == meal.$1;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMeal = meal.$1),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? AppTheme.nutritionColor.withValues(alpha: 0.2)
                              : AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected 
                              ? Border.all(color: AppTheme.nutritionColor)
                              : null,
                        ),
                        child: Icon(
                          meal.$3,
                          color: isSelected ? AppTheme.nutritionColor : AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meal.$2,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isSelected ? AppTheme.nutritionColor : AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Log Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _logFood,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.nutritionColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Log Food'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacro(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          unit,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  Future<void> _logFood() async {
    final servings = double.tryParse(_servingsController.text) ?? 1;
    if (servings <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid servings')),
      );
      return;
    }

    final repo = ref.read(foodRepositoryProvider);
    final food = widget.result.food;
    
    // If from API, save to local database first
    int foodId = food.id;
    if (widget.result.source != FoodSource.local && food.id == 0) {
      foodId = await repo.saveFood(food);
    }
    
    // Log the food
    await repo.logFood(
      foodId: foodId,
      servings: servings,
      mealType: _selectedMeal,
    );

    if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context); // Close search screen too
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Food logged!')),
      );
    }
  }

  @override
  void dispose() {
    _servingsController.dispose();
    super.dispose();
  }
}
