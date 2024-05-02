import 'package:diemdaochieu_app/utils/app_utils.dart';
import 'package:diemdaochieu_app/screens/notification/noti_tabpane.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key, required this.countGeneral, required this.countRealtime, required this.countBuySale});

  final int countGeneral;
  final int countRealtime;
  final int countBuySale;

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int indexTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
      setState(() {
        indexTab = _tabController.index;
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  late Color badgeColor = Colors.red;

  changeColor(int idx){
    if(_tabController.index != idx){
      setState(() {
        badgeColor = Colors.grey;
      });
    }
    return badgeColor;
  }
  Container myTab(String text, int count, int idx) {
    return Container(
      height: 30,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Tab(child: Row(
        children: [
          Text(text),
          const SizedBox(width: 4),
          if (count > 0) Badge(
            label: Text(AppUtils.notiBadge(count)),
            backgroundColor: _tabController.index != idx ? Colors.grey : null,
          )
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.normal),
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  tabs: [
                    myTab('Thông báo chung', widget.countGeneral, 0),
                    myTab('Realtime',widget.countRealtime, 1),
                    myTab('Mua / Bán',widget.countBuySale, 2),
                  ],
                ),
              ),
            ),
            title: const Text('Thông Báo'),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              NotiTapane(notiType: 'GENERAL', pageSize: 35),
              NotiTapane(notiType: 'REALTIME', pageSize: 35),
              NotiTapane(notiType: 'BUY_SALE', pageSize: 35),
            ],
          )),
    );
  }
}
