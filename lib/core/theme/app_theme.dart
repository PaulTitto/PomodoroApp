import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
      primaryColor: const Color.fromARGB(255, 217, 0, 255),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
            color: const Color.fromARGB(255, 217, 0, 255),
            fontWeight: FontWeight.bold),
      ));
}
