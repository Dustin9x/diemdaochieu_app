import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstArticle extends StatelessWidget {
  const FirstArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(children: [
            const Image(
              image: NetworkImage('https://i.pravatar.cc/1000'),
              fit: BoxFit.cover,
              height: 240,
              width: double.infinity,
            ),
            Container(
              margin: const EdgeInsets.only(top: 220),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Column(
                children: [
                  const Text(
                    'Trung Quốc gọi lệnh trừng phạt của Mỹ “Điên Rồ”. Tổng thống Biden lên tiếng phản bác tình hình trên bằng cách triệu tập hội',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Row(
                        children: [
                          Text('7 phut'),
                          SizedBox(width: 24),
                          Icon(Icons.thumb_up_alt_outlined),
                          SizedBox(width: 4),
                          Text('99'),
                          SizedBox(width: 24),
                          Icon(Icons.chat_bubble_outline),
                          SizedBox(width: 4),
                          Text('99'),
                        ],
                      ),
                      Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: Text('DDC Trả phí'),
                      )
                    ],
                  )
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
