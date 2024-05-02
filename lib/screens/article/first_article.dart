import 'package:diemdaochieu_app/utils/app_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diemdaochieu_app/screens/article/article_detail.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';

class FirstArticle extends ConsumerWidget {
  const FirstArticle({
    super.key,
    required this.article,
  });

  final dynamic article;

  @override
  Widget build(BuildContext context, ref) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: InkWell(
        onTap: () async{
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ArticleDetail(articleId: article['id'])));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 250),
                    Text(
                      article['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Row(
                          children: [
                            Text(AppUtils.daysBetween(article['postedAt'])),
                            if(article['likes'] > 0) const SizedBox(width: 24),
                            if(article['likes'] > 0) const Icon(EneftyIcons.like_outline, size: 18.0),
                            if(article['likes'] > 0) const SizedBox(width: 4),
                            if(article['likes'] > 0) Text(article['likes'].toString()),
                            if(article['comments'] > 0) const SizedBox(width: 24),
                            if(article['comments'] > 0) const Icon(FluentIcons.comment_16_regular, size: 18.0),
                            if(article['comments'] > 0) const SizedBox(width: 4),
                            if(article['comments'] > 0) Text(article['comments'].toString()),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: (article['source'] == 'DDC Trả Phí') ? Theme.of(context).colorScheme.primaryContainer : Colors.black12,
                              borderRadius: BorderRadius.circular(50.0)),
                          child: Text(article['source'].length > 12 ? article['source'].substring(0, 12)+'...' : article['source'],),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    child: Container(
                      height: 250,
                      width: double.infinity,
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black54,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black87
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 0.3, 0.6, 1],
                        ),
                      ),
                      child: Image(
                        image: NetworkImage(article['imageUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 250,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      article['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
