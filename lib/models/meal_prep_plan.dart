enum MealPrepMode { divideTotal, fixedPortion }

class MealPrepPlan {
  const MealPrepPlan({
    required this.id,
    required this.name,
    this.mode = MealPrepMode.fixedPortion,
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
  final MealPrepMode mode;
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
    MealPrepMode? mode,
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
      mode: mode ?? this.mode,
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

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'mode': mode.name,
      'foodName': foodName,
      'rawWeight': rawWeight,
      'cookedWeight': cookedWeight,
      'sideFoodName': sideFoodName,
      'sideRawWeight': sideRawWeight,
      'sideCookedWeight': sideCookedWeight,
      'sidePortionWeight': sidePortionWeight,
      'portionCount': portionCount,
      'portionWeight': portionWeight,
      'createdAt': createdAt.toIso8601String(),
      'boxes': boxes,
      'note': note,
    };
  }

  static MealPrepPlan? fromJson(Object? value) {
    if (value is! Map) return null;
    final id = value['id'];
    final name = value['name'];
    final foodName = value['foodName'];
    final createdAtRaw = value['createdAt'];
    if (id is! String ||
        name is! String ||
        foodName is! String ||
        createdAtRaw is! String) {
      return null;
    }
    final createdAt = DateTime.tryParse(createdAtRaw);
    if (createdAt == null) return null;
    final modeName = value['mode'];
    final mode = MealPrepMode.values.firstWhere(
      (item) => item.name == modeName,
      orElse: () => MealPrepMode.fixedPortion,
    );
    final rawBoxes = value['boxes'];
    final boxes = rawBoxes is List
        ? rawBoxes.map((box) => box == true).toList()
        : <bool>[];
    final portionCount = _jsonInt(value['portionCount']);
    return MealPrepPlan(
      id: id,
      name: name,
      mode: mode,
      foodName: foodName,
      rawWeight: _jsonDouble(value['rawWeight']),
      cookedWeight: _jsonDouble(value['cookedWeight']),
      sideFoodName: value['sideFoodName'] is String
          ? value['sideFoodName'] as String
          : null,
      sideRawWeight: _jsonDouble(value['sideRawWeight']),
      sideCookedWeight: _jsonDouble(value['sideCookedWeight']),
      sidePortionWeight: _jsonDouble(value['sidePortionWeight']),
      portionCount: portionCount,
      portionWeight: _jsonDouble(value['portionWeight']),
      createdAt: createdAt,
      boxes: boxes.length == portionCount
          ? boxes
          : List<bool>.generate(
              portionCount,
              (index) => index < boxes.length ? boxes[index] : false,
            ),
      note: value['note'] is String ? value['note'] as String : '',
    );
  }
}

double _jsonDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

int _jsonInt(Object? value) {
  if (value is num) return value.round();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
