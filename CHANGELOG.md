# Changelog

All notable changes to Forge will be documented in this file.

## [0.3.1] - 2026-01-22

### Added
- **Food Planner Mode**
  - Toggle button in Nutrition header to switch between logging and planning modes
  - Split macro view showing **Target** (all planned food) vs **Actual** (eaten food only)
  - Checkboxes on food items to mark as eaten/not eaten
  - Visual feedback: uneaten items appear muted with strikethrough text
  - Database schema v3: Added `isEaten` column to `FoodLogs` table

- **Macro Editing in Food Log**
  - Edit dialog now has toggle to edit base macros (calories, protein, carbs, fat)
  - Updates both the log and the underlying food record when saved

- **Alcohol Logs Display**
  - Alcohol logs now appear in Nutrition screen under food/supplements
  - Alcohol calories added to daily totals
  - Tap to edit: change drink type, volume, units, or delete

- **Alcohol Macros Tracking**
  - Beer ~12g carbs, Wine ~4g carbs per serving (auto-calculated)
  - Carbs from alcohol now included in daily macro totals
  - Database schema v4: Added protein, carbs, fat columns to `AlcoholLogs`
  - **Planning Mode**: Alcohol logs now have checkboxes like food items (schema v5)
  - Unchecked alcohol items do not count towards "Actual" totals

### Fixed
- Food card now shows macros multiplied by serving size (was showing base values)

## [0.3.0] - 2026-01-21

### Added
- **Cross-Platform Backup & Restore**
  - Full JSON export/import of all database tables
  - Platform-agnostic implementation using `share_plus` (Native) and file download (Web)
  - Type-safe restoration with `insertOnConflictUpdate`
  - Added Backup/Restore buttons to Settings screen

- **PWA Support**
  - Replaced `dart:io` dependencies with conditional imports
  - Configured GitHub Actions for automated web deployment
  - Optimized database connection for Web (WASM/IndexedDB)

- **Home Dashboard Enhancements**
  - **7-Day Averages Card**: Shows average Calories Eaten, Calories Burnt (est.), and Daily Spending
  - Integrated real-time weekly stats calculation

- **Finance Module**
  - **Swipe-to-Delete**: Added ability to delete expenses with swipe gesture
  - **Undo Deletion**: SnackBar action to restore accidentally deleted expenses

- **Settings: Exercise Management**
  - New `ManageExercisesScreen` to view, search, add, and edit exercises directly from Settings
  - `ExerciseEditorDialog` for adding custom exercises or fixing muscle group assignments
  - Supports full editing of name, category, multi-select muscle groups, and cardio types (LISS/HIIT)

- **Insights Page 2.0**
  - New `InsightsHomeScreen` with time filters (7 Days / 30 Days / All Time)
  - Finance metrics: Rs/100 kcal, Rs/10g protein
  - Food efficiency: Best Protein/Rs, Best Calories/Rs
  - Macro breakdown: Highest/Lowest protein % foods
  - Auto-calculate calories from macros (P*4 + C*4 + F*9)

### Changed
- **Exercise Home Screen**
  - Changed "Volume by Body Part" to **"Sets by Muscle Group"** display
  - Improved set counting logic: Sets are now fully attributed to each targeted muscle group (e.g., Bench Press counts for both Chest and Triceps)
  - Fixed rounding errors in volume distribution

### Fixed
- **Database Schema**: Added migration for `cardio_type` column (Schema v2) to prevent crashes on existing installs
- **Backup Service**: Fixed variable scope issue in restore logic
- **Food Logging**: Fixed missing `linkedFoodLogId` when creating expense from food cost

## [0.2.0] - 2026-01-19

### Added
- **Food Search & Barcode Scanner**
  - FoodRepository with local database search and OpenFoodFacts API integration
  - Barcode scanner screen using mobile_scanner
  - Food search with text query and API fallback
  - Food logging sheet with servings selector and meal type picker
  - Meal types: breakfast, lunch, dinner, snack
  - Auto-cache API results to local database

- **Supplement & Alcohol Logging**
  - Supplement logging sheet with database supplements list
  - Alcohol logging sheet with drink type presets (beer/wine/whiskey/vodka/cocktail)
  - Calorie estimation for alcohol based on type and volume

- **Cross-Domain Insights**
  - InsightsRepository with real calculations
  - ₹/calorie metric (food spend / calories consumed)
  - ₹/gram protein metric
  - ₹/workout metric (fitness spend / workout count)
  - Motivational messages based on user data
  - Summary stats panel with totals

- **Workout Session Screen** (NEW)
  - Full-screen workout with real-time stats (duration, exercises, sets, volume)
  - Manual calorie input field
  - Add/edit/delete exercises during workout
  - Confirmation dialog before discarding
  - Saves all exercise logs on finish

### Fixed
- **Workout Session**: Fixed 'ReorderableListView' key error by adding unique session exercise IDs
- **UI**: Replaced floating action button with full-width bottom button for adding exercises
- Expense category loading (post-frame callback for proper ref.read timing)
- Added loading indicator for expense categories
- Fixed category chip color deprecation (withValues)

## [0.1.0] - 2026-01-19

### Added
- **Project Setup**
  - Initialized Flutter project with iOS, Android, Web platforms
  - Configured dependencies: Riverpod, Drift, fl_chart, mobile_scanner, google_mlkit
  - Created feature-first folder structure
  - Initialized git repo with remote origin

- **Core**
  - Drift database with full schema (exercises, foods, expenses, supplements, alcohol, weight, body fat)
  - Premium dark theme with Inter font and feature-specific gradients
  - Seeded 23 common exercises (Push/Pull/Legs/Cardio)
  - Seeded 26 common Indian foods with accurate macros
  - Seeded 10 expense categories with food-related flags
  - Seeded 10 common supplements

- **Exercise Module**
  - Exercise home screen with date picker and workout stats
  - Exercise picker with search and category filter chips
  - Set logger with weight/reps input
  - Auto-fill last used weight feature
  - Swipe to delete sets, tap to mark complete
  - Real-time volume calculation

- **Nutrition Module**
  - Nutrition home screen with macro ring chart (P/C/F)
  - Quick add buttons for food, supplements, alcohol
  - Barcode scanner button (placeholder)
  - Empty state with call to action

- **Finance Module**
  - Finance home screen with spending summary cards
  - Category breakdown pie chart
  - Add expense bottom sheet with category picker
  - Expense saving to database

- **Insights Module**
  - Insights home screen with placeholder metric cards
  - ₹/Calorie, ₹/Protein, Gym ROI metrics (coming soon)
  - Info card explaining how to unlock insights

- **Body Tracking**
  - WeightLogs and BodyFatLogs database tables
  - Body tracking screen with current stats display
  - Weight trend chart with line graph
  - Weight change indicator (gain/loss)
  - Add weight bottom sheet with notes
  - Add body fat bottom sheet with method selection (estimate/scale/caliper/DEXA)
  - Recent entries list with merged weight/body fat logs
  - Navigation from home screen "Body Stats" quick action

- **Navigation**
  - Bottom navigation with 4 tabs (Home, Exercise, Nutrition, Finance)
  - Animated tab switching
  - Custom nav bar with selected state styling

- **Home Dashboard**
  - Greeting based on time of day
  - Today's summary card (calories, protein, spend)
  - Quick action buttons for logging
  - Insight of the day placeholder

- **Documentation**
  - LLM_REFERENCE.md for AI assistant guidance
  - CHANGELOG.md (this file)
  - TODO.md for future ideas

### Technical Notes
- Database schema designed with Firebase sync in mind
- Cross-domain linking via `expenses.linkedFoodLogId` and `expense_categories.isFoodRelated`
- Food sources support: seed, openfoodfacts, usda, user_contributed, custom
