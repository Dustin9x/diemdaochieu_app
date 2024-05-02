import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart';
import 'dart:typed_data';
import 'package:diemdaochieu_app/modal/login_request.dart';
import 'package:diemdaochieu_app/services/articleServices.dart';
import 'package:diemdaochieu_app/utils/app_utils.dart';
import 'package:diemdaochieu_app/widgets/comments.dart';
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
  late var articleDetail = {};
  late int initLike;
  late bool userLiked;
  bool _isLoading = true;
  int activeNavBar = 0;
  int _selectFontIndex = 1;
  double initFontSize = 17.0;

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

  _likePosts() async {
    var userToken = await storage.read(key: 'jwt');
    if (userToken == null) {
      showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return const LoginRequestModal();
          });
      return;
    }
    var liked = ref.watch(articleProvider).likePosts(widget.articleId);
    if (userLiked == false) {
      setState(() {
        initLike++;
        userLiked = true;
      });
    } else {
      setState(() {
        initLike--;
        userLiked = false;
      });
    }
  }

  String convertSrc(String text){
    String finalSrc = '';
    final urlRegExp = new RegExp(
        r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    final urlMatches = urlRegExp.allMatches(text);
    List<String> urls = urlMatches.map(
            (urlMatch) => text.substring(urlMatch.start, urlMatch.end))
        .toList();
    if(urls.isNotEmpty){
      finalSrc = urls[0];
    }
    return finalSrc;
  }

  Future<void> fetchArticle(int id) async {
    var userToken = await storage.read(key: 'jwt');
    Response response;
    if (userToken != null) {
      Map<String, String> requestHeaders = {
        'platform': Platform.operatingSystem.toUpperCase(),
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': 'origin',
        'Access-Control-Allow-Credentials': 'true',
        'x-ddc-token': userToken.toString(),
      };
      response = await get(
          Uri.parse('$baseUrl/article/client/get-info/web/$id'),
          headers: requestHeaders);
    } else {
      response =
          await get(Uri.parse('$baseUrl/article/client/get-info/web/$id'));
    }
    if (response.statusCode == 200) {
      setState(() {
        articleDetail = json.decode(utf8.decode(response.bodyBytes))['data'];
        initLike = articleDetail['likes'];
        userLiked = articleDetail['userLiked'];
        _isLoading = false;
      });
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<void> getFontSize() async {
    var index = await storage.read(key: "selectFontIndex");
    if(index == null || index == '') return;
    _selectFontIndex = int.tryParse(index)!;
    switch (index) {
      case '0':
        initFontSize = 13;
        break;
      case '1':
        initFontSize = 17;
        break;
      case '2':
        initFontSize = 22;
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFontSize();
    fetchArticle(widget.articleId);
  }

  @override
  Widget build(BuildContext context) {
    _scrollController.addListener(() {
      _titlePaddingNotifier.value = _horizontalTitlePadding;
    });

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : NestedScrollView(
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
                                  Colors.black87
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0, 0.0, 0.4, 1],
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
                              Text(articleDetail['categories'].length == 0 ? "" : articleDetail['categories'][0]['name'],
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
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(articleDetail['createdBy']['fullName']),
                                  Row(
                                    children: [
                                      Text(AppUtils.daysBetween(articleDetail['postedAt'])),
                                      const SizedBox(width: 24),
                                      const Icon(EneftyIcons.like_outline,
                                          size: 18.0),
                                      const SizedBox(width: 4),
                                      Text(initLike.toString()),
                                      const SizedBox(width: 24),
                                      const Icon(EneftyIcons.message_2_outline,
                                          size: 18.0),
                                      const SizedBox(width: 4),
                                      Text(articleDetail['comments'].toString()),
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
                      shrinkWrap: true,
                      extensions: [
                        OnImageTapExtension(
                          onImageTap: (src, imgAttributes, element) {
                            if (src!.startsWith("data:image") &&
                                src.contains('base64,')) {
                              showImageViewer(
                                  context,
                                  MemoryImage(
                                      base64.decode(src.split(',').last)),
                                  swipeDismissible: true,
                                  doubleTapZoomable: true);
                            } else {
                              showImageViewer(context, NetworkImage(src),
                                  swipeDismissible: true,
                                  doubleTapZoomable: true);
                            }
                          },
                        ),
                        TagExtension(
                            tagsToExtend: {"table"},
                            builder: (child) {
                              return SizedBox(
                                width: double.infinity,
                                child: convertSrc(child.innerHtml.toString()) != ''
                                    ? InkWell(
                                        child: Image.network(convertSrc(child.innerHtml.toString())),
                                        onTap: (){
                                          showImageViewer(context, NetworkImage(
                                              convertSrc(child.innerHtml.toString())),
                                                              swipeDismissible: true,
                                                              doubleTapZoomable: true);
                                        },
                                      )
                                    : null,
                              );
                            }),
                        ImageExtension(
                          builder: (p0) {
                            var mainString = p0.attributes['src'].toString();
                            if (mainString.startsWith("data:image") &&
                                mainString.contains('base64,')) {
                              Uint8List _bytes =
                                  base64.decode(mainString.split(',').last);
                              return Image.memory(
                                  width: double.infinity, _bytes);
                            } else {
                              return Image.network(mainString);
                            }
                          },
                        ),
                      ],
                      onLinkTap: (url, _, __) async {
                        if (await canLaunchUrl(Uri.parse(url!))) {
                          if(url.contains("diemdaochieu.com")){
                            var lastItem = url.split("/").last;
                            int? ddcArticleId = int.tryParse(lastItem);
                            Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => ArticleDetail(articleId: ddcArticleId)));
                          }else{
                            await launchUrl(
                              Uri.parse(url),
                            );
                          }
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      style: {
                        "h1 > *": Style(
                          fontSize: FontSize(initFontSize + 8),
                        ),
                        "h2 > *": Style(
                          fontSize: FontSize(initFontSize + 4),
                        ),
                        "p > *": Style(
                          fontSize: FontSize(initFontSize),
                        ),
                        "h1": Style(
                          fontSize: FontSize(initFontSize + 8),
                        ),
                        "h2": Style(
                          fontSize: FontSize(initFontSize + 4),
                        ),
                        "p": Style(
                          fontSize: FontSize(initFontSize),
                        ),
                        "p span": Style(
                          fontSize: FontSize(initFontSize),
                        ),
                        "div": Style(
                          fontSize: FontSize(initFontSize),
                        ),
                        "a": Style(
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
      bottomNavigationBar: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
                  child: activeNavBar == 0
                      ? BottomAppBar(
                    color: Colors.white,
                    elevation: 0,
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: userLiked == true
                                ? const Icon(EneftyIcons.like_bold,
                                    color: Colors.amber, size: 22)
                                : const Icon(
                                    EneftyIcons.like_outline,
                                    size: 22,
                                  ),
                            onPressed: _likePosts),
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
                              setState(() {
                                activeNavBar = 1;
                              });
                            }),
                        IconButton(
                            icon: const Icon(
                                FluentIcons.share_android_16_regular),
                            onPressed: () {
                              Share.share(articleDetail['articleLink'],
                                  subject: articleDetail['title']);
                            }),
                      ],
                    ),
                  )
                      : BottomAppBar(
                    color: Colors.white,
                    elevation: 0,
                    height: 60,
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            icon: const Icon(FluentIcons.chevron_left_28_regular),
                            onPressed: () {
                              setState(() {
                                activeNavBar = 0;
                              });
                            },
                        ),
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 2),
                              IconButton(
                                  icon: _selectFontIndex == 0 ? const ClipOval(
                                    child: Material(
                                      color: Colors.amber,
                                      child: SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: Icon(
                                              FluentIcons.text_font_size_20_filled,
                                              size: 18,
                                              color: Colors.white)),
                                    ),
                                  ) : const Icon(FluentIcons.text_font_size_20_filled, size: 18),
                                  onPressed: () async {
                                    setState(() {
                                      _selectFontIndex = 0;
                                      initFontSize = 13.0;
                                    });
                                    await storage.write(key: 'selectFontIndex', value: "0");
                                  }),
                              IconButton(
                                  icon: _selectFontIndex == 1 ? const ClipOval(
                                    child: Material(
                                      color: Colors.amber,
                                      child: SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: Icon(
                                              FluentIcons.text_font_size_20_filled,
                                              size: 26,
                                              color: Colors.white)),
                                    ),
                                  ) : const Icon(FluentIcons.text_font_size_20_filled, size: 26),
                                  onPressed: () async {
                                    setState(() {
                                      _selectFontIndex = 1;
                                      initFontSize = 17.0;
                                    });
                                    await storage.write(key: 'selectFontIndex', value: "1");
                                  }),
                              IconButton(
                                  icon: _selectFontIndex == 2 ? const ClipOval(
                                    child: Material(
                                      color: Colors.amber,
                                      child: SizedBox(
                                          width: 35,
                                          height: 35,
                                          child: Icon(
                                              FluentIcons.text_font_size_20_filled,
                                              size: 32,
                                              color: Colors.white)),
                                    ),
                                  ) : const Icon(FluentIcons.text_font_size_20_filled, size: 32),
                                  selectedIcon: const Icon(FluentIcons.text_font_size_20_filled, size: 48),
                                  onPressed: () async {
                                    setState(() {
                                      _selectFontIndex = 2;
                                      initFontSize = 22.0;
                                    });
                                    await storage.write(key: 'selectFontIndex', value: "2");
                                  }),
                              const SizedBox(width: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ),
    );
  }
}
