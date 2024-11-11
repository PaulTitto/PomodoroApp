import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:podomoro_app/feature/screens/settings_screen.dart';
=======
>>>>>>> 106b4a84b11c4f0a2448b423731fc813b7a20d19
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

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
<<<<<<< HEAD
            _currentIndex == 0 ? Text("Home Screen") : SettingsScreen(),
=======
            _currentIndex == 0 ? Text("Home Screen") : Text("Settings Screen"),
>>>>>>> 106b4a84b11c4f0a2448b423731fc813b7a20d19
      ),
      floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: _currentIndex == 0 ? _HomeFAB() : _SettingFAB()),
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
<<<<<<< HEAD
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            side: BorderSide(
                color: Colors.white,
                width: 2.0
            )),
        backgroundColor: Color(0xFFD047FF),
        child: Icon(
          isPlaying ? Icons.stop : Icons.play_arrow,
=======
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        backgroundColor: Color(0xFFD047FF),
        child: Icon(
          isPlaying ? Icons.play_arrow : Icons.stop,
>>>>>>> 106b4a84b11c4f0a2448b423731fc813b7a20d19
          color: Colors.white,
          size: 40,
        ),
        onPressed: () {
          setState(() {
            isPlaying = !isPlaying;
          });
        });
  }

  Widget _SettingFAB() {
    return FloatingActionButton(
        shape: const RoundedRectangleBorder(
<<<<<<< HEAD
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            side: BorderSide(
              color: Colors.white,
              width: 2.0
            )
        ),
        backgroundColor: Color(0xFFD047FF),
        child: Icon(
          Icons.check,
=======
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        backgroundColor: Color(0xFFD047FF),
        child: Icon(
          Icons.save,
>>>>>>> 106b4a84b11c4f0a2448b423731fc813b7a20d19
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          setState(() {
            isSave = !isSave;
          });
        });
  }
}
