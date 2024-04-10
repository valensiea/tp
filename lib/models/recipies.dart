class Recipe {
  final int id;
  final String name;
  final String image;
  final List<String> tags;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> mealType;
  bool isFavorite;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.tags,
    required this.ingredients,
    required this.instructions,
    required this.mealType,
    this.isFavorite = false, 
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      tags: List<String>.from(json['tags']),
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      mealType: List<String>.from(json['mealType']),
      prepTimeMinutes: json['prepTimeMinutes'],
      cookTimeMinutes: json['cookTimeMinutes'],
      servings: json['servings'],
      difficulty: json['difficulty'],
    );
  }
}
