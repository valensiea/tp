import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class Recipe {
  final int id;
  final String name;
  final String image;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> tags;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.ingredients,
    required this.instructions,
    required this.tags,
    this.isFavorite = false, // Default to false
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      tags: List<String>.from(json['tags']),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      home: RecipeListScreen(),
    );
  }
}

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late List<Recipe> recipes;
  Set<int> favorites = Set<int>();
  String? selectedMealType;
  String? selectedTag;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Create Dio instance
      Dio dio = Dio();

      // Make GET request
      Response response = await dio.get('https://dummyjson.com/recipes');

      // Check if request was successful
      if (response.statusCode == 200) {
        // Extract JSON data
        List<dynamic> jsonData = response.data['recipes'];

        // Convert jsonData to List<Recipe>
        setState(() {
          recipes = jsonData
              .map((recipeJson) => Recipe.fromJson(recipeJson))
              .toList();
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _showRecipeDetails(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(recipe.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Ingredients:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              for (String ingredient in recipe.ingredients) Text(ingredient),
              SizedBox(height: 10),
              Text('Instructions:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              for (int i = 0; i < recipe.instructions.length; i++)
                Text('${i + 1}. ${recipe.instructions[i]}'),
              SizedBox(height: 10),
              Text('Tags:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: recipe.tags.map((tag) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context); // Close the current dialog
                      _filterByTag(tag); // Filter recipes by the selected tag
                    },
                    child: Chip(label: Text(tag)),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _toggleFavorite(int recipeId) {
    setState(() {
      final recipeIndex = recipes.indexWhere((recipe) => recipe.id == recipeId);
      if (recipeIndex != -1) {
        final isFavorite = !recipes[recipeIndex].isFavorite;
        recipes[recipeIndex].isFavorite = isFavorite;
        if (isFavorite) {
          favorites.add(recipeId);
        } else {
          favorites.remove(recipeId);
        }
      }
    });
  }

  void _filterByTag(String tag) {
    setState(() {
      selectedTag = tag;
    });
  }

  void _clearFilters() {
    setState(() {
      selectedMealType = null;
      selectedTag = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Recipe> filteredRecipes = recipes.where((recipe) {
      if (selectedMealType != null && !recipe.tags.contains(selectedMealType)) {
        return false;
      }
      if (selectedTag != null && !recipe.tags.contains(selectedTag)) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: recipes == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                DropdownButton<String>(
                  value: selectedMealType,
                  hint: Text('Select Meal Type'),
                  onChanged: (value) {
                    setState(() {
                      selectedMealType = value;
                    });
                  },
                  items: ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snack']
                      .map((mealType) {
                    return DropdownMenuItem<String>(
                      value: mealType == 'All' ? null : mealType,
                      child: Text(mealType),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  child: Text('Clear Filters'),
                  // icon: Icon(Icons.clear),
                  onPressed: () {
                    _clearFilters();
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () =>
                            _showRecipeDetails(context, filteredRecipes[index]),
                        child: Card(
                          child: ListTile(
                            title: Text(filteredRecipes[index].name),
                            leading: filteredRecipes[index].image.isNotEmpty
                                ? Image.network(
                                    filteredRecipes[index].image,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      print('Failed to load image: $exception');
                                      return Icon(Icons.error);
                                    },
                                  )
                                : SizedBox(), // Placeholder if image URL is empty
                            trailing: IconButton(
                              icon: Icon(
                                filteredRecipes[index].isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: filteredRecipes[index].isFavorite
                                    ? Colors.red
                                    : null,
                              ),
                              onPressed: () =>
                                  _toggleFavorite(filteredRecipes[index].id),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FavoritesScreen(favorites: favorites, recipes: recipes)),
          );
        },
        child: Icon(Icons.favorite),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       IconButton(
      //         icon: Icon(Icons.clear),
      //         onPressed: () {
      //           _clearFilters();
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final Set<int> favorites;
  final List<Recipe> recipes;

  FavoritesScreen({required this.favorites, required this.recipes});

  @override
  Widget build(BuildContext context) {
    List<Recipe> favoriteRecipes =
        recipes.where((recipe) => favorites.contains(recipe.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: favoriteRecipes.isEmpty
          ? Center(
              child: Text('No favorite recipes.'),
            )
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(favoriteRecipes[index].name),
                  subtitle: Text('ID: ${favoriteRecipes[index].id}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecipeDetailsScreen(
                              recipe: favoriteRecipes[index])),
                    );
                  },
                );
              },
            ),
    );
  }
}

class RecipeDetailsScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailsScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.name),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recipe.image.isNotEmpty) Image.network(recipe.image),
            SizedBox(height: 16.0),
            Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
            for (String ingredient in recipe.ingredients) Text(ingredient),
            SizedBox(height: 16.0),
            Text('Instructions:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            for (int i = 0; i < recipe.instructions.length; i++)
              Text('${i + 1}. ${recipe.instructions[i]}'),
          ],
        ),
      ),
    );
  }
}
