import 'package:flutter/material.dart';
import 'package:podomoro_app/feature/screens/home_screen.dart';
import 'package:podomoro_app/feature/widgets/CustomAppBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 217, 0, 255)),
        useMaterial3: true,
      ),
      home: Scaffold(appBar: Customappbar(), body: HomeScreen()),
    );
  }
}
