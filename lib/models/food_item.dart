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
}
