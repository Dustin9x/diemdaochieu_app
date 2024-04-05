import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:diemdaochieu_app/screens/article_detail.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';

class FirstArticle extends ConsumerWidget {
  const FirstArticle({
    super.key,
    required this.article,
  });

  final dynamic article;

  String daysBetween() {
    var from = DateTime.parse(article['postedAt']);
    var to = DateTime.now();
    int seconds = to.difference(from).inSeconds;
    String date = DateFormat("dd-MM-yyyy").format(DateTime.parse(article['postedAt']),);
    String time = DateFormat("hh:mm").format(DateTime.parse(article['postedAt']),);

    if (seconds >= 24 * 3600) {
      return '$date lúc $time';
    }

    int interval = (seconds / 3600).floor();
    if (interval >= 1) {
      return 'Khoảng $interval tiếng';
    }

    interval = (seconds / 60).floor();
    if (interval >= 1) {
      return '$interval phút';
    }

    return '${(seconds).floor()} giây';
  }

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
                    const SizedBox(height: 240),
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
                            Text(daysBetween()),
                            const SizedBox(width: 24),
                            const Icon(EneftyIcons.like_outline, size: 18.0),
                            const SizedBox(width: 4),
                            Text(article['likes'].toString()),
                            const SizedBox(width: 24),
                            const Icon(FluentIcons.comment_16_regular, size: 18.0),
                            const SizedBox(width: 4),
                            Text(article['comments'].toString()),
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
                      height: 240,
                      width: double.infinity,
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black54,
                            Colors.transparent,
                            Colors.transparent,
                            Colors.black54
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 0.3, 0.7, 1],
                        ),
                      ),
                      child: Image(
                        image: NetworkImage(article['imageUrl']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 240,
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      article['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
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
