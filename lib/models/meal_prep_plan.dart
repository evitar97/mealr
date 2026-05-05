class MealPrepPlan {
  const MealPrepPlan({
    required this.id,
    required this.name,
    required this.foodName,
    required this.rawWeight,
    required this.cookedWeight,
    this.sideFoodName,
    this.sideRawWeight = 0,
    this.sideCookedWeight = 0,
    this.sidePortionWeight = 0,
    required this.portionCount,
    required this.portionWeight,
    required this.createdAt,
    required this.boxes,
    this.note = '',
  });

  final String id;
  final String name;
  final String foodName;
  final double rawWeight;
  final double cookedWeight;
  final String? sideFoodName;
  final double sideRawWeight;
  final double sideCookedWeight;
  final double sidePortionWeight;
  final int portionCount;
  final double portionWeight;
  final DateTime createdAt;
  final List<bool> boxes;
  final String note;

  double get totalCookedNeeded => portionCount * portionWeight;

  double get sideTotalCookedNeeded => portionCount * sidePortionWeight;

  double get combinedCookedNeeded => totalCookedNeeded + sideTotalCookedNeeded;

  double get totalRawNeeded =>
      cookedWeight <= 0 ? 0 : rawWeight / cookedWeight * totalCookedNeeded;

  double get sideTotalRawNeeded => sideCookedWeight <= 0
      ? 0
      : sideRawWeight / sideCookedWeight * sideTotalCookedNeeded;

  double get combinedRawNeeded => totalRawNeeded + sideTotalRawNeeded;

  double get rawPerPortion =>
      cookedWeight <= 0 ? 0 : rawWeight / cookedWeight * portionWeight;

  double get sideRawPerPortion => sideCookedWeight <= 0
      ? 0
      : sideRawWeight / sideCookedWeight * sidePortionWeight;

  double get recipeMultiplier =>
      cookedWeight <= 0 ? 0 : totalCookedNeeded / cookedWeight;

  double get sideRecipeMultiplier =>
      sideCookedWeight <= 0 ? 0 : sideTotalCookedNeeded / sideCookedWeight;

  bool get hasSide => sideFoodName != null && sidePortionWeight > 0;

  int get completedBoxes => boxes.where((box) => box).length;

  MealPrepPlan copyWith({
    String? id,
    String? name,
    String? foodName,
    double? rawWeight,
    double? cookedWeight,
    String? sideFoodName,
    double? sideRawWeight,
    double? sideCookedWeight,
    double? sidePortionWeight,
    int? portionCount,
    double? portionWeight,
    DateTime? createdAt,
    List<bool>? boxes,
    String? note,
  }) {
    return MealPrepPlan(
      id: id ?? this.id,
      name: name ?? this.name,
      foodName: foodName ?? this.foodName,
      rawWeight: rawWeight ?? this.rawWeight,
      cookedWeight: cookedWeight ?? this.cookedWeight,
      sideFoodName: sideFoodName ?? this.sideFoodName,
      sideRawWeight: sideRawWeight ?? this.sideRawWeight,
      sideCookedWeight: sideCookedWeight ?? this.sideCookedWeight,
      sidePortionWeight: sidePortionWeight ?? this.sidePortionWeight,
      portionCount: portionCount ?? this.portionCount,
      portionWeight: portionWeight ?? this.portionWeight,
      createdAt: createdAt ?? this.createdAt,
      boxes: boxes ?? this.boxes,
      note: note ?? this.note,
    );
  }
}
