import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:diemdaochieu_app/modal/login_request.dart';
import 'package:diemdaochieu_app/services/articleServices.dart';
import 'package:diemdaochieu_app/utils/app_utils.dart';
import 'package:diemdaochieu_app/widgets/comments.dart';
import 'package:http/http.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

var storage = const FlutterSecureStorage();

class ArticleDetail extends ConsumerStatefulWidget {
  const ArticleDetail({super.key, required this.articleId});

  final dynamic articleId;

  @override
  ConsumerState<ArticleDetail> createState() {
    return _ArticleDetailState();
  }
}

class _ArticleDetailState extends ConsumerState<ArticleDetail> {
  final commentKey = new GlobalKey();
  final _scrollController = ScrollController();
  static const _kBasePadding = 16.0;
  static const kExpandedHeight = 240.0;
  var articleDetail;

  final ValueNotifier<double> _titlePaddingNotifier =
      ValueNotifier(_kBasePadding);


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

  Future<dynamic> getData(articleId) async {
    return ref.watch(articleProvider).getArticleById(articleId);
  }

  late int initLike;

  _likePosts() async {
    var userToken = await storage.read(key: 'jwt');
    if (userToken == null) {
      showDialog(context: context,
          builder: (BuildContext dialogContext) {
            return const LoginRequestModal();
          });
      return;
    }

    String baseUrl = 'https://api-prod.diemdaochieu.com/article/client/like-post/${widget.articleId}';

    try {
      Map<String, String> requestHeaders = {
        'platform': 'ANDROID',
        'Content-Type': 'application/json',
        'x-ddc-token': userToken.toString(),
      };

      Response response = await post(Uri.parse(baseUrl), headers: requestHeaders);
      if (response.statusCode == 200) {
        setState(() {
          // initLike++;
          // data = ref.watch(articlesByIdProvider(widget.articleId));
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  double initFontSize = 17.0;
  int _selectFontIndex = 1;

  void _selectFontSize(int index) async {
    if (index == 0) {
      setState(() {
        _selectFontIndex = index;
        initFontSize = 13.0;
      });
    }
    if (index == 1) {
      setState(() {
        _selectFontIndex = index;
        initFontSize = 17.0;
      });
    }
    if (index == 2) {
      setState(() {
        _selectFontIndex = index;
        initFontSize = 22.0;
      });
    }
    Navigator.pop(context);
  }

  _launchURL(String inputUrl) async {
    if (await canLaunchUrl(Uri.parse(inputUrl))) {
      await launchUrl(Uri.parse(inputUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });

    return Scaffold(
      body: FutureBuilder(
        future: getData(widget.articleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            getData(widget.articleId);
          }
          articleDetail = snapshot.data;
          initLike = articleDetail['likes'];

          return Scaffold(
            resizeToAvoidBottomInset: true,
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
                          titlePadding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 0),
                          title: ValueListenableBuilder(
                            valueListenable: _titlePaddingNotifier,
                            builder: (context, value, child) {
                              return Padding(
                                padding: EdgeInsets.only(left: value * 0.8),
                                child: Text(
                                  articleDetail['title'],
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
                                    shadows: _scrollController.hasClients &&
                                            _scrollController.offset <
                                                (240 - kToolbarHeight)
                                        ? const <Shadow>[
                                            Shadow(
                                              offset: Offset(0.0, 1.0),
                                              blurRadius: 2.0,
                                              color: Colors.black45,
                                            ),
                                          ]
                                        : null,
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
                              child: Image(
                                image: NetworkImage(articleDetail['imageUrl']),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )),
                  ];
                },
                body: SingleChildScrollView(
                  reverse: false,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            Row(
                              children: [
                                Text(
                                  articleDetail['categories'][0]['name'],
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.blue),
                                ),
                                const Spacer(),
                                if (articleDetail['hasFee'])
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                        borderRadius:
                                            BorderRadius.circular(50.0)),
                                    child: const Text('DDC Trả phí'),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  // Image border
                                  child: SizedBox.fromSize(
                                    child: Image.network(
                                      articleDetail['createdBy']['imageUrl'] ??
                                          'https://i.pravatar.cc/100',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        articleDetail['createdBy']['fullName']),
                                    Row(
                                      children: [
                                        Text(AppUtils.daysBetween(articleDetail['postedAt'])),
                                        const SizedBox(width: 24),
                                        const Icon(EneftyIcons.like_outline,
                                            size: 18.0),
                                        const SizedBox(width: 4),
                                        Text(initLike.toString()),
                                        const SizedBox(width: 24),
                                        const Icon(
                                            EneftyIcons.message_2_outline,
                                            size: 18.0),
                                        const SizedBox(width: 4),
                                        Text(articleDetail['comments']
                                            .toString()),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Html(
                        data: articleDetail['content'],
                        extensions: [
                          OnImageTapExtension(
                            onImageTap: (src, imgAttributes, element) {
                              if (src!.startsWith("data:image") && src.contains('base64,')) {
                                showImageViewer(context,
                                    MemoryImage(base64.decode(src!.split(',').last)),
                                    swipeDismissible: true,
                                    doubleTapZoomable: true);
                              }else{
                                showImageViewer(context,
                                    NetworkImage(src),
                                    swipeDismissible: true,
                                    doubleTapZoomable: true);
                              }
                            },
                          ),
                          TagExtension(
                            tagsToExtend: {"table"},
                            builder: (ctx) => Html(data: ctx.innerHtml),
                          ),
                          ImageExtension(
                            builder: (p0) {
                              var mainString = p0.attributes['src'].toString();
                              if (mainString.startsWith("data:image") && mainString.contains('base64,')) {
                                Uint8List _bytes =
                                    base64.decode(mainString.split(',').last);
                                return Image.memory(
                                    width: double.infinity, _bytes);
                              } else {
                                // return Text(mainString);
                                return Image.network(mainString);
                              }
                            },
                          ),
                        ],
                        // onLinkTap: (url, _, __) {
                        //   _launchURL(url.toString());
                        // },
                        style: {
                          "h1": Style(
                            fontSize: FontSize(initFontSize + 8),
                          ),
                          "h2": Style(
                            fontSize: FontSize(initFontSize + 4),
                          ),
                          "p": Style(
                            fontSize: FontSize(initFontSize),
                          ),
                          "span": Style(
                            fontSize: FontSize(initFontSize),
                          ),

                          "p > a": Style(
                            textDecoration: TextDecoration.none,
                          ),
                        },
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Comments(
                              key: commentKey, articleId: widget.articleId)),
                    ],
                  ),
                )),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, spreadRadius: 0, blurRadius: 10),
                ],
              ),
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
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
                            icon: articleDetail['userLiked']
                                ? const Icon(EneftyIcons.like_bold,
                                    color: Colors.amber, size: 22)
                                : const Icon(
                                    EneftyIcons.like_outline,
                                    size: 22,
                                  ),
                            onPressed: _likePosts
                        ),
                        IconButton(
                            icon: const Icon(FluentIcons.comment_16_regular),
                            onPressed: () {
                              Scrollable.ensureVisible(
                                  commentKey.currentContext as BuildContext);
                            }),
                        IconButton(
                            icon: const Icon(FluentIcons.bookmark_16_regular),
                            onPressed: () {}),
                        IconButton(
                            icon: const Icon(
                                FluentIcons.text_font_size_16_regular),
                            onPressed: () {
                              showModalBottomSheet<void>(
                                context: context,
                                elevation: 0,
                                backgroundColor: Colors.white,
                                barrierColor: Colors.black.withAlpha(1),
                                builder: (BuildContext context) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          topLeft: Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: 0,
                                            blurRadius: 10),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20.0),
                                        topRight: Radius.circular(20.0),
                                      ),
                                      child: BottomNavigationBar(
                                        elevation: 0,
                                        showSelectedLabels: false,
                                        showUnselectedLabels: false,
                                        backgroundColor: Colors.white,
                                        onTap: _selectFontSize,
                                        currentIndex: _selectFontIndex,
                                        fixedColor: Colors.amber,
                                        items: const [
                                          BottomNavigationBarItem(
                                              icon: Icon(
                                                  FluentIcons
                                                      .text_font_size_20_filled,
                                                  size: 18),
                                              label: '',
                                              activeIcon: ClipOval(
                                                child: Material(
                                                  color: Colors.amber,
                                                  // Button color
                                                  child: SizedBox(
                                                      width: 35,
                                                      height: 35,
                                                      child: Icon(
                                                          FluentIcons
                                                              .text_font_size_20_filled,
                                                          size: 18,
                                                          color: Colors.white)),
                                                ),
                                              )),
                                          BottomNavigationBarItem(
                                              icon: Icon(
                                                  FluentIcons
                                                      .text_font_size_20_filled,
                                                  size: 26),
                                              label: '',
                                              activeIcon: ClipOval(
                                                child: Material(
                                                  color: Colors.amber,
                                                  // Button color
                                                  child: SizedBox(
                                                      width: 35,
                                                      height: 35,
                                                      child: Icon(
                                                          FluentIcons
                                                              .text_font_size_20_filled,
                                                          size: 26,
                                                          color: Colors.white)),
                                                ),
                                              )),
                                          BottomNavigationBarItem(
                                              icon: Icon(
                                                  FluentIcons
                                                      .text_font_size_20_filled,
                                                  size: 32),
                                              label: '',
                                              activeIcon: ClipOval(
                                                child: Material(
                                                  color: Colors.amber,
                                                  // Button color
                                                  child: SizedBox(
                                                      width: 35,
                                                      height: 35,
                                                      child: Icon(
                                                          FluentIcons
                                                              .text_font_size_20_filled,
                                                          size: 32,
                                                          color: Colors.white)),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                        IconButton(
                            icon: const Icon(
                                FluentIcons.share_android_16_regular),
                            onPressed: () {
                              Share.share(articleDetail['articleLink'],
                                  subject: 'Look what I made!');
                            }),
                      ],
                    ),
                  )),
            ),
          );
        },
      ),
    );
  }
}

