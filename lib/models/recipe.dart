enum RecipeCategory { breakfast, lunch, dinner, snack }

class RecipeIngredient {
  const RecipeIngredient({
    required this.name,
    required this.amount,
    required this.unit,
  });

  final String name;
  final double amount;
  final String unit;
}

class Recipe {
  const Recipe({
    required this.id,
    required this.category,
    required this.name,
    required this.emoji,
    required this.baseServings,
    required this.caloriesPerServing,
    required this.ingredients,
    required this.steps,
    required this.allergens,
    required this.prepTimeMinutes,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
    this.difficulty,
    this.isVegan = false,
  });

  final String id;
  final RecipeCategory category;
  final String name;
  final String emoji;
  final int baseServings;
  final int caloriesPerServing;
  final List<RecipeIngredient> ingredients;
  final List<String> steps;
  final List<String> allergens;
  final int prepTimeMinutes;
  final int? proteinGrams;
  final int? carbsGrams;
  final int? fatGrams;
  final String? difficulty;
  final bool isVegan;

  int get proteinEstimate =>
      proteinGrams ?? (caloriesPerServing * 0.24 / 4).round();

  int get carbsEstimate =>
      carbsGrams ?? (caloriesPerServing * 0.44 / 4).round();

  int get fatEstimate => fatGrams ?? (caloriesPerServing * 0.32 / 9).round();

  String get difficultyLabel {
    if (difficulty != null && difficulty!.trim().isNotEmpty) {
      return difficulty!;
    }
    if (prepTimeMinutes <= 12) return 'Easy';
    if (prepTimeMinutes <= 25) return 'Medium';
    return 'Advanced';
  }
}
