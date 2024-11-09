import 'package:flutter/material.dart';
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
            _currentIndex == 0 ? Text("Home Screen") : Text("Settings Screen"),
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
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        backgroundColor: Color(0xFFD047FF),
        child: Icon(
          isPlaying ? Icons.play_arrow : Icons.stop,
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
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        backgroundColor: Color(0xFFD047FF),
        child: Icon(
          Icons.save,
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
