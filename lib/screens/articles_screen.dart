import 'package:flutter/material.dart';
import 'package:appbar_animated/appbar_animated.dart';
import 'package:enefty_icons/enefty_icons.dart';

import 'package:diemdaochieu_app/widgets/articles.dart';
import 'package:diemdaochieu_app/widgets/first_article.dart';


class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(20, 0, 0, 0),
      body: ScaffoldLayoutBuilder(
        backgroundColorAppBar:
        const ColorBuilder(Colors.transparent, Colors.white),
        textColorAppBar: const ColorBuilder(Colors.white, Colors.black),
        appBarBuilder: _appBar,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              const FirstArticle(),
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.375,
                ),
                child: const Column(
                  children: [
                    Articles(),
                    Articles(),
                    Articles(),
                    Articles(),
                    Articles(),
                    Articles(),
                    Articles(),
                    Articles(),
                  ],
                ),
              ),
            ],
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
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {},
        icon: Icon(
          EneftyIcons.search_normal_2_outline,
          color: colorAnimated.color,
        ),
      ),
    ],
  );
}

