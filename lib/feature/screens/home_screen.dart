import 'package:flutter/material.dart';
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
  bool isSave = false;

  // Define timeSettings here
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _currentIndex == 0
            ? MainScreen(timeSettings: timeSettings) // Passing timeSettings
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
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 30,
      ),
      onPressed: () {
        setState(() {
          isSave = !isSave;
        });
      },
    );
  }
}
