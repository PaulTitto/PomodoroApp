import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onSelected,
    required this.isTimerRunning,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;
  final bool isTimerRunning;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(width: 40),
          _buildNavItem(
            context,
            icon: currentIndex == 0 ? Icons.home : Icons.home_outlined,
            isSelected: currentIndex == 0,
            onPressed: () => _handleTabSelection(context, 0),
          ),
          _buildNavItem(
            context,
            icon: currentIndex == 1 ? Icons.settings : Icons.settings_outlined,
            isSelected: currentIndex == 1,
            onPressed: () => _handleTabSelection(context, 1),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, {
        required IconData icon,
        required bool isSelected,
        required VoidCallback onPressed,
      }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 35.0,
        color: isSelected ? const Color(0xFFD047FF) : Colors.grey,
      ),
    );
  }

  void _handleTabSelection(BuildContext context, int index) {
    if (index != currentIndex) {
      if (isTimerRunning && currentIndex == 0) {
        _showTimerRunningAlert(context);
      } else {
        onSelected(index);
      }
    }
  }

  void _showTimerRunningAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cannot Switch Tabs"),
          content: const Text("You can't leave the timer screen while it is running."),
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
}
