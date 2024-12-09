import 'package:flutter/material.dart';
import 'dart:async'; // For Timer

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  double progress = 1.0;
  int duration = 1500;
  int selectedDuration = 1500;
  Timer? _timer;
  bool isTimerRunning = false; // Track if timer is running

  int shortBreakDuration = 300;
  int pomodoroDuration = 1500;
  int longBreakDuration = 900;

  int _selectedIndex = 0; // Track selected index in BottomNavigationBar

  // Timer functionality
  void startTimer() {
    _timer?.cancel();
    setState(() {
      isTimerRunning = true;
      progress = 1.0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (duration > 0) {
        setState(() {
          duration--;
          progress = duration / selectedDuration;
        });
      } else {
        timer.cancel();
        setState(() {
          isTimerRunning = false; // Reset timer status when done
        });
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    setState(() {
      isTimerRunning = false; // Pause timer
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      // Check which mode the timer is in, and set accordingly
      if (selectedDuration == pomodoroDuration) {
        // If in Pomodoro, switch to Short Break
        selectedDuration = shortBreakDuration;
        duration = selectedDuration;
        _selectedIndex = 0; // Switch to Short Break tab
      } else if (selectedDuration == shortBreakDuration) {
        // If in Short Break, switch to Pomodoro
        selectedDuration = pomodoroDuration;
        duration = selectedDuration;
        _selectedIndex = 1; // Switch to Pomodoro tab
      } else if (selectedDuration == longBreakDuration) {
        // If in Long Break, switch to Pomodoro
        selectedDuration = pomodoroDuration;
        duration = selectedDuration;
        _selectedIndex = 1; // Switch to Pomodoro tab
      }
      progress = 1.0;
      isTimerRunning = false; // Reset timer status
    });
  }

  // Function to handle content based on the selected tab
  void handleTabSelection(int index) {
    if (isTimerRunning) {
      // If timer is running, prevent tab change
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Cannot Swap"),
            content: const Text("You can't switch tabs while the timer is running."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      _selectedIndex = index;

      // Change the selected duration based on the tab
      if (index == 0) {
        selectedDuration = shortBreakDuration;
        duration = selectedDuration;
      } else if (index == 1) {
        selectedDuration = pomodoroDuration;
        duration = selectedDuration;
      } else if (index == 2) {
        selectedDuration = longBreakDuration;
        duration = selectedDuration;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pomodoro Timer")),
      body: Column(
        children: [
          // Bottom Navigation Bar at the top
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: handleTabSelection,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.timer),
                label: 'Short Break',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.brightness_2),
                label: 'Pomodoro',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.brightness_7),
                label: 'Long Break',
              ),
            ],
          ),

          // Timer and Progress Indicator
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Circle Background
                  Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.purpleAccent, Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Progress Circle
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  // Timer Display
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

          // Start/Pause and Stop Timer Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isTimerRunning) {
                      pauseTimer();
                    } else {
                      startTimer();
                    }
                  },
                  child: Icon(
                    isTimerRunning ? Icons.pause : Icons.play_arrow,
                    size: 40,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: const Color(0xFFD047FF),
                  ),
                ),
                if (!isTimerRunning && duration != selectedDuration)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ElevatedButton(
                      onPressed: stopTimer,
                      child: const Icon(
                        Icons.stop,
                        size: 40,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(20),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
