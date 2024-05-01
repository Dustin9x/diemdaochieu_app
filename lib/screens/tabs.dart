import 'package:diemdaochieu_app/modal/login_request.dart';
import 'package:diemdaochieu_app/providers/notificationProvider.dart';
import 'package:diemdaochieu_app/screens/archived_articles_screen.dart';
import 'package:diemdaochieu_app/screens/rpi_screen.dart';
import 'package:diemdaochieu_app/utils/app_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diemdaochieu_app/screens/articles_screen.dart';
import 'package:diemdaochieu_app/screens/notification_screen.dart';
import 'package:diemdaochieu_app/screens/profile_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectPageIndex = 0;
  var storage = const FlutterSecureStorage();
  var isLoggedIn;

  void _selectPage(int index)  async {
    var loggedUser  = await storage.read(key: "user");
    if(loggedUser == null && index == 2){
      showDialog(context: context, builder: (BuildContext dialogContext){
        return const LoginRequestModal();
      });
    }else{
      setState(() {
        _selectPageIndex = index;
      });
    }
  }

  loginState() async {
    isLoggedIn = await AppUtils.checkLoginState();
  }

  void setUpPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    final tokenNotification = fcm.getToken();

  }

  @override
  void initState() {
    // TODO: implement initState
    // fetchNotiCount();
    super.initState();
    loginState();
    setUpPushNotifications();
  }

  // Future<void> fetchNotiCount() async {
  //   var listNotiCount = ref.watch(getNotiCountProvider).value;
  //   setState(() {
  //     if (listNotiCount != null) {
  //       for (var item in listNotiCount) {
  //         if (item['type'] == "ALL") {
  //           totalNoti = item['total'];
  //         }
  //         if (item['type'] == "REALTIME") {
  //           totalRealtime = item['total'];
  //         }
  //         if (item['type'] == "GENERAL") {
  //           totalGeneral = item['total'];
  //         }
  //         if (item['type'] == "BUY_SALE") {
  //           totalBuysale = item['total'];
  //         }
  //       }
  //     }
  //   });
  // }

  int totalNoti = 0;
  int totalRealtime = 0;
  int totalGeneral = 0;
  int totalBuysale = 0;

  @override
  Widget build(BuildContext context) {

    late final data = ref.watch(getNotiCountProvider);

    if(data.hasValue){
      var listNotiCount = data.value;
      if (listNotiCount != null) {
        for (var item in listNotiCount) {
          if (item['type'] == "ALL") {
            totalNoti = item['total'];
          }
          if (item['type'] == "REALTIME") {
            totalRealtime = item['total'];
          }
          if (item['type'] == "GENERAL") {
            totalGeneral = item['total'];
          }
          if (item['type'] == "BUY_SALE") {
            totalBuysale = item['total'];
          }
        }
      }
    }


    Widget activePage = const ArticlesScreen();

    switch (_selectPageIndex) {
      case 0:
        activePage = const ArticlesScreen();
        break;
      case 1:
        activePage = const RPIScreen();
        break;
      case 2:
        activePage = NotificationScreen(
          countGeneral: totalGeneral,
          countRealtime: totalRealtime,
          countBuySale: totalBuysale,
        );
        break;
      case 3:
        activePage = const ArchivedArticlesScreen();
        break;
      case 4:
        activePage = const ProfileScreen();
    }

    return Scaffold(
      body: activePage,
      //extendBody: true,
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
                  activeIcon: Icon(EneftyIcons.document_text_bold)),
              const BottomNavigationBarItem(
                  icon: Icon(FluentIcons.gauge_24_regular),
                  label: 'RPI',
                  activeIcon: Icon(FluentIcons.gauge_24_filled)),
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
                    child: isLoggedIn == true ? Badge(
                      label:
                          Text(AppUtils.notiBadge(totalNoti)),
                      child: const Icon(
                        FluentIcons.alert_20_filled,
                        color: Colors.white,
                      ),
                    ) : const Icon(
                      FluentIcons.alert_20_filled,
                      color: Colors.white,
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
                    child: isLoggedIn == true ? Badge(
                      label:
                      Text(totalNoti > 99 ? '99+' : totalNoti.toString()),
                      child: const Icon(FluentIcons.alert_20_regular),
                    ): const Icon(FluentIcons.alert_20_regular),
                  ),
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                  icon: Icon(FluentIcons.bookmark_20_regular),
                  label: 'Tin đã lưu',
                  activeIcon: Icon(FluentIcons.bookmark_20_filled)),
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
