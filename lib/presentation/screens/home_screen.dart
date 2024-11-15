import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podomoro_app/presentation/screens/settings_screen.dart';

import '../widgets/CustomBottomNavigationBar.dart';
import 'main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool isPlaying = false;

  // Define a GlobalKey to reference MainScreenState
  final GlobalKey<MainScreenState> _mainScreenKey = GlobalKey<MainScreenState>();

  // Data to store the settings
  Map<String, String> timeSettings = {
    'Pomodoro': '25',
    'Short Break': '05',
    'Long Break': '15',
  };

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Callback to update time settings
  void _updateSettings(Map<String, String> newSettings) {
    setState(() {
      timeSettings = newSettings;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _currentIndex == 0
            ? MainScreen(key: _mainScreenKey)
            : SettingsScreen(
          timeSettings: timeSettings,
          onSettingsUpdated: _updateSettings,
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        // child: _currentIndex == 0 ? _HomeFAB() : _SettingFAB(),
        child: _currentIndex == 0 ? _HomeFAB() : null,
      ),
      floatingActionButtonLocation: _currentIndex == 0 ? FloatingActionButtonLocation.endDocked : null,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onSelected: _onTabSelected,
      ),
    );
  }

  Widget _HomeFAB() {
    return FloatingActionButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
        side: BorderSide(color: Colors.white, width: 2.0),
      ),
      backgroundColor: const Color(0xFFD047FF),
      child: Icon(
        isPlaying ? Icons.stop : Icons.play_arrow,
        color: Colors.white,
        size: 40,
      ),
      onPressed: () {
        setState(() {
          isPlaying = !isPlaying;
        });

        if (isPlaying) {
          _mainScreenKey.currentState?.startTimer();
        } else {
          _mainScreenKey.currentState?.stopTimer();
        }
      },
    );
  }

  Widget _SettingFAB() {
    return FloatingActionButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
        side: BorderSide(color: Colors.white, width: 2.0),
      ),
      backgroundColor: const Color(0xFFD047FF),
      child: const Icon(
        Icons.check,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () {
        // You can call any function to save the settings here if needed
        _saveSettingsToFirestore();
      },
    );
  }

  Future<void> _saveSettingsToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection("pomodoroapp").doc("5Z1axeBfpxb2CzviJYlu").update({
        'pomodoro': {
          'pomodoro': int.parse(timeSettings['Pomodoro']!),
          'shortBreak': int.parse(timeSettings['Short Break']!),
          'longBreak': int.parse(timeSettings['Long Break']!),
        }
      });
      print("Settings saved successfully.");
    } catch (e) {
      print("Error saving settings: $e");
    }
  }
}
