import 'package:diemdaochieu_app/screens/article/article_detail.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:diemdaochieu_app/modal/premium_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json;
import 'package:intl/intl.dart';
import 'package:diemdaochieu_app/utils/app_utils.dart';

class Articles extends ConsumerWidget {
  const Articles({super.key, required this.article});
  final dynamic article;

  @override
  Widget build(BuildContext context,ref) {
    var storage = const FlutterSecureStorage();
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      color: Colors.white,
      elevation: 0,
      child: InkWell(
        onTap: () async {
            if(article['hasFee'] == false){
              await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ArticleDetail(articleId: article['id'])));
            }else{
              if (await storage.read(key: "user") != null){
                var userInfo = await storage.read(key: 'user');
                var userPackage = json.decode(userInfo!);
                bool isPremium = userPackage['permissions'].contains('WEB_CLIENT') || userPackage['permissions'].contains('PAID_ARTICLE') || !userPackage['packages'].contains('FREE');
                if(isPremium){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ArticleDetail(
                        articleId: article['id']
                      )));
                }
              }
              else{
                showDialog(context: context, builder: (BuildContext dialogContext){
                  return const PremiumRequestModal();
                });
              }
            }
        },

        child: SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8), // Image border
                child: SizedBox.fromSize(
                  child: Image.network(
                    article['imageUrl'],
                    width: 110,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: (article['source'] == 'DDC Trả Phí') ? Theme.of(context).colorScheme.primaryContainer : Colors.black12,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: Text(article['source'].length > 12 ? article['source'].substring(0, 12)+'...' : article['source'],  style: const TextStyle(fontSize: 11),),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(AppUtils.daysBetween(article['postedAt']),style: const TextStyle(fontSize: 12)),
                          if(article['likes'] > 0) const SizedBox(width: 18),
                          if(article['likes'] > 0) const Icon(EneftyIcons.like_outline, size: 15.0),
                          if(article['likes'] > 0) const SizedBox(width: 4),
                          if(article['likes'] > 0) Text(article['likes'].toString(),style: const TextStyle(fontSize: 11)),
                          if(article['comments'] > 0) const SizedBox(width: 18),
                          if(article['comments'] > 0) const Icon(FluentIcons.comment_16_regular, size: 16.0),
                          if(article['comments'] > 0) const SizedBox(width: 4),
                          if(article['comments'] > 0) Text(article['comments'].toString(),style: const TextStyle(fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
