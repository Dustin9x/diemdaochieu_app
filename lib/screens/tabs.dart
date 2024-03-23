import 'package:diemdaochieu_app/screens/rpi_screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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
        activePage = const RPIScreen();
        break;
      case 2:
        activePage = const NotificationScreen();
        break;
      case 3:
        activePage = const RPIScreen();
        break;
      case 4:
        activePage = const ProfileScreen();
    }


    return Scaffold(
      body: activePage,
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          clipBehavior: Clip.antiAlias,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: _selectPage,
            currentIndex: _selectPageIndex,
            fixedColor: Colors.amber,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(EneftyIcons.document_text_outline),
                label: 'Tin tức',
                activeIcon: Icon(EneftyIcons.document_text_bold)
              ),
              const BottomNavigationBarItem(
                  icon: Icon(FluentIcons.gauge_24_regular),
                  label: 'RPI',
                  activeIcon: Icon(FluentIcons.gauge_24_filled)
              ),
              BottomNavigationBarItem(
                activeIcon: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      shape: BoxShape.circle,
                      border: Border.all(width: 4.0, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Badge(
                      label: Text('2'),
                      child: Icon(FluentIcons.alert_20_filled, color: Colors.white,),
                    ),
                  ),
                ),
                icon: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.05),
                      shape: BoxShape.circle,
                      border: Border.all(width: 4.0, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Badge(
                      label: Text('2'),
                      child: Icon(FluentIcons.alert_20_regular),
                    ),
                  ),
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                  icon: Icon(FluentIcons.gauge_24_regular),
                  label: 'RPI',
                  activeIcon: Icon(FluentIcons.gauge_24_filled)
              ),
              const BottomNavigationBarItem(
                icon: Icon(EneftyIcons.user_outline),
                activeIcon: Icon(EneftyIcons.user_bold),
                label: 'Của tôi',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
