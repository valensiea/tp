import 'package:flutter/material.dart';

import '../models/recipies.dart';
class RecipeDetailsScreen extends StatelessWidget {
  // in fev list
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
            SizedBox(height: 16.0),
            Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
            for (String ingredient in recipe.ingredients) Text(ingredient),
            SizedBox(height: 16.0),
            Text('Instructions:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            for (int i = 0; i < recipe.instructions.length; i++)
              Text('${i + 1}. ${recipe.instructions[i]}'),
            SizedBox(height: 10),
            if (recipe.image.isNotEmpty) Image.network(recipe.image),
          ],
        ),
      ),
    );
  }
}
