import 'package:flutter/material.dart';
import 'package:tp/models/recipies.dart';
import 'package:tp/pages/fav_menu.dart';

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
        title: Text('Favorites', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: favoriteRecipes.isEmpty
          ? Center(
              child: Text('No favorite recipes.'),
            )
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Color(0xFFFFF8E1), // Light yellow
                  child: ListTile(
                    title: Text(favoriteRecipes[index].name),
                    subtitle: Text(' ${favoriteRecipes[index].mealType}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipeDetailsScreen(
                                recipe: favoriteRecipes[index])),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
