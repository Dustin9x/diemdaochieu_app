import 'dart:math';

import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:share_plus/share_plus.dart';

class ArticleDetail extends StatefulWidget {
  const ArticleDetail({super.key});

  @override
  State<ArticleDetail> createState() {
    return _ArticleDetailState();
  }
}

class _ArticleDetailState extends State<ArticleDetail> {
  static const _kBasePadding = 16.0;
  static const kExpandedHeight = 240.0;

  final ValueNotifier<double> _titlePaddingNotifier =
      ValueNotifier(_kBasePadding);

  final _scrollController = ScrollController();

  double get _horizontalTitlePadding {
    const kCollapsedPadding = 60.0;

    if (_scrollController.hasClients) {
      return min(
          _kBasePadding + kCollapsedPadding,
          _kBasePadding +
              (kCollapsedPadding * _scrollController.offset) /
                  (kExpandedHeight - kToolbarHeight));
    }

    return _kBasePadding;
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });

    return Scaffold(
      body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                  expandedHeight: kExpandedHeight,
                  floating: false,
                  pinned: true,
                  surfaceTintColor: Colors.white,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.pin,
                    centerTitle: false,
                    titlePadding:
                        const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
                    title: ValueListenableBuilder(
                      valueListenable: _titlePaddingNotifier,
                      builder: (context, value, child) {
                        return Padding(
                          padding:
                              EdgeInsets.only(left: value * 0.8),
                          child: Text(
                            "Trung Quốc gọi lệnh trừng phạt của Mỹ “Điên Rồ”. Tổng thống Biden lên tiếng phản bác.",
                            maxLines: _scrollController.hasClients &&
                                    _scrollController.offset <
                                        (240 - kToolbarHeight)
                                ? null
                                : 1,
                            overflow: _scrollController.hasClients &&
                                    _scrollController.offset <
                                        (240 - kToolbarHeight)
                                ? null
                                : TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: _scrollController.hasClients &&
                                      _scrollController.offset <
                                          (240 - kToolbarHeight)
                                  ? 14
                                  : 18,
                              fontWeight: FontWeight.w700,
                              color: _scrollController.hasClients &&
                                      _scrollController.offset <
                                          (240 - kToolbarHeight)
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                    background: ClipRRect(
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
                              Colors.black54
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0, 0.0, 0.7, 1],
                          ),
                        ),
                        child: const Image(
                          image: NetworkImage('https://i.pravatar.cc/1000'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )),
            ];
          },
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
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
                                  Icon(EneftyIcons.like_outline, size: 18.0),
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomAppBar(
            color: Colors.white,
            elevation: 0,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: const Icon(
                      EneftyIcons.like_outline,
                      size: 22,
                    ),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(FluentIcons.comment_16_regular),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(FluentIcons.bookmark_16_regular),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(FluentIcons.text_font_size_16_regular),
                    onPressed: () {}),
                IconButton(
                    icon: const Icon(FluentIcons.share_android_16_regular),
                    onPressed: () {
                      Share.share('check out my website https://example.com',
                          subject: 'Look what I made!');
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
