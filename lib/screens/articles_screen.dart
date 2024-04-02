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

class ArticlesScreen extends ConsumerStatefulWidget {
  const ArticlesScreen({super.key});

  @override
  ConsumerState<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends ConsumerState<ArticlesScreen> {

  final ScrollController _controller = ScrollController();
  int size = 35;

@override
  void initState() {
    super.initState();
    _controller.addListener(handleScrolling);
  }

  void handleScrolling() {
    if (_controller.offset >= _controller.position.maxScrollExtent - 200) {
      setState(() {
        size += 10;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> onRefresh() {
      return ref.refresh(articleProvider).getArticles(35);
    }
    final data = ref.watch(articlesDataProvider(size));

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(10, 0, 0, 0),
        body: data.when(
          data: (data) {
            List<dynamic> articleList = data.map((e) => e).toList();
            List<dynamic> list1 = articleList.sublist(0, 5);
            List<dynamic> list2 = articleList.sublist(5);

            return ScaffoldLayoutBuilder(
              backgroundColorAppBar:
                  const ColorBuilder(Colors.transparent, Colors.white),
              textColorAppBar: const ColorBuilder(Colors.white, Colors.black),
              appBarBuilder: _appBar,
              child: CustomScrollView(
                  controller: _controller,
                slivers:[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      FirstArticle(
                        article: articleList[0],
                      ),
                    ]),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((_, index) {
                        return Articles(article: list1[index]);
                      }, childCount: list1.length),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      const PremiumArticles(),
                    ]),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((_, index) {
                        return Articles(article: list2[index]);
                      }, childCount: list2.length)),
                ]
                // child: Stack(
                //   children: [
                //     FirstArticle(
                //       article: articleList[0],
                //     ),
                //     Container(
                //       margin: EdgeInsets.only(
                //         top: MediaQuery.of(context).size.height * 0.375,
                //       ),
                //       child: ListView(
                //         // mainAxisSize: MainAxisSize.min,
                //         controller: controller,
                //         shrinkWrap: true,
                //         physics: ClampingScrollPhysics(),
                //         children: <Widget>[
                //           for (int i = 1; i < 5; i++) Articles(article: articleList[i]),
                //           const SizedBox(height: 12,),
                //           const PremiumArticles(),
                //           for (int i = 5; i < articleList.length; i++) Articles(article: articleList[i]),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
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
