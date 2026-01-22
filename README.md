# Forge ⚒️
> **Health, Finance, and Life Tracking for the Modern Optimist.**

Forge is a cross-platform (iOS, Android, Web, macOS) life-tracking application focusing on privacy-first data ownership. It unifies workout logging, nutrition tracking (with macro analysis), finance management, and body metrics into a single, cohesive, premium experience.

---

## 🔥 Features

### 💪 Exercise
- **Smart Tracking**: Auto-detection of workout types (Push/Pull/Legs/Cardio).
- **Multi-Muscle Sets**: Accurately tracks volume and sets distributed across multiple target muscle groups.
- **Cardio Support**: Dedicated LISS/HIIT tracking with distance and duration.
- **History & Trends**: Detailed analysis of your strength progress.

### 🍎 Nutrition
- **Food DB**: Built-in 20,000+ foods + Barcode Scanner support.
- **Macro Analysis**: Live ring charts for Protein, Carbs, and Fats.
- **Cost Analysis**: Tracks cost-per-gram of protein (₹/g) and cost-per-calorie metrics.

### 💰 Finance
- **Spending Tracker**: Categorized expense logging (Food, Transport, Gym, etc.).
- **Cross-Domain Insights**: Connects your spending to your health goals (e.g. "You spent ₹200 for every 10g of protein today").
- **Budgeting**: Weekly and monthly spending breakdown.

### 🛡️ Privacy & Backup
- **Offline First**: All data stored locally in SQLite.
- **Cross-Platform Backup**: Full JSON Export/Import support.
- **PWA Support**: Works seamlessly in the browser with IndexedDB persistence.

---

## 🛠️ Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Database**: Drift (SQLite + WASM)
- **UI**: Custom "Forged Dark" theme with `flutter_animate` and glassmorphism.
- **Charts**: `fl_chart`

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.x+)
- Dart (3.x+)

### Installation
```bash
# Clone the repo
git clone https://github.com/yourusername/forge.git

# Install dependencies
flutter pub get

# Generate database code
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run -d macos # or ios/web
```
