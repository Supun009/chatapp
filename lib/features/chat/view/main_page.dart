import 'package:chatapp/features/chat/view/allchat_page.dart';
import 'package:chatapp/features/chat/view/profile_page.dart';
import 'package:chatapp/features/chat/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AllChatPage(),
    const ProfilePage(),
  ];

  void _navigateBottomnavbar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavBar(
          currentindex: _currentIndex,
          onTap: _navigateBottomnavbar,
        ));
  }
}
