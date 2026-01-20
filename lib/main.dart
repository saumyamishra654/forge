import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:drift/drift.dart' as drift;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/theme/app_theme.dart';
import 'core/database/database.dart';
import 'core/sync/sync.dart';
import 'firebase_options.dart';
import 'features/exercise/presentation/screens/exercise_home_screen.dart';
import 'features/exercise/presentation/screens/workout_session_screen.dart';
import 'features/nutrition/presentation/screens/nutrition_home_screen.dart';
import 'features/nutrition/presentation/screens/manual_food_log_screen.dart';
import 'features/finance/presentation/screens/finance_home_screen.dart';
import 'features/body/presentation/screens/body_tracking_screen.dart';

// Database provider
final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Sync repository provider
final syncRepositoryProvider = Provider<SyncRepository>((ref) => SyncRepository());

// Connectivity service provider
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
});

// Sync engine provider
final syncEngineProvider = Provider<SyncEngine>((ref) {
  final engine = SyncEngine(
    database: ref.read(databaseProvider),
    syncRepository: ref.read(syncRepositoryProvider),
    connectivityService: ref.read(connectivityServiceProvider),
  );
  ref.onDispose(() => engine.dispose());
  return engine;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized');
  } catch (e) {
    debugPrint('❌ Firebase init failed: $e');
  }

  Animate.restartOnHotReload = true;
  runApp(const ProviderScope(child: ForgeApp()));
}

class ForgeApp extends StatelessWidget {
  const ForgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ExerciseHomeScreen(),
    const NutritionHomeScreen(),
    const FinanceHomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home'),
                _buildNavItem(1, Icons.fitness_center_rounded, 'Exercise'),
                _buildNavItem(2, Icons.restaurant_rounded, 'Nutrition'),
                _buildNavItem(3, Icons.account_balance_wallet_rounded, 'Finance'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Home Dashboard Screen
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _calories = 0;
  int _protein = 0;
  double _spending = 0;
  // bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    final db = ref.read(databaseProvider);
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Fetch Food Logs
    final foodLogsQuery = db.select(db.foodLogs).join([
      drift.innerJoin(db.foods, db.foods.id.equalsExp(db.foodLogs.foodId)),
    ])..where(db.foodLogs.logDate.isBetweenValues(startOfDay, endOfDay));

    final foodLogs = await foodLogsQuery.get();
    
    int totalCals = 0;
    int totalProt = 0;

    for (var row in foodLogs) {
      final food = row.readTable(db.foods);
      final log = row.readTable(db.foodLogs);
      totalCals += (food.calories * log.servings).round();
      totalProt += (food.protein * log.servings).round();
    }

    // Fetch Expenses
    final expenses = await (db.select(db.expenses)
      ..where((tbl) => tbl.logDate.isBetweenValues(startOfDay, endOfDay)))
      .get();
      
    final totalSpent = expenses.fold(0.0, (sum, e) => sum + e.amount);

    if (mounted) {
      setState(() {
        _calories = totalCals;
        _protein = totalProt;
        _spending = totalSpent;
        // _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ensure SyncEngine is running
    ref.watch(syncEngineProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _loadHomeData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                      _getGreeting(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Forge',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.insights_rounded,
                    color: AppTheme.insightsColor,
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
            
            const SizedBox(height: 24),
            
            // Today's Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: Colors.white70, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Today',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryStat(context, '$_calories', 'Calories', AppTheme.nutritionColor),
                      _buildSummaryStat(context, '${_protein}g', 'Protein', AppTheme.proteinColor),
                      _buildSummaryStat(context, '₹${_spending.toStringAsFixed(0)}', 'Spent', AppTheme.financeColor),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ).animate().fadeIn(delay: 200.ms),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    context,
                    Icons.fitness_center_rounded,
                    'Log Workout',
                    AppTheme.exerciseGradient,
                    () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const WorkoutSessionScreen()),
                      );
                      if (result == true) _loadHomeData();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    context,
                    Icons.restaurant_rounded,
                    'Log Food',
                    AppTheme.nutritionGradient,
                    () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ManualFoodLogScreen()),
                      );
                      if (result == true) _loadHomeData();
                    },
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 250.ms, duration: 400.ms),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    context,
                    Icons.receipt_long_rounded,
                    'Log Expense',
                    AppTheme.financeGradient,
                    () async {
                      final result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const AddExpenseSheet(),
                      );
                      if (result == true) _loadHomeData();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    context,
                    Icons.monitor_weight_rounded,
                    'Body Stats',
                    AppTheme.primaryGradient,
                    () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BodyTrackingScreen()),
                      );
                      _loadHomeData();
                    },
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
            
            const SizedBox(height: 24),
            
            // Cross-Domain Insight Card
            Text(
              'Insight of the Day',
              style: Theme.of(context).textTheme.titleMedium,
            ).animate().fadeIn(delay: 350.ms),
            
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.insightsColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.insightsColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.lightbulb_rounded,
                      color: AppTheme.insightsColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Start tracking to unlock insights!',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Log food and expenses to see ₹/calorie and ₹/protein metrics',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.1),
            
            const SizedBox(height: 24),
            
            // Cloud Sync Section
            Text(
              'Cloud Sync',
              style: Theme.of(context).textTheme.titleMedium,
            ).animate().fadeIn(delay: 450.ms),
            
            const SizedBox(height: 12),
            
            _buildSyncCard(context),
          ],
        ),
      ),
    ));
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildSummaryStat(BuildContext context, String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, LinearGradient gradient, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
                gradient: gradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncCard(BuildContext context) {
    final authService = ref.read(authServiceProvider);
    final authState = ref.watch(authStateProvider); // Listen for changes
    final syncRepo = ref.read(syncRepositoryProvider);
    
    // Use authState.value for current user instead of just authService.currentUser
    final user = authState.value;
    final isAuthenticated = user != null;
    final isAnonymous = user?.isAnonymous ?? false;
    final displayName = user?.displayName ?? user?.email ?? 'Anonymous';
    final email = user?.email;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isAuthenticated ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                color: isAuthenticated ? Colors.green : AppTheme.textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAuthenticated 
                        ? 'Signed in as $displayName'
                        : 'Not signed in',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    if (email != null && !isAnonymous)
                      Text(
                        email,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (!isAuthenticated) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        await authService.signInAnonymously();
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('❌ Error: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.person_outline),
                    label: const Text('Anonymous'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await authService.signInWithGoogle();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                             const SnackBar(content: Text('✅ Signed in with Google!')),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('❌ Error: $e')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.g_mobiledata_rounded),
                    label: const Text('Google'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final success = await syncRepo.testConnection();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(success 
                              ? '✅ Firestore connected!' 
                              : '❌ Firestore connection failed'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.sync),
                    label: const Text('Test Sync'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await authService.signOut();
                      setState(() {});
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 500.ms, duration: 400.ms).slideY(begin: 0.1);
  }
}
