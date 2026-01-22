# Forge - LLM Reference Document

> **Purpose**: Single source of truth for AI assistants working on this codebase.
> **Last updated**: 2026-01-20

## Quick Links
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Screens & Navigation](#screens--navigation)
- [Recent Features](#recent-features)
- [Architectural Considerations](#architectural-considerations-for-future-changes)

---

## Tech Stack
- **Framework**: Flutter 3.x (iOS, Android, macOS, Web)
- **State Management**: Riverpod
- **Database**: Drift (SQLite) with code generation
- **Charts**: fl_chart
- **Animations**: flutter_animate
- **Theme**: Premium dark brown aesthetic

---

## Project Structure

```
forge/
├── lib/
│   ├── main.dart                    # App entry, MainNavigationScreen, HomeScreen
│   ├── core/
│   │   ├── database/
│   │   │   ├── database.dart        # Drift schema & seed data
│   │   │   ├── database.g.dart      # Generated
│   │   │   └── connection/          # Platform-specific DB connections
│   │   ├── theme/
│   │   │   └── app_theme.dart       # Dark brown theme with warm accents
│   │   └── widgets/                 # Shared widgets
│   └── features/
│       ├── exercise/
│       │   ├── presentation/screens/
│       │   │   ├── exercise_home_screen.dart   # History, stats, body part volume
│       │   │   ├── workout_session_screen.dart # Active workout logging
│       │   │   └── exercise_history_screen.dart
│       │   └── presentation/widgets/
│       │       ├── exercise_picker.dart        # Multi-muscle selection
│       │       ├── set_logger.dart
│       │       └── edit_exercise_log_dialog.dart
│       ├── nutrition/
│       │   ├── presentation/screens/
│       │   │   ├── nutrition_home_screen.dart  # Macro chart, food list
│       │   │   └── manual_food_log_screen.dart # Manual food entry
│       │   └── presentation/widgets/
│       │       ├── supplement_alcohol_sheets.dart
│       │       └── edit_food_log_dialog.dart   # Edit existing food logs
│       ├── finance/
│       │   └── presentation/screens/finance_home_screen.dart
│       └── body/
│           └── presentation/screens/body_tracking_screen.dart
├── LLM_REFERENCE.md                 # This file
├── TODO.md                          # Feature backlog
└── CHANGELOG.md
```

---

## Database Schema

### Exercise Tables
| Table | Key Columns | Notes |
|-------|-------------|-------|
| `exercises` | id, name, category, muscleGroup, isCardio, **cardioType** | muscleGroup is comma-separated for multi-muscle exercises. cardioType: LISS/HIIT |
| `exercise_logs` | id, logDate, exerciseId, sets, reps, weight, durationMinutes, distanceKm, notes | Cardio uses durationMinutes & distanceKm |

### Nutrition Tables
| Table | Key Columns | Notes |
|-------|-------------|-------|
| `foods` | id, name, barcode, calories, protein, carbs, fat, servingSize, source | source: custom, openfoodfacts, usda |
| `food_logs` | id, logDate, foodId, servings, mealType | mealType: Breakfast/Lunch/Dinner/Snack |
| `supplements` | id, name, type, dosageUnit | |
| `supplement_logs` | id, logDate, supplementId, dosage | |
| `alcohol_logs` | id, logDate, drinkType, units, calories | |

### Finance Tables
| Table | Key Columns | Notes |
|-------|-------------|-------|
| `expense_categories` | id, name, icon, color, isFoodRelated | isFoodRelated for cross-domain insights |
| `expenses` | id, logDate, categoryId, amount, description | |

### Body Tracking Tables
| Table | Key Columns | Notes |
|-------|-------------|-------|
| `weight_logs` | id, logDate, weightKg, notes | |
| `body_fat_logs` | id, logDate, bodyFatPercent, method | method: scale, caliper, dexa, estimate |

---

## Screens & Navigation

### Bottom Navigation (4 tabs)
1. **Home** - Today's summary, quick actions, dynamic insights
2. **Exercise** - Weekly stats, workout history, body part volume
3. **Nutrition** - Macro chart, food logs, supplements
4. **Finance** - Spending breakdown, expense list

### Key Flows
- **Log Workout**: Home → Start Workout → Add Exercises → Finish
- **Log Food**: Home/Nutrition → Manual Food Log → Save
- **Edit Food Log**: Nutrition → Tap food item → Edit Dialog
- **Edit Exercise Log**: Exercise History → Tap log → Edit Dialog
- **Backdate Workout**: Exercise → Start → "Log Past Workout" → Pick Date

---

## Recent Features (2026-01-22)

### Food Planner Mode (NEW)
- **Toggle**: Button in Nutrition header switches between logging and planning modes
- **Split View**: In planning mode, macro ring splits into Target vs Actual cards
- **Checkboxes**: Each food item shows checkbox to mark as eaten/not eaten
- **Visual Feedback**: Uneaten items appear muted with strikethrough
- **Database**: Schema v3 added `isEaten` column to `food_logs` table

### PWA & Web Support
- **Architecture**: Web-compatible database layout using WASM/IndexedDB.
- **Deployment**: Automatic GitHub Actions workflow (`deploy.yml`) to GitHub Pages.
- **Data Persistence**: Uses `idb_shim` for consistent storage on Web.

### Cross-Platform Backup & Restore
- **Export**: Full JSON dump of all tables (exercises, logs, foods, settings).
- **Import**: Type-safe restoration using `insertOnConflictUpdate`.
- **Method**:
  - **Native**: `Share.shareXFiles` (AirDrop, Save to Files, etc.)
  - **Web**: Browser file download (`html.AnchorElement`).
  - **Input**: `FilePicker` works on both platforms.

### Home Dashboard 2.0
- **7-Day Averages**: Automatically tracks and displays weekly average:
  - Calories Eaten (Nutrition)
  - Calories Burnt (Exercise - derived)
  - Daily Spending (Finance)
- Real-time weekly stats calculation on `_loadHomeData`.

### Exercise Updates
- **Sets vs Volume**: "Body Part Volume" changed to "Sets by Muscle Group".
- **Logic Change**: Sets are fully attributed to each targeted muscle (Bench 3 sets = Chest 3 sets + Triceps 3 sets).
- **Database**: Migration v2 added `cardio_type` column.

### Finance Deletion
- Swipe-to-delete implemented on expense list.
- Undo functionality via SnackBar.

### Settings: Exercise Management
- **Manage Exercises Screen**: View, search, add, and edit exercises from Settings.
- **ExerciseEditorDialog**: Create custom exercises or fix muscle group assignments.
- **Database**: Supports adding/editing name, category, muscle groups, and cardio types (LISS/HIIT).

### Insights Page 2.0
- **InsightsHomeScreen**: Dedicated screen accessible from "Insight of the Day" card on Home.
- **Time Filters**: 7 Days / 30 Days / All Time toggle.
- **Finance Metrics**: Rs/100 kcal, Rs/10g protein.
- **Food Efficiency**: Best Protein/Rs, Best Calories/Rs (requires food cost entry).
- **Macro Breakdown**: Highest/Lowest protein % foods.
- **Auto-Calories**: Calories auto-calculated from macros (P*4 + C*4 + F*9) in food log form.

---

## Architectural Considerations for Future Changes

### 🔴 Firebase/Cloud Sync (DEPRECATED)
*Previous plan for Firebase sync has been replaced by the simpler Import/Export model for now.*

### 🟡 Cross-Platform File Handling
- **Constraint**: `dart:io` cannot be imported in web-compiled code.
- **Solution**: Use conditional imports (`backup_helper.dart` -> `backup_helper_web.dart` / `backup_helper_native.dart`).
- **Data Passing**: Always use `Uint8List` for file data in shared service layers.

---

## Architectural Considerations for Future Changes

### 🔴 Firebase/Cloud Sync (NEXT PRIORITY)

**Current compatibility: ✅ Good**
- Drift/SQLite already handles offline storage
- All tables have `id` as primary key

**Required schema additions:**
```dart
TextColumn get remoteId => text().nullable()();
IntColumn get syncStatus => integer().withDefault(const Constant(0))();
DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
```

**Sync architecture planned:**
- Write locally first (UI never waits for network)
- Queue changes in `SyncQueue` table
- Push when online, pull on app start
- Last-write-wins conflict resolution

### 🟡 Multi-User Support
- Add nullable `userId` column to all log tables
- Foods already have `createdBy`

### 🟢 Health App Integration
- Schema already uses standard units (kg, km)
- Compatible with Apple Health / Google Fit

---

## Code Conventions

### Database Regeneration
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Theme Colors
```dart
AppTheme.primary          // Warm brown
AppTheme.exerciseColor    // Green
AppTheme.nutritionColor   // Orange
AppTheme.financeColor     // Blue
AppTheme.insightsColor    // Purple
AppTheme.proteinColor, .carbsColor, .fatColor
```

### State Management
- Use `ConsumerWidget` / `ConsumerStatefulWidget`
- Database via `ref.read(databaseProvider)`

---

## Running the App

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run -d macos  # or ios, android, chrome
```
