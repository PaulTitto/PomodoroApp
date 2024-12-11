import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  double progress = 1.0;
  int durationInMinutes = 25;
  int selectedDurationInMinutes = 25; // Default Pomodoro duration in minutes
  int durationInSeconds = 1500; // Duration in seconds
  Timer? _timer;
  bool isTimerRunning = false;
  bool isTimerPaused = false;

  int shortBreakDuration = 5; // in minutes
  int pomodoroDuration = 25; // in minutes
  int longBreakDuration = 15; // in minutes

  int allResultDuration = 0;
  int _selectedIndex = 1;
  bool _isAlertVisible = false;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Initialize audio player

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
        final data = snapshot.data() as Map<String, dynamic>;
        final pomodoroData = data['pomodoro'] ?? {};

        setState(() {
          pomodoroDuration = _validateTime(pomodoroData['Pomodoro']);
          shortBreakDuration = _validateTime(pomodoroData['Short Break']);
          longBreakDuration = _validateTime(pomodoroData['Long Break']);
          allResultDuration = data['all_result'] ?? 0;

          selectedDurationInMinutes = pomodoroDuration;
          durationInMinutes = selectedDurationInMinutes;
          durationInSeconds = selectedDurationInMinutes * 60; // Convert to seconds
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  int _validateTime(dynamic time) {
    if (time == null) return 25; // Default value
    if (time is int) return time > 0 ? time : 25;
    if (time is String) {
      final parsedTime = int.tryParse(time);
      return parsedTime != null && parsedTime > 0 ? parsedTime : 25;
    }
    return 25;
  }

  void updateAllResultDuration(int additionalMinutes) async {
    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection("pomodoroapp")
          .doc("5Z1axeBfpxb2CzviJYlu");

      await documentReference.update({
        'all_result': FieldValue.increment(additionalMinutes),
      });

      setState(() {
        allResultDuration += additionalMinutes;
      });

      print("Successfully updated all result duration!");
    } catch (e) {
      print("Error updating all result duration: $e");
    }
  }

  void startTimer() {
    _timer?.cancel();
    setState(() {
      isTimerRunning = true;
      isTimerPaused = false;
      progress = 1.0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (durationInSeconds > 0) {
        setState(() {
          durationInSeconds--;
          progress = durationInSeconds / (selectedDurationInMinutes * 60);
        });
      } else {
        timer.cancel();
        setState(() {
          isTimerRunning = false;
          isTimerPaused = false;
          _resetTimer();
        });

        _playSound();
        _showTimerRunningOrPausedAlert();
        addMinutesForToday(selectedDurationInMinutes);
        updateAllResultDuration(selectedDurationInMinutes);
      }
    });
  }

  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(
        AssetSource('done.mp3'),
      );
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void _showTimerRunningOrPausedAlert() {
    if (_isAlertVisible) return;

    _isAlertVisible = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pomodoro Timer Alert"),
          content: const Text(
              "The Pomodoro timer has completed. Take a break or start a new session."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                _isAlertVisible = false;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  void pauseTimer() {
    _timer?.cancel();
    setState(() {
      isTimerRunning = false;
      isTimerPaused = true;
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      isTimerRunning = false;
      isTimerPaused = false;
      _resetTimer();
    });
  }

  void _resetTimer() {
    setState(() {
      durationInMinutes = selectedDurationInMinutes;
      durationInSeconds = selectedDurationInMinutes * 60;
      progress = 1.0;
    });
  }

  void handleTabSelection(int index) {
    if (isTimerRunning) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Cannot Switch"),
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

      if (index == 0) {
        selectedDurationInMinutes = shortBreakDuration;
      } else if (index == 1) {
        selectedDurationInMinutes = pomodoroDuration;
      } else if (index == 2) {
        selectedDurationInMinutes = longBreakDuration;
      }

      _resetTimer();
    });
  }

  void addMinutesForToday(int minutes) async {
    final formattedDate = _getCurrentFormattedDate();
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("pomodoroapp")
        .doc("5Z1axeBfpxb2CzviJYlu");

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          // If the document doesn't exist, create it and add today's entry
          transaction.set(documentReference, {
            'time': {formattedDate: minutes}, // Initialize with today's data
          });
          print("Document created. Added $minutes minutes for $formattedDate.");
        } else {
          // If the document exists, handle the 'time' map
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          Map<String, dynamic> timeMap = data['time'] ?? {};

          // Check if the 'time' field is missing, and initialize it if necessary
          if (timeMap.isEmpty) {
            transaction.update(documentReference, {
              'time': {formattedDate: minutes},
            });
            print("Initialized 'time' field. Added $minutes minutes for $formattedDate.");
          } else {
            // Update or add today's minutes
            int currentMinutes = timeMap[formattedDate] ?? 0;
            int updatedMinutes = currentMinutes + minutes;

            transaction.update(documentReference, {
              'time.$formattedDate': updatedMinutes,
            });
            print("Updated $formattedDate to $updatedMinutes minutes.");
          }
        }
      });
    } catch (e) {
      print("Error adding minutes for today: $e");
    }
  }

  String _getCurrentFormattedDate() {
    final now = DateTime.now();
    return "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
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
                  onPressed: isTimerRunning ? pauseTimer : startTimer,
                  child: Icon(
                    isTimerRunning ? Icons.pause : Icons.play_arrow,
                    size: 40,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: const Color(0xFFD047FF),
                  ),
                ),
                if (isTimerPaused)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: ElevatedButton(
                      onPressed: stopTimer,
                      child: const Icon(
                        Icons.stop,
                        size: 40,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
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
