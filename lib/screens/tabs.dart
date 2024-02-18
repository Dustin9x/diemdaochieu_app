import 'package:diemdaochieu_app/screens/articles_screen.dart';
import 'package:diemdaochieu_app/screens/notification_screen.dart';
import 'package:diemdaochieu_app/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectPageIndex = 1;

  void _selectPage(int index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = const ArticlesScreen();

    switch (_selectPageIndex) {
      case 0:
        activePage = const ArticlesScreen();
        break;
      case 1:
        activePage = const NotificationScreen();
        break;
      case 2:
        activePage = const ProfileScreen();
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Tin tức',
          ),
          BottomNavigationBarItem(
            activeIcon: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(Icons.notifications, color: Theme.of(context).colorScheme.primaryContainer),
              ),
            ),
            icon: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(Icons.notifications, color: Colors.white),
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Của tôi',
          ),
        ],
      ),
    );
  }
}
