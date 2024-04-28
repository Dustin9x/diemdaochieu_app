import 'package:diemdaochieu_app/modal/login_request.dart';
import 'package:diemdaochieu_app/screens/search_screen.dart';
import 'package:diemdaochieu_app/utils/app_utils.dart';
import 'package:diemdaochieu_app/widgets/articles.dart';
import 'package:diemdaochieu_app/widgets/first_article.dart';
import 'package:diemdaochieu_app/widgets/premium_articles.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'dart:convert' show json, utf8;
import 'package:http/http.dart' as http;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:appbar_animated/appbar_animated.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  static const _pageSize = 35;
  var _activeCallbackIdentity;

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 35);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    initialization();
  }

  void initialization() async {
    await AppUtils.checkLoginState();
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    // FlutterNativeSplash.remove();
  }

  Future<void> _fetchPage(int pageKey) async {
    final callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;
    try {
      final newItems = await http.get(Uri.parse(
          'https://api-prod.diemdaochieu.com/article/client/recent-posts?size=$pageKey'));
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

  @override
  void dispose() {
    _pagingController.dispose();
    _activeCallbackIdentity = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(10, 0, 0, 0),
        body: ScaffoldLayoutBuilder(
          backgroundColorAppBar: const ColorBuilder(Colors.transparent, Colors.white),
          textColorAppBar: const ColorBuilder(Colors.white, Colors.black),
          appBarBuilder: _appBar,
          child: PagedListView<int, dynamic>(
            padding: EdgeInsets.zero,
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<dynamic>(
              itemBuilder: (context, item, index) {
                if(index == 0){
                  return FirstArticle(article: item);
                }if(index == 4){
                  return Column(
                    children: [
                      Articles (article: item),
                      const SizedBox(height: 10),
                      const PremiumArticles()
                    ],
                  );
                }
                  return Articles (article: item);
              },
            ),
          ),
        ),
      ),
    );
  }
}


Widget _appBar(BuildContext context, ColorAnimated colorAnimated) {
  return AppBar(
    surfaceTintColor: Colors.white,
    backgroundColor: colorAnimated.background,
    elevation: 0,
    title: Text(
      "ĐIỂM ĐẢO CHIỀU",
      style: TextStyle(
        fontWeight: FontWeight.w700,
        color: colorAnimated.color,
        shadows: <Shadow>[
          Shadow(
            offset: const Offset(0.0, 1.0),
            blurRadius: 10.0,
            color: Colors.grey.withOpacity(0.5),
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        onPressed: () async {
          var loggedUser  = await storage.read(key: "user");
          if(loggedUser == null){
            showDialog(context: context, builder: (BuildContext dialogContext){
              return const LoginRequestModal();
            });
          }else{
            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SearchScreen()));
          }
        },
        icon: Icon(
          EneftyIcons.search_normal_2_outline,
          color: colorAnimated.color,
          shadows: [
            Shadow(
              offset: const Offset(0.0, 1.0),
              blurRadius: 10.0,
              color: Colors.grey.withOpacity(0.5),
            ),
          ],
        ),
      ),
    ],
  );
}
