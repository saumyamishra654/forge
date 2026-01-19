# Changelog

All notable changes to Forge will be documented in this file.

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
