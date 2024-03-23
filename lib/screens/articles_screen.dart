import 'package:diemdaochieu_app/providers/articleProvider.dart';
import 'package:diemdaochieu_app/screens/search_screen.dart';
import 'package:diemdaochieu_app/services/articleServices.dart';
import 'package:diemdaochieu_app/widgets/premium_articles.dart';
import 'package:flutter/material.dart';
import 'package:appbar_animated/appbar_animated.dart';
import 'package:enefty_icons/enefty_icons.dart';

import 'package:diemdaochieu_app/widgets/articles.dart';
import 'package:diemdaochieu_app/widgets/first_article.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArticlesScreen extends ConsumerWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    int size = 35;
    Future<void> onRefresh() {
      return ref.refresh(articleProvider).getArticles(size);
    }
    final data = ref.watch(articlesDataProvider(size));


    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(10, 0, 0, 0),
        body: data.when(
          data: (data) {
            List<dynamic> articleList = data.map((e) => e).toList();

            return ScaffoldLayoutBuilder(
              backgroundColorAppBar:
                  const ColorBuilder(Colors.transparent, Colors.white),
              textColorAppBar: const ColorBuilder(Colors.white, Colors.black),
              appBarBuilder: _appBar,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    FirstArticle(
                      article: articleList[0],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.375,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (int i = 1; i < 5; i++) Articles(article: articleList[i]),
                          const SizedBox(height: 12,),
                          const PremiumArticles(),
                          for (int i = 5; i < articleList.length; i++) Articles(article: articleList[i]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) => Text(stackTrace.toString()),
          loading: () => const Center(child: CircularProgressIndicator()),
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
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SearchScreen()));
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
