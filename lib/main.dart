import 'package:flutter/material.dart';

import 'package:tp/pages/recipe_book.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primaryColor: Color(0xFFD2B48C), // Warm Brown
        scaffoldBackgroundColor: Color(0xFFF5F5DC), // Beige
        appBarTheme: AppBarTheme(
          color: Color(0xFFD2B48C), // Warm Brown
        ),
      ),
      home: RecipeListScreen(),
    );
  }
}

// 640710737 น.ส.พัฒนวดี ชาวไร่นา
// สาขา เทคโนโลยีสารสนเทศ