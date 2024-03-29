import 'package:diemdaochieu_app/widgets/notifications/buysell_noti_tab.dart';
import 'package:diemdaochieu_app/widgets/notifications/general_noti_tab.dart';
import 'package:diemdaochieu_app/widgets/notifications/realtime_noti_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Container myTab(String text) {
      return Container(
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Tab(child: Text(text)),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
          backgroundColor: const Color.fromARGB(10, 0, 0, 0),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(40), // Creates border
                      color: Colors.white),
                  isScrollable: true,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.normal),
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  // onTap: (index){
                  //   print(index);
                  // },
                  tabs: [
                    myTab('Thông báo chung'),
                    myTab('Realtime'),
                    myTab('Mua / Bán'),
                  ],
                ),
              ),
            ),
            title: const Text('Thông Báo'),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              GeneralNoti(),
              RealtimeNoti(),
              BuySellNoti()
            ],
          )),
    );
  }
}
