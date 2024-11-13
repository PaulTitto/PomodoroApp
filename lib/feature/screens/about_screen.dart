import 'package:flutter/material.dart';
import 'package:podomoro_app/feature/widgets/CustomAppBar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Customappbar(),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFD047FF),
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
                  "PomodoroFocus is a productivity app designed to help you stay focused and manage your time effectively. "
                      "Based on the Pomodoro Technique, this app encourages working in short, intense intervals with scheduled breaks.",
                  style: const TextStyle(color: Colors.white, fontSize: 15.0),
                  textAlign: TextAlign.center,
                ),
              ),
              const Text(
                "- Podomoro App -",
                style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
