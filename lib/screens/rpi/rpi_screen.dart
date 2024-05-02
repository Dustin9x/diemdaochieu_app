import 'package:appbar_animated/appbar_animated.dart';
import 'package:diemdaochieu_app/modal/premium_request.dart';
import 'package:diemdaochieu_app/services/RPIServices.dart';
import 'package:diemdaochieu_app/services/articleServices.dart';
import 'package:diemdaochieu_app/screens/article/articles.dart';
import 'package:diemdaochieu_app/screens/rpi/rpi_tab.dart';
import 'package:diemdaochieu_app/screens/rpi/vn30_rpi_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, utf8;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;

class RPIScreen extends ConsumerStatefulWidget {
  const RPIScreen({super.key});

  @override
  ConsumerState<RPIScreen> createState() => _RPIScreenState();
}

class _RPIScreenState extends ConsumerState<RPIScreen>
    with SingleTickerProviderStateMixin {
  var storage = const FlutterSecureStorage();
  static const _pageSize = 5;
  var _activeCallbackIdentity;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 5);
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pagingController.dispose();
    _activeCallbackIdentity = null;
    super.dispose();
  }

  Future<void> _fetchPage(int pageKey) async {
    final callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;
    try {
      final newItems = await http.get(Uri.parse(
          'https://api-prod.diemdaochieu.com/article/client/posts-by-category?id=13&page=0&size=$pageKey'));
      if (callbackIdentity == _activeCallbackIdentity) {
        pageKey = pageKey + _pageSize;
        final result = json.decode(utf8.decode(newItems.bodyBytes))['data'];
        _pagingController.appendPage(result, pageKey);
      }
    } catch (error) {
      if (callbackIdentity == _activeCallbackIdentity) {
        _pagingController.error = error;
      }
    }
  }



  _handleTabSelection() async {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 1) {
        var userInfo = await storage.read(key: 'user');
        if (userInfo != null) {
          var userPackage = json.decode(userInfo);
          bool isPremium = userPackage['permissions'].contains('WEB_CLIENT') ||
              userPackage['permissions'].contains('PAID_ARTICLE') ||
              !userPackage['packages'].contains('FREE');
          if (isPremium == false) {
            showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return const PremiumRequestModal();
                });
            _tabController.index = 0;
          } else {
            setState(() {});
          }
        } else {
          showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return const PremiumRequestModal();
              });
          _tabController.index = 0;
        }
      } else {
        setState(() {});
      }
    }
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

    return Scaffold(
      extendBodyBehindAppBar: false,
      backgroundColor: const Color.fromARGB(10, 0, 0, 0),
      appBar: AppBar(
        title: const Text('Chỉ Báo RPI'),
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.transparent,
      ),
      body: PagedListView<int, dynamic>(
        padding: EdgeInsets.zero,
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<dynamic>(
          itemBuilder: (context, item, index) {
            if (index == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.white),
                      isScrollable: true,
                      overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
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
                      const VN30RPITab()
                    ][_tabController.index],
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        Text(
                          'Serie Điểm Đảo Chiều',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Articles(article: item)
                ],
              );
            }
            return Articles(article: item);
          },
        ),
      ),
    );
  }
}
