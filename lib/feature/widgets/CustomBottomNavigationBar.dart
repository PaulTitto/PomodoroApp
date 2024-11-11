import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
<<<<<<< HEAD
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });
=======
  const CustomBottomNavigationBar(
      {super.key, required this.currentIndex, required this.onSelected});
>>>>>>> 106b4a84b11c4f0a2448b423731fc813b7a20d19

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
<<<<<<< HEAD
            onPressed: () => onSelected(0),
            icon: Icon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
              size: 35.0,
              color: currentIndex == 0 ? Color(0xFFD047FF) : Colors.grey,
            ),
          ),
          IconButton(
            onPressed: () => onSelected(1),
            icon: Icon(
              currentIndex == 1 ? Icons.settings : Icons.settings_outlined,
              size: 35.0,
              color: currentIndex == 1 ? Color(0xFFD047FF) : Colors.grey,
            ),
          ),
          const SizedBox(
            width: 70, // Space for FAB or additional center item if needed
          ),
=======
              onPressed: () => onSelected(0),
              icon: Icon(
                Icons.home,
                color: currentIndex == 0 ? Color(0xFFD047FF) : Colors.grey,
              )),
          IconButton(
              onPressed: () => onSelected(1),
              icon: Icon(
                Icons.settings,
                color: currentIndex == 1 ? Color(0xFFD047FF) : Colors.grey,
              )),
          SizedBox(
            width: 70,
          )
>>>>>>> 106b4a84b11c4f0a2448b423731fc813b7a20d19
        ],
      ),
    );
  }
}
