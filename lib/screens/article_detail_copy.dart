import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:appbar_animated/appbar_animated.dart';

class ArticleDetail extends StatefulWidget {
  const ArticleDetail({super.key});

  @override
  State<ArticleDetail> createState() {
    return _ArticleDetailState();
  }
}

class _ArticleDetailState extends State<ArticleDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScaffoldLayoutBuilder(
        backgroundColorAppBar:
        const ColorBuilder(Colors.transparent, Colors.white),
        textColorAppBar: const ColorBuilder(Colors.white, Colors.black),
        appBarBuilder: _appBar,
        child: SingleChildScrollView(
          child: SizedBox(
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
                          topRight: Radius.circular(20)),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black38),
                            ),
                          ),
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Chứng khoán',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue),
                              ),
                              const Text(
                                'Trung Quốc gọi lệnh trừng phạt của Mỹ “Điên Rồ”. Tổng thống Biden lên tiếng phản bác.',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    // Image border
                                    child: SizedBox.fromSize(
                                      child: Image.network(
                                        'https://i.pravatar.cc/40',
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Ga Con Lang Thang'),
                                      Row(
                                        children: [
                                          Text('7 phut'),
                                          SizedBox(width: 24),
                                          Icon(EneftyIcons.like_outline,
                                              size: 18.0),
                                          SizedBox(width: 4),
                                          Text('99'),
                                          SizedBox(width: 24),
                                          Icon(EneftyIcons.message_2_outline,
                                              size: 18.0),
                                          SizedBox(width: 4),
                                          Text('99'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius: BorderRadius.circular(50.0)),
                                    child: const Text('DDC Trả phí'),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          child: const Text(
                            'Trùm, Cớm Và Ác Quỷ kể về một kẻ giết người máu lạnh đang gây kinh hãi với hàng loạt vụ án mạng chấn động. Jang Dong-su (Ma Dong-seok), một tay trùm băng đảng lạnh lùng, tàn bạo cũng trở thành con mồi của hắn nhưng may mắn thoát chết. Cuộc vây bắt Ác Quỷ bắt đầu khi Ông Trùm bắt tay cùng Gã Cớm, nhưng mỗi bên vẫn ngấm ngầm chơi theo luật lệ của mình.'
                            '\n'
                            'Trùm, Cớm Và Ác Quỷ kể về một kẻ giết người máu lạnh đang gây kinh hãi với hàng loạt vụ án mạng chấn động. Jang Dong-su (Ma Dong-seok), một tay trùm băng đảng lạnh lùng, tàn bạo cũng trở thành con mồi của hắn nhưng may mắn thoát chết. Cuộc vây bắt Ác Quỷ bắt đầu khi Ông Trùm bắt tay cùng Gã Cớm, nhưng mỗi bên vẫn ngấm ngầm chơi theo luật lệ của mình.'
                                'Trùm, Cớm Và Ác Quỷ kể về một kẻ giết người máu lạnh đang gây kinh hãi với hàng loạt vụ án mạng chấn động. Jang Dong-su (Ma Dong-seok), một tay trùm băng đảng lạnh lùng, tàn bạo cũng trở thành con mồi của hắn nhưng may mắn thoát chết. Cuộc vây bắt Ác Quỷ bắt đầu khi Ông Trùm bắt tay cùng Gã Cớm, nhưng mỗi bên vẫn ngấm ngầm chơi theo luật lệ của mình.',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(EneftyIcons.document_text_outline),
              label: 'Tin tức',
              activeIcon: Icon(EneftyIcons.document_text_bold)),
          BottomNavigationBarItem(
            icon: Icon(EneftyIcons.user_outline),
            activeIcon: Icon(EneftyIcons.user_bold),
            label: 'Của tôi',
          ),
        ],
      ),
    );
  }
}


Widget _appBar(BuildContext context, ColorAnimated colorAnimated) {
  return AppBar(
    surfaceTintColor: Colors.white,
    backgroundColor: colorAnimated.background,
    elevation: 0,
    title: const Text('Trung Quốc gọi lệnh trừng phạt của Mỹ “Điên Rồ”. Tổng thống Biden lên tiếng phản bác.', style: TextStyle(
        fontSize: 18, fontWeight: FontWeight.w700
    ),),
    titleSpacing: 0,
  );
}
