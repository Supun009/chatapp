import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentindex;
  final Function(int)? onTap;
  const BottomNavBar({
    super.key,
    required this.currentindex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: currentindex,
        onTap: onTap,
        selectedItemColor: Colors.grey.shade100,
        unselectedItemColor: Colors.grey.shade500,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
          ),
        ]);
  }
}
