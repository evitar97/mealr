import 'package:flutter/cupertino.dart';

import '../models/food_item.dart';
import '../models/meal_prep_plan.dart';
import '../models/shopping_list.dart';
import '../models/theme_option.dart';
import '../models/weight_entry.dart';
import '../services/preferences_store.dart';
import '../theme/mealweight_theme.dart';
import '../utils/calculators.dart';

enum AppTab { foods, calories, bmi, profile }

enum WeightChartRange {
  days7(7),
  days30(30),
  days60(60);

  const WeightChartRange(this.days);

  final int days;
}

enum AppLanguage {
  english('en', 'English'),
  hungarian('hu', 'Magyar'),
  german('de', 'Deutsch'),
  spanish('es', 'Español');

  const AppLanguage(this.code, this.label);

  final String code;
  final String label;
}

enum WeightTrend { down, stable, up }

class WeightStats {
  const WeightStats({
    required this.totalChange,
    required this.sevenDayChange,
    required this.thirtyDayChange,
    required this.weeklyAverage,
    required this.trend,
    required this.lowestWeight,
  });

  final double totalChange;
  final double? sevenDayChange;
  final double? thirtyDayChange;
  final double weeklyAverage;
  final WeightTrend trend;
  final double lowestWeight;
}

class AppState extends ChangeNotifier {
  AppState({PreferencesStore preferences = const PreferencesStore()})
    : _preferences = preferences;

  final PreferencesStore _preferences;

  AppTab tab = AppTab.foods;
  bool isDark =
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;
  ThemeOption theme = themeOptions.firstWhere(
    (option) => option.id == 'forest',
    orElse: () => themeOptions.first,
  );
  AppLanguage language = AppLanguage.english;
  bool showOnboarding = true;
  bool isPro = false;
  DateTime? proExpiresAt;
  double bmiWeight = 78;
  double bmiHeight = 182;
  Gender bmiGender = Gender.male;
  bool bmiSaved = false;
  int calorieAge = 30;
  double calorieWeight = 70;
  double calorieHeight = 170;
  Gender calorieGender = Gender.male;
  double calorieActivity = 1.55;
  bool calorieSaved = false;
  double profileWeight = 78;
  double profileHeight = 182;
  int profileCalorieTarget = 2350;
  double weightTrackerInput = 78;
  WeightChartRange weightChartRange = WeightChartRange.days7;

  final List<FoodItem> foods = [];
  final List<MealPrepPlan> mealPrepPlans = [];
  final List<ShoppingList> shoppingLists = [];
  final List<WeightEntry> weightEntries = [];
  final Set<String> favoriteRecipeIds = {};

  static const int freeMealPrepPlanLimit = 1;

  MealWeightPalette get palette => isDark ? theme.dark : theme.light;

  Future<void> loadSavedPreferences() async {
    final themeId = await _preferences.loadThemeId();
    final languageCode = await _preferences.loadLanguageCode();
    var changed = false;
    if (themeId != null) {
      final savedTheme = _themeById(themeId);
      if (savedTheme != null) {
        theme = savedTheme;
        changed = true;
      }
    }
    if (languageCode != null) {
      final savedLanguage = _languageByCode(languageCode);
      if (savedLanguage != null) {
        language = savedLanguage;
        changed = true;
      }
    }
    if (changed) notifyListeners();
  }

  void selectTab(AppTab next) {
    tab = next;
    notifyListeners();
  }

  void toggleBrightness() {
    isDark = !isDark;
    notifyListeners();
  }

  void selectTheme(ThemeOption next) {
    theme = next;
    _preferences.saveThemeId(next.id);
    notifyListeners();
  }

  void selectLanguage(AppLanguage next) {
    language = next;
    _preferences.saveLanguageCode(next.code);
    notifyListeners();
  }

  void finishOnboarding() {
    showOnboarding = false;
    notifyListeners();
  }

  void setProMode(bool value) {
    isPro = value;
    proExpiresAt = value ? DateTime.now().add(const Duration(days: 30)) : null;
    notifyListeners();
  }

  String get subscriptionPlanLabel => isPro ? 'Mealr Pro' : _localizedFreePlan;

  String get subscriptionExpiryLabel {
    if (!isPro || proExpiresAt == null) return _localizedNoSubscription;
    return '$_localizedExpiresPrefix${_formatDate(proExpiresAt!)}';
  }

  String get _localizedFreePlan => switch (language) {
    AppLanguage.english => 'Free version',
    AppLanguage.german => 'Kostenlose Version',
    AppLanguage.spanish => 'Versión gratuita',
    AppLanguage.hungarian => 'Ingyenes verzió',
  };

  String get _localizedNoSubscription => switch (language) {
    AppLanguage.english => 'No active subscription',
    AppLanguage.german => 'Kein aktives Abo',
    AppLanguage.spanish => 'Sin suscripción activa',
    AppLanguage.hungarian => 'Nincs aktív előfizetés',
  };

  String get _localizedExpiresPrefix => switch (language) {
    AppLanguage.english => 'Expires: ',
    AppLanguage.german => 'Läuft ab: ',
    AppLanguage.spanish => 'Expira: ',
    AppLanguage.hungarian => 'Lejár: ',
  };

  void updateServedWeight(String id, double value) {
    final index = foods.indexWhere((food) => food.id == id);
    if (index == -1) return;
    foods[index] = foods[index].copyWith(servedWeight: value);
    notifyListeners();
  }

  void updateFoodNote(String id, String note) {
    final index = foods.indexWhere((food) => food.id == id);
    if (index == -1) return;
    foods[index] = foods[index].copyWith(note: note);
    notifyListeners();
  }

  void updateBmiWeight(double value) {
    bmiWeight = _oneDecimal(value);
    bmiSaved = false;
    notifyListeners();
  }

  void updateBmiHeight(double value) {
    bmiHeight = value.roundToDouble();
    bmiSaved = false;
    notifyListeners();
  }

  void updateBmiGender(Gender value) {
    bmiGender = value;
    bmiSaved = false;
    notifyListeners();
  }

  void saveBmiToProfile() {
    profileWeight = bmiWeight;
    weightTrackerInput = bmiWeight;
    profileHeight = bmiHeight;
    bmiSaved = true;
    notifyListeners();
  }

  void updateWeightTrackerInput(double value) {
    weightTrackerInput = _oneDecimal(value.clamp(1, 300).toDouble());
    notifyListeners();
  }

  void addWeightEntry() {
    final weight = _oneDecimal(weightTrackerInput);
    if (weight <= 0) return;
    profileWeight = weight;
    weightEntries.add(
      WeightEntry(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        weight: weight,
        recordedAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateWeightEntry(String id, double value) {
    if (!isPro) return;
    final index = weightEntries.indexWhere((entry) => entry.id == id);
    if (index == -1) return;
    final weight = _oneDecimal(value.clamp(1, 300).toDouble());
    final entry = weightEntries[index];
    weightEntries[index] = WeightEntry(
      id: entry.id,
      weight: weight,
      recordedAt: entry.recordedAt,
    );
    _syncProfileWeightFromLatestEntry();
    notifyListeners();
  }

  void deleteWeightEntry(String id) {
    if (!isPro) return;
    weightEntries.removeWhere((entry) => entry.id == id);
    _syncProfileWeightFromLatestEntry();
    notifyListeners();
  }

  void resetWeightProgress() {
    weightEntries.clear();
    notifyListeners();
  }

  void selectWeightChartRange(WeightChartRange range) {
    if (!isPro && range != WeightChartRange.days7) return;
    weightChartRange = range;
    notifyListeners();
  }

  List<WeightEntry> weightEntriesForRange(WeightChartRange range) {
    final since = DateTime.now().subtract(Duration(days: range.days));
    return weightEntries
        .where((entry) => !entry.recordedAt.isBefore(since))
        .toList();
  }

  double? get totalWeightChange {
    if (weightEntries.length < 2) return null;
    final sorted = [...weightEntries]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    return _oneDecimal(sorted.last.weight - sorted.first.weight);
  }

  WeightStats? get weightStats {
    if (weightEntries.length < 2) return null;
    final sorted = [...weightEntries]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final first = sorted.first;
    final latest = sorted.last;
    final totalChange = _oneDecimal(latest.weight - first.weight);
    final spanDays =
        latest.recordedAt.difference(first.recordedAt).inHours.abs() / 24;
    final weeklyAverage = spanDays <= 0
        ? totalChange
        : _oneDecimal(totalChange / spanDays * 7);
    final recentTrendChange = _changeSinceDays(sorted, 14) ?? totalChange;
    final trend = recentTrendChange.abs() < 0.2
        ? WeightTrend.stable
        : recentTrendChange < 0
        ? WeightTrend.down
        : WeightTrend.up;
    final lowestWeight = sorted
        .map((entry) => entry.weight)
        .reduce((a, b) => a < b ? a : b);

    return WeightStats(
      totalChange: totalChange,
      sevenDayChange: _changeSinceDays(sorted, 7),
      thirtyDayChange: _changeSinceDays(sorted, 30),
      weeklyAverage: weeklyAverage,
      trend: trend,
      lowestWeight: _oneDecimal(lowestWeight),
    );
  }

  double? _changeSinceDays(List<WeightEntry> sortedEntries, int days) {
    if (sortedEntries.length < 2) return null;
    final latest = sortedEntries.last;
    final since = latest.recordedAt.subtract(Duration(days: days));
    WeightEntry? baseline;
    for (final entry in sortedEntries) {
      if (!entry.recordedAt.isBefore(since)) {
        baseline = entry;
        break;
      }
    }
    baseline ??= sortedEntries.first;
    if (baseline.id == latest.id) return null;
    return _oneDecimal(latest.weight - baseline.weight);
  }

  void _syncProfileWeightFromLatestEntry() {
    if (weightEntries.isEmpty) return;
    final sorted = [...weightEntries]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final latest = sorted.last.weight;
    profileWeight = latest;
    weightTrackerInput = latest;
  }

  void updateCalorieAge(int value) {
    calorieAge = value;
    calorieSaved = false;
    notifyListeners();
  }

  void updateCalorieWeight(double value) {
    calorieWeight = _oneDecimal(value);
    calorieSaved = false;
    notifyListeners();
  }

  void updateCalorieHeight(double value) {
    calorieHeight = value.roundToDouble();
    calorieSaved = false;
    notifyListeners();
  }

  void updateCalorieGender(Gender value) {
    calorieGender = value;
    calorieSaved = false;
    notifyListeners();
  }

  void updateCalorieActivity(double value) {
    calorieActivity = value;
    calorieSaved = false;
    notifyListeners();
  }

  void saveCaloriesToProfile() {
    final result = calculateCalories(
      age: calorieAge,
      weightKg: calorieWeight,
      heightCm: calorieHeight,
      gender: calorieGender,
      activityMultiplier: calorieActivity,
    );
    profileCalorieTarget = result.tdee.round();
    calorieSaved = true;
    notifyListeners();
  }

  void addFood({
    required String name,
    required FoodCategory category,
    required double rawWeight,
    required double cookedWeight,
    required double servedWeight,
  }) {
    if (name.trim().isEmpty || rawWeight <= 0 || cookedWeight <= 0) return;
    if (!canAddFood(category)) return;
    foods.add(
      FoodItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: name.trim(),
        category: category,
        rawWeight: rawWeight,
        cookedWeight: cookedWeight,
        servedWeight: servedWeight <= 0 ? cookedWeight : servedWeight,
        addedLabel: 'today',
      ),
    );
    notifyListeners();
  }

  bool canAddFood(FoodCategory category) {
    if (isPro) return true;
    return !foods.any((food) => food.category == category);
  }

  bool get canAddAnyFood =>
      isPro || canAddFood(FoodCategory.main) || canAddFood(FoodCategory.side);

  bool get canAddMealPrepPlan =>
      isPro || mealPrepPlans.length < freeMealPrepPlanLimit;

  bool isFavoriteRecipe(String recipeId) =>
      favoriteRecipeIds.contains(recipeId);

  void toggleFavoriteRecipe(String recipeId) {
    if (favoriteRecipeIds.contains(recipeId)) {
      favoriteRecipeIds.remove(recipeId);
    } else {
      favoriteRecipeIds.add(recipeId);
    }
    notifyListeners();
  }

  void addMealPrepPlan({
    required String name,
    required FoodItem food,
    FoodItem? sideFood,
    required MealPrepMode mode,
    required int portionCount,
    required double portionWeight,
    double sidePortionWeight = 0,
    String note = '',
  }) {
    final cleanName = name.trim();
    if (!canAddMealPrepPlan ||
        cleanName.isEmpty ||
        portionCount <= 0 ||
        (mode == MealPrepMode.fixedPortion && portionWeight <= 0)) {
      return;
    }
    final effectivePortionWeight = mode == MealPrepMode.divideTotal
        ? food.cookedWeight / portionCount
        : portionWeight;
    final effectiveSidePortionWeight = sideFood == null
        ? 0.0
        : mode == MealPrepMode.divideTotal
        ? sideFood.cookedWeight / portionCount
        : sidePortionWeight;
    mealPrepPlans.add(
      MealPrepPlan(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: cleanName,
        mode: mode,
        foodName: food.name,
        rawWeight: food.rawWeight,
        cookedWeight: food.cookedWeight,
        sideFoodName: sideFood?.name,
        sideRawWeight: sideFood?.rawWeight ?? 0,
        sideCookedWeight: sideFood?.cookedWeight ?? 0,
        sidePortionWeight: effectiveSidePortionWeight,
        portionCount: portionCount,
        portionWeight: effectivePortionWeight,
        createdAt: DateTime.now(),
        boxes: List<bool>.filled(portionCount, false),
        note: note.trim(),
      ),
    );
    notifyListeners();
  }

  void updateMealPrepPlan({
    required String id,
    required String name,
    required FoodItem food,
    FoodItem? sideFood,
    required MealPrepMode mode,
    required int portionCount,
    required double portionWeight,
    double sidePortionWeight = 0,
    String note = '',
  }) {
    final index = mealPrepPlans.indexWhere((plan) => plan.id == id);
    if (index == -1) return;
    final cleanName = name.trim();
    if (cleanName.isEmpty ||
        portionCount <= 0 ||
        (mode == MealPrepMode.fixedPortion && portionWeight <= 0)) {
      return;
    }
    final effectivePortionWeight = mode == MealPrepMode.divideTotal
        ? food.cookedWeight / portionCount
        : portionWeight;
    final effectiveSidePortionWeight = sideFood == null
        ? 0.0
        : mode == MealPrepMode.divideTotal
        ? sideFood.cookedWeight / portionCount
        : sidePortionWeight;
    final oldPlan = mealPrepPlans[index];
    final boxes = List<bool>.generate(
      portionCount,
      (boxIndex) =>
          boxIndex < oldPlan.boxes.length ? oldPlan.boxes[boxIndex] : false,
    );
    mealPrepPlans[index] = MealPrepPlan(
      id: oldPlan.id,
      name: cleanName,
      mode: mode,
      foodName: food.name,
      rawWeight: food.rawWeight,
      cookedWeight: food.cookedWeight,
      sideFoodName: sideFood?.name,
      sideRawWeight: sideFood?.rawWeight ?? 0,
      sideCookedWeight: sideFood?.cookedWeight ?? 0,
      sidePortionWeight: effectiveSidePortionWeight,
      portionCount: portionCount,
      portionWeight: effectivePortionWeight,
      createdAt: oldPlan.createdAt,
      boxes: boxes,
      note: note.trim(),
    );
    notifyListeners();
  }

  void deleteMealPrepPlan(String id) {
    mealPrepPlans.removeWhere((plan) => plan.id == id);
    notifyListeners();
  }

  void toggleMealPrepBox({required String planId, required int boxIndex}) {
    final index = mealPrepPlans.indexWhere((plan) => plan.id == planId);
    if (index == -1) return;
    final plan = mealPrepPlans[index];
    if (boxIndex < 0 || boxIndex >= plan.boxes.length) return;
    final boxes = List<bool>.of(plan.boxes);
    boxes[boxIndex] = !boxes[boxIndex];
    mealPrepPlans[index] = plan.copyWith(boxes: boxes);
    notifyListeners();
  }

  void addShoppingList({
    required String name,
    required List<ShoppingListItem> items,
  }) {
    final cleanName = name.trim();
    final cleanItems = items
        .where((item) => item.name.trim().isNotEmpty)
        .map((item) => item.copyWith(name: item.name.trim()))
        .toList();
    if (!isPro || cleanName.isEmpty || cleanItems.isEmpty) return;
    shoppingLists.add(
      ShoppingList(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: cleanName,
        createdAt: DateTime.now(),
        items: cleanItems,
      ),
    );
    notifyListeners();
  }

  void addItemsToShoppingList({
    required String listId,
    required List<ShoppingListItem> items,
  }) {
    if (!isPro) return;
    final listIndex = shoppingLists.indexWhere((list) => list.id == listId);
    if (listIndex == -1) return;
    final cleanItems = items
        .where((item) => item.name.trim().isNotEmpty)
        .map((item) => item.copyWith(name: item.name.trim()))
        .toList();
    if (cleanItems.isEmpty) return;
    final list = shoppingLists[listIndex];
    shoppingLists[listIndex] = list.copyWith(
      items: [...list.items, ...cleanItems],
    );
    notifyListeners();
  }

  void updateShoppingList({
    required String id,
    required String name,
    required List<ShoppingListItem> items,
  }) {
    if (!isPro) return;
    final index = shoppingLists.indexWhere((list) => list.id == id);
    if (index == -1) return;
    final cleanName = name.trim();
    final cleanItems = items
        .where((item) => item.name.trim().isNotEmpty)
        .map((item) => item.copyWith(name: item.name.trim()))
        .toList();
    if (cleanName.isEmpty || cleanItems.isEmpty) return;
    final oldList = shoppingLists[index];
    shoppingLists[index] = oldList.copyWith(name: cleanName, items: cleanItems);
    notifyListeners();
  }

  void deleteShoppingList(String id) {
    if (!isPro) return;
    shoppingLists.removeWhere((list) => list.id == id);
    notifyListeners();
  }

  void toggleShoppingListItem({
    required String listId,
    required int itemIndex,
  }) {
    final listIndex = shoppingLists.indexWhere((list) => list.id == listId);
    if (listIndex == -1) return;
    final list = shoppingLists[listIndex];
    if (itemIndex < 0 || itemIndex >= list.items.length) return;
    final items = List<ShoppingListItem>.of(list.items);
    final item = items[itemIndex];
    items[itemIndex] = item.copyWith(checked: !item.checked);
    shoppingLists[listIndex] = list.copyWith(items: items);
    notifyListeners();
  }

  void deleteFood(String id) {
    foods.removeWhere((food) => food.id == id);
    notifyListeners();
  }

  double _oneDecimal(double value) => (value * 10).round() / 10;

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}. $month. $day.';
  }

  ThemeOption? _themeById(String id) {
    for (final option in themeOptions) {
      if (option.id == id) return option;
    }
    return null;
  }

  AppLanguage? _languageByCode(String code) {
    for (final option in AppLanguage.values) {
      if (option.code == code) return option;
    }
    return null;
  }
}

extension AppChromeColors on AppState {
  Color get chromeSurface =>
      isDark ? const Color(0xFF1B1D1B) : CupertinoColors.white;

  Color get chromeBorder =>
      isDark ? const Color(0xFF313631) : const Color(0xFFE4E9E5);
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({required AppState state, required super.child, super.key})
    : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope is missing above this context.');
    return scope!.notifier!;
  }
}
