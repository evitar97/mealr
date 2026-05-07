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
}
