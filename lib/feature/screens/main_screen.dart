import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/CustomTapBar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  double progress = 1.0;  // Start with full progress
  int duration = 1500;    // Default duration in seconds (25 minutes)
  int selectedDuration = 1500; // Duration to reset to when restarting timer
  Timer? _timer;

  // Default durations for each mode
  int shortBreakDuration = 300;
  int pomodoroDuration = 1500;
  int longBreakDuration = 900;

  Future<void> _fetchDataFromFirestore() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("podomoroapp")
        .doc("5Z1axeBfpxb2CzviJYlu")
        .get();

    if (snapshot.exists) {
      setState(() {
        pomodoroDuration = int.parse(snapshot['pomodoro']['pomodoro'].toString()) * 60;
        shortBreakDuration = int.parse(snapshot['pomodoro']['shortBreak'].toString()) * 60;
        longBreakDuration = int.parse(snapshot['pomodoro']['longBreak'].toString()) * 60;
        selectedDuration = pomodoroDuration;  // Set initial selected duration to Pomodoro
        duration = selectedDuration;
      });
    }
  }

  void startTimer() {
    _timer?.cancel(); // Cancel any existing timer

    setState(() {
      progress = 1.0;  // Reset progress to full
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (duration > 0) {
        setState(() {
          duration--;
          progress = duration / selectedDuration;  // Update progress based on selected duration
        });
      } else {
        timer.cancel();  // Stop timer when it reaches zero
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      duration = selectedDuration;  // Reset duration to the selected duration
      progress = 1.0;               // Reset progress to full
    });
  }

  // Method to update duration based on the selected tab
  void onTabSelected(int newDuration) {
    _timer?.cancel();  // Stop any active timer
    setState(() {
      selectedDuration = newDuration;  // Update the base duration for the timer
      duration = selectedDuration;     // Reset the timer to the new duration
      progress = 1.0;                  // Reset progress to full
    });
    // startTimer();  // Start the timer with the new duration
  }

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
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
                      ),
                    ),
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: CircularProgressIndicator(
                        value: progress,  // Reflect progress in the CircularProgressIndicator
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    // Display the remaining time in MM:SS format
                    Text(
                      "${(duration ~/ 60).toString().padLeft(2, '0')}:${(duration % 60).toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Pass the callback to handle tab selection and update the timer
            Customtapbar(
              pomodoroDuration: pomodoroDuration,
              shortBreakDuration: shortBreakDuration,
              longBreakDuration: longBreakDuration,
              onTabSelected: onTabSelected,
            ),
          ],
        ),
      ),
    );
  }
}
