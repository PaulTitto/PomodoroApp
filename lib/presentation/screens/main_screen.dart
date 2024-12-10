import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async'; // For Timer

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  double progress = 1.0;
  int durationInMinutes = 25; // Start with 25 minutes (Pomodoro duration)
  int selectedDurationInMinutes = 25; // Default Pomodoro duration in minutes
  int durationInSeconds = 1500; // Duration in seconds (default 25 mins * 60)
  Timer? _timer;
  bool isTimerRunning = false;

  int shortBreakDuration = 5; // in minutes
  int pomodoroDuration = 25; // in minutes
  int longBreakDuration = 15; // in minutes

  int _selectedIndex = 1;

  // A map to store time settings fetched from Firestore
  Map<String, int> timeSettings = {};

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore();
  }

  Future<void> _fetchDataFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("pomodoroapp")
          .doc("5Z1axeBfpxb2CzviJYlu")
          .get();

      if (snapshot.exists) {
        setState(() {
          // Retrieve time settings and set durations (in minutes)
          timeSettings['Pomodoro'] = _validateTime(snapshot['pomodoro']['pomodoro'].toString());
          timeSettings['Short Break'] = _validateTime(snapshot['pomodoro']['shortBreak'].toString());
          timeSettings['Long Break'] = _validateTime(snapshot['pomodoro']['longBreak'].toString());

          // Update durations based on Firestore values
          pomodoroDuration = timeSettings['Pomodoro'] ?? 25;
          shortBreakDuration = timeSettings['Short Break'] ?? 5;
          longBreakDuration = timeSettings['Long Break'] ?? 15;

          // Set the selected duration initially to Pomodoro
          selectedDurationInMinutes = pomodoroDuration;
          durationInMinutes = selectedDurationInMinutes;
          durationInSeconds = selectedDurationInMinutes * 60; // Convert minutes to seconds
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  int _validateTime(String time) {
    // Ensure time is a valid integer and convert to minutes
    int validTime = int.tryParse(time) ?? 25;
    return validTime > 0 ? validTime : 25;
  }

  // Timer functionality
  void startTimer() {
    _timer?.cancel();
    setState(() {
      isTimerRunning = true;
      progress = 1.0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (durationInSeconds > 0) {
        setState(() {
          durationInSeconds--;
          progress = durationInSeconds / (selectedDurationInMinutes * 60); // update progress
        });
      } else {
        timer.cancel();
        setState(() {
          isTimerRunning = false;
        });
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    setState(() {
      isTimerRunning = false;
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      if (selectedDurationInMinutes == pomodoroDuration) {
        selectedDurationInMinutes = shortBreakDuration;
        durationInSeconds = selectedDurationInMinutes * 60; // convert to seconds
        _selectedIndex = 0;
      } else if (selectedDurationInMinutes == shortBreakDuration) {
        selectedDurationInMinutes = pomodoroDuration;
        durationInSeconds = selectedDurationInMinutes * 60; // convert to seconds
        _selectedIndex = 1;
      } else if (selectedDurationInMinutes == longBreakDuration) {
        selectedDurationInMinutes = pomodoroDuration;
        durationInSeconds = selectedDurationInMinutes * 60; // convert to seconds
        _selectedIndex = 1;
      }
      progress = 1.0;
      isTimerRunning = false;
    });
  }

  void handleTabSelection(int index) {
    // Check if the timer is running or paused
    if (isTimerRunning || durationInSeconds != selectedDurationInMinutes * 60) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Cannot Swap"),
            content: const Text("You can't switch tabs while the timer is running or paused."),
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

      if (index == 0) {
        selectedDurationInMinutes = shortBreakDuration;
        durationInSeconds = selectedDurationInMinutes * 60;
      } else if (index == 1) {
        selectedDurationInMinutes = pomodoroDuration;
        durationInSeconds = selectedDurationInMinutes * 60;
      } else if (index == 2) {
        selectedDurationInMinutes = longBreakDuration;
        durationInSeconds = selectedDurationInMinutes * 60;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pomodoro Timer")),
      body: Column(
        children: [
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: handleTabSelection,
            selectedItemColor: const Color(0xFFD047FF),
            unselectedItemColor: Colors.grey,
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
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
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
                  Text(
                    "${(durationInSeconds ~/ 60).toString().padLeft(2, '0')}:${(durationInSeconds % 60).toString().padLeft(2, '0')}",
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
                    padding: const EdgeInsets.all(20),
                    backgroundColor: const Color(0xFFD047FF),
                  ),
                ),
                if (!isTimerRunning && durationInSeconds != selectedDurationInMinutes * 60)
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
                        padding: const EdgeInsets.all(20),
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
