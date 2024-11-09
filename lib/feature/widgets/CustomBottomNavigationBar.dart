import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar(
      {super.key, required this.currentIndex, required this.onSelected});

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
        ],
      ),
    );
  }
}
