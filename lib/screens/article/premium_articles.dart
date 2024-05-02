import 'package:diemdaochieu_app/providers/articleProvider.dart';
import 'package:diemdaochieu_app/screens/article/premium_article_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PremiumArticles extends ConsumerWidget {
  const PremiumArticles({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final data = ref.watch(premiumArticlesProvider);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        image: const DecorationImage(
          image: AssetImage("assets/images/promo.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text('BÀI VIẾT NỔI BẬT', style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.w700
                ),),
                SizedBox(width: 8),
                Badge(
                  backgroundColor: Colors.amber,
                  textColor: Colors.black87,
                  label: Text('DDC Trả Phí',),
                )
              ],
            ),
            SizedBox(
              height: 250,
              child: data.when(
                data: (data) {
                  List<dynamic> articleList = data.map((e) => e).toList();
                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: articleList.length,
                    itemBuilder: (BuildContext context, int index) => PremiumArticleCard(article: articleList[index])
                  );
                },
                error: (error, stackTrace) => Text(stackTrace.toString()),
                loading: () => const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
