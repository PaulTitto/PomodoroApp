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
  double progress = 1.0;
  int duration = 1500;
  int selectedDuration = 1500;
  Timer? _timer;

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
        selectedDuration = pomodoroDuration;
        duration = selectedDuration;
      });
    }
  }

  void startTimer() {
    _timer?.cancel();

    setState(() {
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
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    setState(() {
      duration = selectedDuration;
      progress = 1.0;
    });
  }

  void onTabSelected(int newDuration) {
    _timer?.cancel();
    setState(() {
      selectedDuration = newDuration;
      duration = selectedDuration;
      progress = 1.0;
    });
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
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
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
