import 'package:flutter/material.dart';

class Customtapbar extends StatefulWidget {
  final int pomodoroDuration;
  final int shortBreakDuration;
  final int longBreakDuration;
  final ValueChanged<int> onTabSelected;

  const Customtapbar({
    super.key,
    required this.pomodoroDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.onTabSelected,
  });

  @override
  State<Customtapbar> createState() => _CustomtapbarState();
}

class _CustomtapbarState extends State<Customtapbar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TabBar(
        onTap: (index) {
          if (index == 0) {
            widget.onTabSelected(widget.shortBreakDuration);
          } else if (index == 1) {
            widget.onTabSelected(widget.pomodoroDuration);
          } else if (index == 2) {
            widget.onTabSelected(widget.longBreakDuration);
          }
        },
        labelColor: Colors.purpleAccent,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
        unselectedLabelStyle: const TextStyle(fontSize: 16.0),
        isScrollable: true,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 4.0, color: Colors.purpleAccent),
          insets: EdgeInsets.symmetric(horizontal: 10.0),
        ),
        tabs: const [
          Tab(text: "Short Break"),
          Tab(text: "Pomodoro"),
          Tab(text: "Long Break"),
        ],
      ),
    );
  }
}
