import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:podomoro_app/feature/widgets/CustomAppBar.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Customappbar(),
      backgroundColor: Colors.white, // Correct background color property
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Color(0xFFD047FF),
            borderRadius: BorderRadius.circular(30.0),
          ),
          width: 300,
          height: 450,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  "PomodoroFocus is a productivity app designed to help you stay focused and manage your time effectively. Based on the Pomodoro Technique, this app encourages working in short, intense intervals (Pomodoros) with scheduled breaks to prevent burnout and maintain productivity throughout your day.",
                  style: TextStyle(color: Colors.white, fontSize: 15.0), // White text for readability
                  textAlign: TextAlign.center,
                ),
              ),
              Text(
                "- Podomoro App -",
                style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold), // White text for readability
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
