import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
      primaryColor: Colors.purple,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        headlineMedium:
            TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
      ));
}
