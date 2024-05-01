import 'package:diemdaochieu_app/screens/article_detail.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key, required this.notification});

  final dynamic notification;

  Widget renderNoti(notification){
    if(notification['type'] != 'GENERAL' || notification['target'] != 'ALL') {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(notification['title'],
              style: const TextStyle(fontWeight: FontWeight.bold)),
          if (notification['type'] != 'GENERAL')
            const SizedBox(width: 8),
          Flexible(
            child: Text(
              notification['content'],
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 2,
            ),
          ),
        ],
      );
    }
    return Text(
      notification['title'],
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      maxLines: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: double.infinity,
      child: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: Colors.grey.withOpacity(0.2),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
        onPressed: () {
          if(notification['type'] != 'GENERAL') return;
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => ArticleDetail(
                articleId: int.tryParse(
                    notification['articleId']),
              )));
        },
        child: renderNoti(notification)
      ),
    );
  }
}
