import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podomoro_app/feature/screens/main_screen.dart';
import 'package:podomoro_app/feature/screens/settings_screen.dart';
import 'package:podomoro_app/feature/widgets/CustomBottomNavigationBar.dart';

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

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _saveSettingsToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection("podomoroapp").doc("5Z1axeBfpxb2CzviJYlu").update({
        'pomodoro': {
          'pomodoro': 25,  // Example values; replace with dynamic data if needed
          'shortBreak': 5,
          'longBreak': 10
        }
      });
      print("Settings saved successfully.");
    } catch (e) {
      print("Error saving settings: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _currentIndex == 0
            ? MainScreen(key: _mainScreenKey)  // Pass the GlobalKey to MainScreen
            : SettingsScreen(),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: _currentIndex == 0 ? _HomeFAB() : _SettingFAB(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onSelected: _onTabSelected,
      ),
    );
  }

  // Define the Floating Action Button for Play/Pause
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

        // Start or stop timer in MainScreen
        if (isPlaying) {
          _mainScreenKey.currentState?.startTimer();
        } else {
          _mainScreenKey.currentState?.stopTimer();
        }
      },
    );
  }

  // Define the Floating Action Button for Saving Settings
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
      onPressed: _saveSettingsToFirestore,
    );
  }
}
