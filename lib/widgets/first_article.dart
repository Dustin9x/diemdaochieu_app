import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';

class FirstArticle extends StatelessWidget {
  const FirstArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
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
                children: [
                  const SizedBox(height: 240),
                  const Text(
                    'Trung Quốc gọi lệnh trừng phạt của Mỹ “Điên Rồ”.Tổng thống Biden lên tiếng phản bác tình hình trên bằng cách triệu tập hội.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Row(
                        children: [
                          Text('7 phut'),
                          SizedBox(width: 24),
                          Icon(EneftyIcons.like_outline, size: 18.0),
                          SizedBox(width: 4),
                          Text('99'),
                          SizedBox(width: 24),
                          Icon(EneftyIcons.message_2_outline, size: 18.0),
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
                          Colors.black,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, 0.3, 0.7, 1],
                      ),
                    ),
                    child: const Image(
                      image: NetworkImage('https://i.pravatar.cc/1000'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 240,
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.bottomLeft,
                  child: const Text(
                    'Trung Quốc gọi lệnh trừng phạt của Mỹ “Điên Rồ”. Tổng thống Biden lên tiếng phản bác tình hình trên bằng cách triệu tập hội',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    style: TextStyle(
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
    );
  }
}
