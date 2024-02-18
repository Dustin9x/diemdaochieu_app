import 'package:diemdaochieu_app/widgets/articles.dart';
import 'package:diemdaochieu_app/widgets/first_article.dart';
import 'package:flutter/material.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  bool isTop = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          title: isTop ? const Text(
            'ĐIỂM ĐẢO CHIỀU',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 24,
            ),
          ) : const Text(
            'ĐIỂM ĐẢO CHIỀU',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          actions: [
            isTop ? IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
              color: Colors.white,
            ) : IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
              color: Colors.black,
            )
          ],
          backgroundColor: isTop ? Colors.transparent : Colors.white,
          flexibleSpace: isTop ?  Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 0, 0, 0),
                  Colors.transparent,
                ],
              ),
            ) ,
          ) : null,
        ),
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            final metrices = notification.metrics;
            if (metrices.atEdge && metrices.pixels == 0) {
              print('you are top');
              setState(() {
                isTop = true;
              });
            }
            else{
              setState(() {
                isTop = false;
              });
            }
            return true;
          },
          child: SingleChildScrollView(
            child: Container(
              color: const Color.fromARGB(20, 0, 0, 0),
              child: Column(
                children: [
                  FirstArticle(),
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
          ),
        ));
  }
}
