import 'package:diemdaochieu_app/services/RPIServices.dart';
import 'package:diemdaochieu_app/services/articleServices.dart';
import 'package:diemdaochieu_app/widgets/articles.dart';
import 'package:diemdaochieu_app/widgets/rpi/rpi_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gauge_indicator/gauge_indicator.dart';
import 'package:intl/intl.dart';

class RPIScreen extends ConsumerStatefulWidget {
  const RPIScreen({super.key});

  @override
  ConsumerState<RPIScreen> createState() => _RPIScreenState();
}

class _RPIScreenState extends ConsumerState<RPIScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<dynamic> getData() async {
    return ref.watch(rpiProvider).getRPI();
  }

  Future<dynamic> getRPIArticles(size) async {
    return ref.watch(articleProvider).getRPIArticles(size);
  }

  riskNameFromRpi(double rpi) {
    switch (rpi) {
      case (>= 0 && <= 0.99):
        return 'Cơ hội';
      case (>= 1 && <= 1.49):
        return 'Rủi ro thấp';
      case (>= 1.5 && <= 3.49):
        return 'Trung tính';
      case (>= 3.5 && <= 3.99):
        return 'Rủi ro';
      case (>= 4 && <= 5):
        return 'Rủi ro cao';
      default:
        return 'Bình thường';
    }
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    int size = 5;
    Container myTab(String text) {
      return Container(
        height: 30,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Tab(child: Text(text)),
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(10, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Chỉ Báo RPI'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: <Widget>[
          TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(40), color: Colors.white),
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
                myTab('Chỉ Báo RPI'),
                myTab('Cảnh Báo Đảo Chiều VN30'),
              ]),
          Center(
            child: [
              const RPITab(),
              Column(
                children: [
                  Text('second tab'),
                ],
              ),
            ][_tabController.index],
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('Serie Điểm Đảo Chiều',style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),),
          ),
          FutureBuilder(
              future: getRPIArticles(size),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData) {
                  getData();
                }
                List<dynamic> rpiArticles =
                    snapshot.data.map((e) => e).toList();
                // return Articles(article: rpiArticles[0]);
                return Column(
                  children: [
                    for (int i = 0; i < rpiArticles.length; i++)
                      Articles(article: rpiArticles[i])
                  ],
                );
              })
        ],
      ),
    );
  }
}
