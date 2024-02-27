import 'package:diemdaochieu_app/screens/article_detail.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';

class Articles extends StatelessWidget {
  const Articles({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      color: Colors.white,
      elevation: 0,
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const ArticleDetail()));
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
                    'https://i.pravatar.cc/100',
                    width: 120,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nỗi lo tiền bạc khi Công chúa Nhật lấy thường dân Nỗi lo tiền bạc khi Công chúa Nhật lấy thường dân',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color:
                            Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: const Text('DDC Trả phí', style: TextStyle(fontSize: 11),),
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        children: [
                          Text('7 phut',style: TextStyle(fontSize: 11)),
                          SizedBox(width: 24),
                          Icon(EneftyIcons.like_outline, size: 15.0),
                          SizedBox(width: 4),
                          Text('99',style: TextStyle(fontSize: 11)),
                          SizedBox(width: 24),
                          Icon(FluentIcons.comment_16_regular, size: 16.0),
                          SizedBox(width: 4),
                          Text('99',style: TextStyle(fontSize: 11)),
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
