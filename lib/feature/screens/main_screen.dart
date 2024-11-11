import 'dart:async';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  final Map<String, String> timeSettings;

  const MainScreen({super.key, required this.timeSettings});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double progress = 1.0;
  int duration = 1500;  // Default to Pomodoro duration
  Timer? _timer;

  late int shortBreakDuration;
  late int pomodoroDuration;
  late int longBreakDuration;

  late String timeText;


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        body: Column(
          children: [
            // Timer Display
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Gradient background circle
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.purpleAccent, Colors.purple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                    ),
                    // Circular progress indicator
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    // Center text
                    Text(
                      timeText,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TabBar(
                  onTap: (index) {
                    // if (index == 0) {
                    //   startTimer(shortBreakDuration);
                    // } else if (index == 1) {
                    //   startTimer(pomodoroDuration);
                    // } else if (index == 2) {
                    //   startTimer(longBreakDuration);
                    // }
                  },
                  labelColor: Colors.purpleAccent,
                  unselectedLabelColor: Colors.grey,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(width: 4.0, color: Colors.purpleAccent),
                    insets: EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                  tabs: [
                    Tab(text: "short break"),
                    Tab(text: "pomodoro"),
                    Tab(text: "long break"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
