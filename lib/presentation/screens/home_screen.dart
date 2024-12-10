import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'settings_screen.dart';
import '../widgets/CustomBottomNavigationBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final GlobalKey<MainScreenState> _mainScreenKey = GlobalKey<MainScreenState>();

  Map<String, String> timeSettings = {
    'Pomodoro': '25',
    'Short Break': '05',
    'Long Break': '15',
  };

  void _onTabSelected(int index) {
    final isTimerRunning = _mainScreenKey.currentState?.isTimerRunning ?? false;
    final isTimerPaused = (_mainScreenKey.currentState?.durationInSeconds ?? 0) !=
        (_mainScreenKey.currentState?.selectedDurationInMinutes ?? 25) * 60;

    if ((isTimerRunning || isTimerPaused) && _currentIndex == 0 && index != 0) {
      _showTimerRunningOrPausedAlert();
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  void _updateSettings(Map<String, String> newSettings) {
    setState(() {
      timeSettings = newSettings;
    });
  }

  void _showTimerRunningOrPausedAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cannot Switch Tabs"),
          content: const Text(
              "You can't leave the timer screen while the timer is running or paused."),
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
  }

  @override
  Widget build(BuildContext context) {
    final isTimerRunning = _mainScreenKey.currentState?.isTimerRunning ?? false;

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
        isTimerRunning: isTimerRunning,
      ),
    );
  }
}
