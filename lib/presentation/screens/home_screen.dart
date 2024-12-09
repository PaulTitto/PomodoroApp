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

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Center(
          child: _currentIndex == 0
              ? MainScreen(key: _mainScreenKey)
              : SettingsScreen(
            timeSettings: timeSettings,
            onSettingsUpdated: _updateSettings,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onSelected: _onTabSelected,
      ),
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
