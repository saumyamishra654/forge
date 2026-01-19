# Forge - LLM Reference Document

> **Purpose**: Single source of truth for AI assistants working on this codebase.

## Quick Links
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Screens & Navigation](#screens--navigation)
- [Architectural Considerations](#architectural-considerations-for-future-changes)

---

## Tech Stack
- **Framework**: Flutter 3.x (iOS, Android, Web)
- **State Management**: Riverpod
- **Database**: Drift (SQLite) with code generation
- **Charts**: fl_chart
- **Barcode/OCR**: google_mlkit_barcode_scanning, google_mlkit_text_recognition
- **Food APIs**: OpenFoodFacts, USDA FoodData Central

---

## Project Structure

```
forge/
├── lib/
│   ├── main.dart                    # App entry, MainNavigationScreen
│   ├── core/
│   │   ├── database/
│   │   │   ├── database.dart        # Drift schema & seed data
│   │   │   └── database.g.dart      # Generated
│   │   ├── theme/
│   │   │   └── app_theme.dart       # Premium dark theme
│   │   ├── widgets/                 # Shared widgets
│   │   └── utils/                   # Helpers, formatters
│   └── features/
│       ├── exercise/
│       │   ├── presentation/screens/exercise_home_screen.dart
│       │   └── presentation/widgets/{exercise_picker, set_logger}.dart
│       ├── nutrition/
│       │   └── presentation/screens/nutrition_home_screen.dart
│       ├── food_database/           # Barcode scanner, OCR, API sources
│       ├── finance/
│       │   └── presentation/screens/finance_home_screen.dart
│       ├── insights/
│       │   └── presentation/screens/insights_home_screen.dart
│       └── body/                    # Weight & body fat tracking
│           └── presentation/screens/body_tracking_screen.dart
├── assets/
│   ├── icons/
│   └── foods/                       # Seeded food images
├── LLM_REFERENCE.md                 # This file
├── CHANGELOG.md
└── TODO.md
```

---

## Database Schema

### Exercise Tables
| Table | Columns | Purpose |
|-------|---------|---------|
| `exercises` | id, name, category, muscleGroup, isCardio | Exercise definitions |
| `exercise_logs` | id, logDate, exerciseId, sets, reps, weight, durationMinutes, distanceKm, notes | Workout log entries |

### Nutrition Tables
| Table | Columns | Purpose |
|-------|---------|---------|
| `foods` | id, name, barcode, calories, protein, carbs, fat, fiber, sugar, servingSize, servingUnit, source, imageUrl, verified, createdBy | Food database (seed + user contributed) |
| `food_logs` | id, logDate, foodId, servings, mealType | Daily food intake |
| `supplements` | id, name, type, dosageUnit | Supplement definitions |
| `supplement_logs` | id, logDate, supplementId, dosage | Supplement intake log |
| `alcohol_logs` | id, logDate, drinkType, units, calories, volumeMl | Alcohol consumption |

### Finance Tables
| Table | Columns | Purpose |
|-------|---------|---------|
| `expense_categories` | id, name, icon, color, isFoodRelated | Categories with food flag for cross-domain |
| `expenses` | id, logDate, categoryId, amount, description, linkedFoodLogId | Expense entries with optional food link |

### Body Tracking Tables (NEW)
| Table | Columns | Purpose |
|-------|---------|---------|
| `weight_logs` | id, logDate, weightKg, notes | Daily weight tracking |
| `body_fat_logs` | id, logDate, bodyFatPercent, method, notes | Body fat measurements |

### Cross-Domain Relationships
- `expenses.linkedFoodLogId` → `food_logs.id` (optional link for ₹/calorie calculation)
- `expense_categories.isFoodRelated` → flags categories for nutrition-finance insights

---

## Screens & Navigation

### Bottom Navigation Tabs
1. **Home** (`HomeScreen`)
   - Today's summary (calories, protein, spend)
   - Quick action buttons
   - Insight of the day card

2. **Exercise** (`ExerciseHomeScreen`)
   - Date picker
   - Workout stats (exercises, sets, volume)
   - Exercise log list
   - Add exercise bottom sheet with ExercisePicker + SetLogger

3. **Nutrition** (`NutritionHomeScreen`)
   - Macro ring chart (P/C/F)
   - Daily/weekly averages
   - Food log list
   - Barcode scanner integration

4. **Finance** (`FinanceHomeScreen`)
   - Category pie chart
   - Daily expense list
   - Expense trends

### Modal Sheets
- `AddExerciseSheet` - Exercise picker with category filter, last weight auto-fill
- `AddFoodSheet` - Text search + barcode scanner
- `AddExpenseSheet` - Category picker, amount input
- `BarcodeScannerScreen` - Full screen camera for scanning

---

## Key Features Implementation

### Auto-fill Last Weight
```dart
// In ExercisePicker._getLastWeight()
final logs = await (db.select(db.exerciseLogs)
  ..where((t) => t.exerciseId.equals(exerciseId))
  ..orderBy([(t) => OrderingTerm.desc(t.logDate)])
  ..limit(1))
  .get();
```

### Cross-Domain Metrics
```dart
// ₹/Calorie = Food expenses ÷ Total calories
// ₹/Protein = Food expenses ÷ Total protein (g)
// Gym ROI = Fitness expenses ÷ Workout count
```

### Food Source Fallback Chain
1. Local DB (barcode lookup)
2. OpenFoodFacts API
3. USDA FoodData Central
4. User contribution (OCR from label photo)

---

## Architectural Considerations for Future Changes

### 🔴 Firebase/Cloud Sync (HIGH PRIORITY)
**Prepare now:**
- All tables have local `id` as primary key
- Add `syncStatus` enum (local, syncing, synced) column when ready
- Add `remoteId` nullable column for Firebase document IDs
- Store `createdAt` and `updatedAt` timestamps on all logs

**Migration path:**
```dart
// Future: Add to all log tables
TextColumn get remoteId => text().nullable()();
IntColumn get syncStatus => intEnum<SyncStatus>().withDefault(const Constant(0))();
DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
```

### 🟡 Multi-User Support
**Prepare now:**
- All log tables should have nullable `userId` column
- Foods contributed by users need `createdBy` (already exists)

### 🟡 Data Export
**Prepare now:**
- Centralized repository pattern for each feature
- Clean separation of data models from UI

### 🟢 Goal Setting & Reminders
**Prepare now:**
- No special preparation needed
- Can add `goals` table later with target dates

### 🟢 Apple Health / Google Fit
**Prepare now:**
- Keep exercise_logs and weight_logs structure compatible
- Standard units (kg for weight, km for distance)

---

## Code Conventions

### File Naming
- Screens: `*_screen.dart` in `presentation/screens/`
- Widgets: snake_case in `presentation/widgets/`
- Models: singular noun in `data/models/`
- Repositories: `*_repository.dart` in `data/repositories/`

### State Management
- Use `ConsumerWidget` / `ConsumerStatefulWidget` for Riverpod
- Providers in `providers/` folder per feature
- Database provider in `main.dart`: `databaseProvider`

### Theme Usage
```dart
// Colors
AppTheme.primary, AppTheme.exerciseColor, AppTheme.nutritionColor, etc.

// Gradients
AppTheme.primaryGradient, AppTheme.exerciseGradient, etc.

// Background colors
AppTheme.background, AppTheme.surface, AppTheme.card
```

---

## Running the App

```bash
# Install dependencies
flutter pub get

# Generate Drift code
dart run build_runner build --delete-conflicting-outputs

# Run on device/emulator
flutter run
```

---

*Last updated: 2026-01-19*
