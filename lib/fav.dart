import 'package:flutter/material.dart';
import 'main.dart'; // Importing main.dart to access the Recipe class

class FavoriteRecipesScreen extends StatelessWidget {
  final List<Recipe> favorites;

  const FavoriteRecipesScreen({Key? key, required this.favorites})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Recipes'),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Text('No favorite recipes.'),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(favorites[index].name),
                    leading: Image.network(
                      favorites[index].image,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        print('Failed to load image: $exception');
                        return Icon(Icons.error);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
