enum FoodCategory { main, side }

class FoodItem {
  const FoodItem({
    required this.id,
    required this.name,
    required this.category,
    required this.rawWeight,
    required this.cookedWeight,
    required this.servedWeight,
    required this.addedLabel,
    this.note = '',
  });

  final String id;
  final String name;
  final FoodCategory category;
  final double rawWeight;
  final double cookedWeight;
  final double servedWeight;
  final String addedLabel;
  final String note;

  double get rawEquivalent =>
      cookedWeight <= 0 ? 0 : rawWeight / cookedWeight * servedWeight;

  bool get hasNote => note.trim().isNotEmpty;

  FoodItem copyWith({
    String? id,
    String? name,
    FoodCategory? category,
    double? rawWeight,
    double? cookedWeight,
    double? servedWeight,
    String? addedLabel,
    String? note,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      rawWeight: rawWeight ?? this.rawWeight,
      cookedWeight: cookedWeight ?? this.cookedWeight,
      servedWeight: servedWeight ?? this.servedWeight,
      addedLabel: addedLabel ?? this.addedLabel,
      note: note ?? this.note,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.name,
      'rawWeight': rawWeight,
      'cookedWeight': cookedWeight,
      'servedWeight': servedWeight,
      'addedLabel': addedLabel,
      'note': note,
    };
  }

  static FoodItem? fromJson(Object? value) {
    if (value is! Map) return null;
    final categoryName = value['category'];
    final category = FoodCategory.values.firstWhere(
      (item) => item.name == categoryName,
      orElse: () => FoodCategory.main,
    );
    final id = value['id'];
    final name = value['name'];
    if (id is! String || name is! String) return null;
    return FoodItem(
      id: id,
      name: name,
      category: category,
      rawWeight: _jsonDouble(value['rawWeight']),
      cookedWeight: _jsonDouble(value['cookedWeight']),
      servedWeight: _jsonDouble(value['servedWeight']),
      addedLabel: value['addedLabel'] is String
          ? value['addedLabel'] as String
          : 'today',
      note: value['note'] is String ? value['note'] as String : '',
    );
  }
}

double _jsonDouble(Object? value) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}
