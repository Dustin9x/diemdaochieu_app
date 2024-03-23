import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen>
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
          backgroundColor: Colors.white.withOpacity(0.95),
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
                  tabs: [
                    myTab('Cổ phiếu'),
                    myTab('Mua / Bán'),
                    myTab('Bài viết'),
                  ],
                ),
              ),
            ),
            title: const Text('Thông Báo'),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              Text('a'),
              Text('b'),
              Text('c'),
            ],
          )),
    );
  }
}
