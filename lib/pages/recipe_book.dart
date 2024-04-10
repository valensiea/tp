import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:tp/pages/fav.dart';
import 'package:tp/models/recipies.dart';

class RecipeListScreen extends StatefulWidget {
  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late List<Recipe> recipes;
  Set<int> favorites = Set<int>();
  String? selectedMealType;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      Dio dio = Dio();

      Response response = await dio.get('https://dummyjson.com/recipes');

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data['recipes'];

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

  List<Recipe> searchRecipes(String query) {
    return recipes
        .where(
            (recipe) => recipe.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  List<Recipe> filterRecipesByMealType(List<Recipe> recipes, String? mealType) {
    if (mealType == null || mealType == 'All') {
      return recipes;
    } else {
      return recipes
          .where((recipe) => recipe.mealType.contains(mealType))
          .toList();
    }
  }

  void _showRecipeDetails(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFFF5F5DC),
          title: Text(recipe.name),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'Prep Time: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${recipe.prepTimeMinutes} minutes',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Cook Time: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${recipe.cookTimeMinutes} minutes',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Servings: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${recipe.servings}',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Difficulty: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${recipe.difficulty}',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              SizedBox(height: 10),
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
              SizedBox(height: 5),
              Wrap(
                spacing: 8.0,
                children:
                    recipe.tags.map((tag) => Chip(label: Text(tag))).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.black),
              ),
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

  @override
  Widget build(BuildContext context) {
    List<Recipe> filteredRecipes = searchRecipes(searchController.text);
    filteredRecipes =
        filterRecipesByMealType(filteredRecipes, selectedMealType);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          children: [
            Text(
              'Recipes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.menu_book),
          ],
        ),
        actions: [
          DropdownButton<String>(
            value: selectedMealType,
            hint: Text('Select Meal Type'),
            onChanged: (value) {
              setState(() {
                selectedMealType = value;
              });
            },
            items: ['All meal', 'Breakfast', 'Lunch', 'Dinner', 'Snack']
                .map((mealType) {
              return DropdownMenuItem<String>(
                value: mealType == 'All meal' ? null : mealType,
                child: Text(mealType),
              );
            }).toList(),
          ),
          SizedBox(width: 20),
          Container(
            width: 250,
            // height: 50,
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search recipes',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          SizedBox(
            width: 20,
          ),
          FloatingActionButton(
            backgroundColor: Color(0xFFFFF8E1),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FavoritesScreen(
                        favorites: favorites, recipes: recipes)),
              );
            },
            child: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            elevation: 0, // Remove elevation for consistency
          ),
        ],
      ),
      body: recipes == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: 16.0),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredRecipes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () =>
                            _showRecipeDetails(context, filteredRecipes[index]),
                        child: Card(
                          color: Color(0xFFFFF8E1), // Light yellow
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
                                : SizedBox(),
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
    );
  }
}
