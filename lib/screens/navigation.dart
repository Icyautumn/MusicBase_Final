import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/chat_main_screen.dart';
import 'package:chat_application/screens/homework_detail_screen.dart';
import 'package:chat_application/screens/lesson_detail_list.screen.dart';
import 'package:chat_application/screens/metronome.dart';
import 'package:chat_application/screens/setting_screen_final.dart';
import 'package:chat_application/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  UserModel user;
  Navigation(this.user);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [
      LessonDetailListScreen(widget.user),
      ChatMainScreen(widget.user),
      HomeworkDetailListScreen(widget.user),
      Metronome(),
      Setting_Screen(widget.user)
      // SettingScreen(widget.user),
      
    ];
    return Scaffold(
      body: Center(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int newIndex) {
          setState(() {
            _currentIndex = newIndex;
          });
        },
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.description),
            icon: Icon(Icons.description_outlined),
            label: 'Lesson',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.chat),
            icon: Icon(Icons.chat_outlined),
            label: 'Chat',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.format_list_bulleted),
            icon: Icon(Icons.format_list_bulleted_outlined),
            label: 'Homework',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.speed),
            icon: Icon(Icons.speed_outlined),
            label: 'Metronome',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.account_circle),
            icon: Icon(Icons.account_circle_outlined),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}