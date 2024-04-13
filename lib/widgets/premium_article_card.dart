import 'package:diemdaochieu_app/modal/premium_request.dart';
import 'package:diemdaochieu_app/screens/article_detail.dart';
import 'package:diemdaochieu_app/utils/app_utils.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json;

class PremiumArticleCard extends ConsumerWidget {
  const PremiumArticleCard({
    super.key,
    required this.article,
  });

  final dynamic article;

  @override
  Widget build(BuildContext context,ref) {
    var storage = const FlutterSecureStorage();
    return Card(
      color: Colors.black87,
      child: InkWell(
        onTap: () async {
          if (await storage.read(key: "user") != null){
            var userInfo = await storage.read(key: 'user');
            var userPackage = json.decode(userInfo!);
            bool isPremium = userPackage['permissions'].contains('WEB_CLIENT') || userPackage['permissions'].contains('PAID_ARTICLE') || !userPackage['packages'].contains('FREE');
            if(isPremium){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => ArticleDetail(
                    articleId: article['id']
                  )));
            }else{
              showDialog(context: context, builder: (BuildContext dialogContext){
                return const PremiumRequestModal();
              });
            }
          }else{
            showDialog(context: context, builder: (BuildContext dialogContext){
              return const PremiumRequestModal();
            });
          }

        },
        child: SizedBox(
          width: 160.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Image border
                child: SizedBox.fromSize(
                  child: Image.network(
                    article['imageUrl'],
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article['title'],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(AppUtils.daysBetween(article['postedAt']),
                        style: const TextStyle(fontSize: 11, color: Colors.white)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if(article['likes'] > 0) const Icon(EneftyIcons.like_outline, size: 15.0, color: Colors.white),
                        if(article['likes'] > 0) const SizedBox(width: 4),
                        if(article['likes'] > 0) Text(article['likes'].toString(),style: const TextStyle(fontSize: 11, color: Colors.white)),
                        if(article['likes'] > 0) const SizedBox(width: 24),
                        if(article['comments'] > 0) const Icon(FluentIcons.comment_16_regular, size: 16.0, color: Colors.white),
                        if(article['comments'] > 0) const SizedBox(width: 4),
                        if(article['comments'] > 0) Text(article['comments'].toString(), style: const TextStyle(fontSize: 11, color: Colors.white)),
                      ],
                    )
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
