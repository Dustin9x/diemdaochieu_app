import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:diemdaochieu_app/screens/articles_screen.dart';
import 'package:diemdaochieu_app/screens/notification_screen.dart';
import 'package:diemdaochieu_app/screens/profile_screen.dart';


class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectPageIndex = 0;

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
          const BottomNavigationBarItem(
            icon: Icon(EneftyIcons.document_text_outline),
            label: 'Tin tức',
            activeIcon: Icon(EneftyIcons.document_text_bold)
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
                child: Icon(EneftyIcons.notification_bold, color: Theme.of(context).colorScheme.primaryContainer),
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
                child: const Icon(EneftyIcons.notification_outline, color: Colors.white),
              ),
            ),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(EneftyIcons.user_outline),
            activeIcon: Icon(EneftyIcons.user_bold),
            label: 'Của tôi',
          ),
        ],
      ),
    );
  }
}
