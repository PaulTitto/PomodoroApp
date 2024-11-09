import 'package:flutter/material.dart';

class Customappbar extends StatelessWidget implements PreferredSizeWidget {
  const Customappbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        "POMODORO",
        style: TextStyle(
            color: Color(0xFFD047FF),
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
