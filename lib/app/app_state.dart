import 'dart:convert';

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
  system(null, 'System'),
  english('en', 'English'),
  hungarian('hu', 'Magyar'),
  german('de', 'Deutsch'),
  spanish('es', 'Español');

  const AppLanguage(this.code, this.label);

  final String? code;
  final String label;
}

enum AppBrightnessMode { system, light, dark }

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
  AppBrightnessMode brightnessMode = AppBrightnessMode.system;
  ThemeOption theme = themeOptions.firstWhere(
    (option) => option.id == 'forest',
    orElse: () => themeOptions.first,
  );
  AppLanguage language = AppLanguage.system;
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

  bool get isDark => switch (brightnessMode) {
    AppBrightnessMode.system =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark,
    AppBrightnessMode.light => false,
    AppBrightnessMode.dark => true,
  };

  MealWeightPalette get palette => isDark ? theme.dark : theme.light;

  @override
  void notifyListeners() {
    _saveSnapshot();
    super.notifyListeners();
  }

  Future<void> loadSavedPreferences() async {
    final snapshot = await _preferences.loadAppSnapshot();
    final themeId = await _preferences.loadThemeId();
    final languageCode = await _preferences.loadLanguageCode();
    final onboardingCompleted = await _preferences.loadOnboardingCompleted();
    var changed = false;
    if (snapshot != null) {
      changed = _restoreSnapshot(snapshot) || changed;
    }
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
    if (onboardingCompleted == true) {
      showOnboarding = false;
      changed = true;
    }
    if (changed) notifyListeners();
  }

  void _saveSnapshot() {
    _preferences.saveAppSnapshot(jsonEncode(_snapshotJson()));
  }

  void selectTab(AppTab next) {
    tab = next;
    notifyListeners();
  }

  void selectBrightnessMode(AppBrightnessMode next) {
    brightnessMode = next;
    notifyListeners();
  }

  void handlePlatformBrightnessChanged() {
    if (brightnessMode == AppBrightnessMode.system) notifyListeners();
  }

  void selectTheme(ThemeOption next) {
    theme = next;
    _preferences.saveThemeId(next.id);
    _saveSnapshot();
    notifyListeners();
  }

  void selectLanguage(AppLanguage next) {
    language = next;
    _preferences.saveLanguageCode(next.code ?? 'system');
    _saveSnapshot();
    notifyListeners();
  }

  void finishOnboarding() {
    showOnboarding = false;
    _preferences.saveOnboardingCompleted(true);
    _saveSnapshot();
    notifyListeners();
  }

  void restartOnboarding() {
    showOnboarding = true;
    _preferences.saveOnboardingCompleted(false);
    _saveSnapshot();
    notifyListeners();
  }

  void setProMode(bool value) {
    isPro = value;
    proExpiresAt = value ? DateTime.now().add(const Duration(days: 30)) : null;
    _saveSnapshot();
    notifyListeners();
  }

  String get subscriptionPlanLabel => isPro ? 'Mealr Pro' : _localizedFreePlan;

  String get subscriptionExpiryLabel {
    if (!isPro || proExpiresAt == null) return _localizedNoSubscription;
    return '$_localizedExpiresPrefix${_formatDate(proExpiresAt!)}';
  }

  String get _localizedFreePlan => switch (language) {
    AppLanguage.system => 'Free version',
    AppLanguage.english => 'Free version',
    AppLanguage.german => 'Kostenlose Version',
    AppLanguage.spanish => 'Versión gratuita',
    AppLanguage.hungarian => 'Ingyenes verzió',
  };

  String get _localizedNoSubscription => switch (language) {
    AppLanguage.system => 'No active subscription',
    AppLanguage.english => 'No active subscription',
    AppLanguage.german => 'Kein aktives Abo',
    AppLanguage.spanish => 'Sin suscripción activa',
    AppLanguage.hungarian => 'Nincs aktív előfizetés',
  };

  String get _localizedExpiresPrefix => switch (language) {
    AppLanguage.system => 'Expires: ',
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

  void applyOnboardingProfile({
    int? age,
    double? weight,
    double? height,
    Gender? gender,
  }) {
    if (age != null) {
      calorieAge = age.clamp(12, 90);
    }
    if (weight != null) {
      final normalized = _oneDecimal(weight.clamp(1, 300).toDouble());
      bmiWeight = normalized;
      calorieWeight = normalized;
      profileWeight = normalized;
      weightTrackerInput = normalized;
    }
    if (height != null) {
      final normalized = height.clamp(80, 230).roundToDouble();
      bmiHeight = normalized;
      calorieHeight = normalized;
      profileHeight = normalized;
    }
    if (gender != null) {
      bmiGender = gender;
      calorieGender = gender;
    }
    bmiSaved = true;
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

  void updateFood({
    required String id,
    required String name,
    required FoodCategory category,
    required double rawWeight,
    required double cookedWeight,
    required double servedWeight,
  }) {
    final index = foods.indexWhere((food) => food.id == id);
    if (index == -1 ||
        name.trim().isEmpty ||
        rawWeight <= 0 ||
        cookedWeight <= 0) {
      return;
    }
    final oldFood = foods[index];
    foods[index] = oldFood.copyWith(
      name: name.trim(),
      category: category,
      rawWeight: rawWeight,
      cookedWeight: cookedWeight,
      servedWeight: servedWeight <= 0 ? cookedWeight : servedWeight,
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
    final cleanItems = _cleanShoppingItems(items);
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
    final cleanItems = _cleanShoppingItems(items);
    if (cleanItems.isEmpty) return;
    final list = shoppingLists[listIndex];
    shoppingLists[listIndex] = list.copyWith(
      items: _mergeShoppingItems([...list.items, ...cleanItems]),
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
    final cleanItems = _cleanShoppingItems(items);
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

  void clearCheckedShoppingItems(String id) {
    if (!isPro) return;
    final index = shoppingLists.indexWhere((list) => list.id == id);
    if (index == -1) return;
    final list = shoppingLists[index];
    final items = list.items.where((item) => !item.checked).toList();
    if (items.length == list.items.length) return;
    shoppingLists[index] = list.copyWith(items: items);
    notifyListeners();
  }

  void deleteFood(String id) {
    foods.removeWhere((food) => food.id == id);
    notifyListeners();
  }

  List<ShoppingListItem> _cleanShoppingItems(List<ShoppingListItem> items) {
    return _mergeShoppingItems(
      items
          .where((item) => item.name.trim().isNotEmpty)
          .map((item) => item.copyWith(name: item.name.trim()))
          .toList(),
    );
  }

  List<ShoppingListItem> _mergeShoppingItems(List<ShoppingListItem> items) {
    final merged = <ShoppingListItem>[];
    for (final item in items) {
      final nameKey = item.name.trim().toLowerCase();
      final index = merged.indexWhere(
        (candidate) => candidate.name.trim().toLowerCase() == nameKey,
      );
      if (index == -1) {
        merged.add(item);
      } else {
        merged[index] = merged[index].copyWith(
          checked: merged[index].checked && item.checked,
        );
      }
    }
    return merged;
  }

  Map<String, Object?> _snapshotJson() {
    return {
      'themeId': theme.id,
      'languageCode': language.code ?? 'system',
      'showOnboarding': showOnboarding,
      'brightnessMode': brightnessMode.name,
      'isPro': isPro,
      'proExpiresAt': proExpiresAt?.toIso8601String(),
      'bmiWeight': bmiWeight,
      'bmiHeight': bmiHeight,
      'bmiGender': bmiGender.name,
      'bmiSaved': bmiSaved,
      'calorieAge': calorieAge,
      'calorieWeight': calorieWeight,
      'calorieHeight': calorieHeight,
      'calorieGender': calorieGender.name,
      'calorieActivity': calorieActivity,
      'calorieSaved': calorieSaved,
      'profileWeight': profileWeight,
      'profileHeight': profileHeight,
      'profileCalorieTarget': profileCalorieTarget,
      'weightTrackerInput': weightTrackerInput,
      'weightChartRange': weightChartRange.name,
      'foods': [for (final food in foods) food.toJson()],
      'mealPrepPlans': [for (final plan in mealPrepPlans) plan.toJson()],
      'shoppingLists': [for (final list in shoppingLists) list.toJson()],
      'weightEntries': [
        for (final entry in weightEntries)
          {
            'id': entry.id,
            'weight': entry.weight,
            'recordedAt': entry.recordedAt.toIso8601String(),
          },
      ],
      'favoriteRecipeIds': favoriteRecipeIds.toList(),
    };
  }

  bool _restoreSnapshot(String snapshot) {
    try {
      final decoded = jsonDecode(snapshot);
      if (decoded is! Map) return false;
      final themeId = decoded['themeId'];
      if (themeId is String) {
        final savedTheme = _themeById(themeId);
        if (savedTheme != null) theme = savedTheme;
      }
      final languageCode = decoded['languageCode'];
      if (languageCode is String) {
        final savedLanguage = _languageByCode(languageCode);
        if (savedLanguage != null) language = savedLanguage;
      }
      if (decoded['showOnboarding'] is bool) {
        showOnboarding = decoded['showOnboarding'] as bool;
      }
      final savedBrightnessMode = decoded['brightnessMode'];
      if (savedBrightnessMode is String) {
        final matchedMode = AppBrightnessMode.values.firstWhere(
          (mode) => mode.name == savedBrightnessMode,
          orElse: () => AppBrightnessMode.system,
        );
        brightnessMode = matchedMode;
      }
      if (decoded['isPro'] is bool) isPro = decoded['isPro'] as bool;
      final proExpiry = decoded['proExpiresAt'];
      proExpiresAt = proExpiry is String ? DateTime.tryParse(proExpiry) : null;
      bmiWeight = _jsonDouble(decoded['bmiWeight'], bmiWeight);
      bmiHeight = _jsonDouble(decoded['bmiHeight'], bmiHeight);
      bmiGender = _genderByName(decoded['bmiGender'], bmiGender);
      bmiSaved = decoded['bmiSaved'] == true;
      calorieAge = _jsonInt(decoded['calorieAge'], calorieAge);
      calorieWeight = _jsonDouble(decoded['calorieWeight'], calorieWeight);
      calorieHeight = _jsonDouble(decoded['calorieHeight'], calorieHeight);
      calorieGender = _genderByName(decoded['calorieGender'], calorieGender);
      calorieActivity = _jsonDouble(
        decoded['calorieActivity'],
        calorieActivity,
      );
      calorieSaved = decoded['calorieSaved'] == true;
      profileWeight = _jsonDouble(decoded['profileWeight'], profileWeight);
      profileHeight = _jsonDouble(decoded['profileHeight'], profileHeight);
      profileCalorieTarget = _jsonInt(
        decoded['profileCalorieTarget'],
        profileCalorieTarget,
      );
      weightTrackerInput = _jsonDouble(
        decoded['weightTrackerInput'],
        weightTrackerInput,
      );
      final rangeName = decoded['weightChartRange'];
      weightChartRange = WeightChartRange.values.firstWhere(
        (range) => range.name == rangeName,
        orElse: () => weightChartRange,
      );

      foods
        ..clear()
        ..addAll(_jsonList(decoded['foods'], FoodItem.fromJson));
      mealPrepPlans
        ..clear()
        ..addAll(_jsonList(decoded['mealPrepPlans'], MealPrepPlan.fromJson));
      shoppingLists
        ..clear()
        ..addAll(_jsonList(decoded['shoppingLists'], ShoppingList.fromJson));
      weightEntries
        ..clear()
        ..addAll(_weightEntriesFromJson(decoded['weightEntries']));
      favoriteRecipeIds
        ..clear()
        ..addAll(
          decoded['favoriteRecipeIds'] is List
              ? (decoded['favoriteRecipeIds'] as List).whereType<String>()
              : const <String>[],
        );
      return true;
    } on FormatException {
      return false;
    } on TypeError {
      return false;
    }
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
    if (code == 'system') return AppLanguage.system;
    for (final option in AppLanguage.values) {
      if (option.code == code) return option;
    }
    return null;
  }

  String resolvedLanguageCode(BuildContext context) {
    final manualCode = language.code;
    if (manualCode != null) return manualCode;
    final platformCode = Localizations.localeOf(context).languageCode;
    return switch (platformCode) {
      'hu' || 'de' || 'es' => platformCode,
      _ => 'en',
    };
  }

  Locale? get localeOverride {
    final code = language.code;
    return code == null ? null : Locale(code);
  }

  Gender _genderByName(Object? value, Gender fallback) {
    return Gender.values.firstWhere(
      (gender) => gender.name == value,
      orElse: () => fallback,
    );
  }

  double _jsonDouble(Object? value, double fallback) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? fallback;
    return fallback;
  }

  int _jsonInt(Object? value, int fallback) {
    if (value is num) return value.round();
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  List<T> _jsonList<T>(Object? value, T? Function(Object?) parse) {
    if (value is! List) return <T>[];
    return [
      for (final item in value)
        if (parse(item) != null) parse(item)!,
    ];
  }

  List<WeightEntry> _weightEntriesFromJson(Object? value) {
    if (value is! List) return <WeightEntry>[];
    return [
      for (final item in value)
        if (item is Map &&
            item['id'] is String &&
            item['recordedAt'] is String &&
            DateTime.tryParse(item['recordedAt'] as String) != null)
          WeightEntry(
            id: item['id'] as String,
            weight: _jsonDouble(item['weight'], profileWeight),
            recordedAt: DateTime.parse(item['recordedAt'] as String),
          ),
    ];
  }
}

extension AppChromeColors on AppState {
  Color get chromeSurface =>
      isDark ? const Color(0xFF101211) : CupertinoColors.white;

  Color get chromeBorder =>
      isDark ? palette.border.withValues(alpha: 0.46) : const Color(0xFFE4E9E5);

  Color get primaryActionSurface => isDark
      ? Color.alphaBlend(palette.accent.withValues(alpha: 0.86), palette.card)
      : palette.accent;
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
