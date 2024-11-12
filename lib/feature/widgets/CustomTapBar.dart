import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Customtapbar extends StatefulWidget {
  const Customtapbar({super.key});

  @override
  State<Customtapbar> createState() => _CustomtapbarState();
}

class _CustomtapbarState extends State<Customtapbar> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: TabBar(
          onTap: (index) {
            // if (index == 0) {
            //   startTimer(shortBreakDuration);
            // } else if (index == 1) {
            //   startTimer(pomodoroDuration);
            // } else if (index == 2) {
            //   startTimer(longBreakDuration);
            // }
          },
          labelColor: Colors.purpleAccent,
          dividerColor: Colors.transparent,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          unselectedLabelStyle: TextStyle(fontSize: 16.0),
          isScrollable: true,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 4.0, color: Colors.purpleAccent),
            insets: EdgeInsets.symmetric(horizontal: 10.0),
          ),
          tabs: [
            Tab(text: "short break"),
            Tab(text: "pomodoro"),
            Tab(text: "long break"),
          ],
        ),
    );
  }
}
