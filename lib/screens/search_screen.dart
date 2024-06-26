import 'dart:convert' show json, utf8;
import 'dart:io';
import 'package:diemdaochieu_app/utils/app_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:http/http.dart' as http;
import 'package:diemdaochieu_app/screens/article/articles.dart';
import 'package:diemdaochieu_app/screens/notification/notification_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
var storage = const FlutterSecureStorage();

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
    getUserInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  var notiData;
  var articleData;
  var articleDDC;

  var isLoading = false;

  void _submitSearch(String value) async {
    setState(() {
      isLoading = true; // Set loading state to true
    });

    try {
      var userToken = await storage.read(key: 'jwt');
      Map<String, String> requestHeaders = {
        'platform': Platform.operatingSystem.toUpperCase(),
        'Content-Type': 'application/json',
        'X-Ddc-Token': userToken.toString(),
      };
      final result = await Future.wait([
        http.get(Uri.parse(
            'https://api-prod.diemdaochieu.com/client/data/search?keyword=$value&type=NOTIFICATION'),headers: requestHeaders),
        http.get(Uri.parse(
            'https://api-prod.diemdaochieu.com/client/data/search?keyword=$value&type=ARTICLE')),
        http.get(Uri.parse(
            'https://api-prod.diemdaochieu.com/client/data/search?keyword=$value&type=ARTICLEDDC')),
      ]);

      final result1 = json.decode(utf8.decode(result[0].bodyBytes))['data']
          ['notifications'];
      final result2 =
          json.decode(utf8.decode(result[1].bodyBytes))['data']['articles'];
      final result3 =
          json.decode(utf8.decode(result[2].bodyBytes))['data']['articles'];

      setState(() {
        notiData = result1.map((e) => e).toList();
        articleData = result2.map((e) => e).toList();
        articleDDC = result3.map((e) => e).toList();
        isLoading = false;
      });
    } catch (error) {
      rethrow;
    }
  }

  bool isPremium = false;

  void getUserInfo() async{
    if (await storage.read(key: "user") != null){
    var userInfo = await storage.read(key: 'user');
    var userPackage = json.decode(userInfo!);
    setState(() {
      isPremium = userPackage['permissions'].contains('WEB_CLIENT') || userPackage['permissions'].contains('PAID_ARTICLE') || !userPackage['packages'].contains('FREE');
    });
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
                    myTab('Cảnh Báo Mua / Bán'),
                    myTab('Bài viết'),
                    myTab('Bài viết DDC'),
                  ],
                ),
              ),
            ),
            title: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                filled: true,
                hintStyle: TextStyle(color: Colors.grey[800]),
                hintText: "Nhập nội dung tìm kiếm",
                fillColor: Colors.white70,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              textInputAction: TextInputAction.go,
              onFieldSubmitted: (value) {
                _submitSearch(value);
              },
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: isLoading == false && notiData == null
                    ? const Center(child: Text('Vui lòng nhập nội dung tìm kiếm'))
                    : isLoading == true
                        ? const Center(child: CircularProgressIndicator())
                        : notiData.length == 0
                            ? const Center(child: Text('Không có kết quả, vui lòng thử từ khóa khác'))
                            : ListView.builder(
                                itemCount: notiData?.length,
                                itemBuilder: (ctx, index) {
                                  return Column(
                                    children: [
                                      const SizedBox(height: 4),
                                      AppUtils.dateNoti(notiData?[index]['pushFinishAt'], isPremium),
                                      Notifications(notification: notiData?[index]),
                                    ],
                                  );
                                },
                              ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: isLoading == false && articleData == null
                    ? const Center(child: Text('Vui lòng nhập nội dung tìm kiếm'))
                    : isLoading == true
                        ? const Center(child: CircularProgressIndicator())
                        : articleData.length == 0
                            ? const Center(child: Text('Không có kết quả, vui lòng thử từ khóa khác'))
                            : ListView.builder(
                                itemCount: articleData?.length,
                                itemBuilder: (ctx, index) {
                                  return Articles(article: articleData?[index]);
                                },
                              ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: isLoading == false && articleDDC == null
                    ? const Center(child: Text('Vui lòng nhập nội dung tìm kiếm'))
                    : isLoading == true
                        ? const Center(child: CircularProgressIndicator())
                        : articleDDC.length == 0
                            ? const Center(child: Text('Không có kết quả, vui lòng thử từ khóa khác'))
                            : ListView.builder(
                                itemCount: articleDDC?.length,
                                itemBuilder: (ctx, index) {
                                  return Articles(article: articleDDC?[index]);
                                },
                              ),
              ),
            ],
          )),
    );
  }
}
