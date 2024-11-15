import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () => onSelected(0),
            icon: Icon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
              size: 35.0,
              color: currentIndex == 0 ? const Color(0xFFD047FF) : Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () => onSelected(1),
            icon: Icon(
              currentIndex == 1 ? Icons.settings : Icons.settings_outlined,
              size: 35.0,
              color: currentIndex == 1 ? const Color(0xFFD047FF) : Colors.grey,
            ),
          ),
          const SizedBox(
            width: 70,
          ),
        ],
      ),
    );
  }
}
