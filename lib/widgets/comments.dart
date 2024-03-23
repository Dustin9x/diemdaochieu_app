import 'dart:convert' show json, utf8;
import 'package:diemdaochieu_app/providers/articleProvider.dart';
import 'package:diemdaochieu_app/services/articleServices.dart';
import 'package:diemdaochieu_app/widgets/my_elevated_button.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

var storage = const FlutterSecureStorage();

class Comments extends ConsumerStatefulWidget {
  const Comments({super.key, required this.articleId});

  final int articleId;

  @override
  ConsumerState<Comments> createState() {
    return _CommentState();
  }
}

class _CommentState extends ConsumerState<Comments> {
  final _formKeyComment = GlobalKey<FormState>();
  FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    // Scrollable.ensureVisible(_formKeyComment.currentContext as BuildContext);
    // RenderObject? object = _formKeyComment.currentContext?.findRenderObject();
    // object?.showOnScreen();
    Scrollable.ensureVisible(_formKeyComment.currentContext as BuildContext);
  }

  @override
  Widget build(BuildContext context) {
    int articleId = widget.articleId;

    var data;
    getData(articleId) async {
      data = await ref.watch(articleProvider).getArticleById(articleId);
    }

    String daysBetween(String cmtDate ) {
      var from = DateTime.parse(cmtDate);
      var to = DateTime.now();
      int seconds = to.difference(from).inSeconds;
      String date = DateFormat("dd-MM-yyyy").format(DateTime.parse(cmtDate),);
      String time = DateFormat("hh:mm").format(DateTime.parse(cmtDate),);

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

    var _enteredComment = '';

    void _postComment() async {
      final isValid = _formKeyComment.currentState!.validate();

      if (!isValid) {
        return;
      }
      _formKeyComment.currentState!.save();

      const baseUrl =
          'https://api-prod.diemdaochieu.com/article/client/post-comment';
      var userToken = await storage.read(key: 'jwt');
      var params = json.encode({
        "articleId": articleId,
        "comment": _enteredComment,
      });
      try {
        Map<String, String> requestHeaders = {
          'platform': 'ANDROID',
          'Content-Type': 'application/json',
          'x-ddc-token': userToken.toString(),
        };

        Response response = await post(Uri.parse(baseUrl),
            headers: requestHeaders, body: params);
        if (response.statusCode == 200) {
          setState(() {
            data = getData(articleId);
          });
          _formKeyComment.currentState!.reset();
        }
      } catch (e) {
        print(e.toString());
      }
    }

    return FutureBuilder(
        future: getData(articleId),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            getData(articleId);
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (data['listComment']['results'].length > 0)
                    ? '${data['listComment']['results'].length} bình luận'
                    : 'Hãy là người đầu tiên bình luận',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,
              ),
              Form(
                key: _formKeyComment,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.white),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                              const BorderSide(width: 1, color: Colors.white),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: "Chia sẻ ý kiến của bạn",
                        fillColor: Colors.grey.withOpacity(0.1),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      minLines: 4,
                      keyboardType: TextInputType.multiline,
                      maxLines: 8,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Bạn chưa nhập nội dung';
                        }
                        return null;
                      },
                      focusNode: _focus,
                      onTap: ()async{
                        Scrollable.ensureVisible(_formKeyComment.currentContext as BuildContext);
                      },
                      onSaved: (value) {
                        _enteredComment = value!;
                      },
                    ),
                    const SizedBox(height: 12),
                    MyElevatedButton(
                      disable: false,
                      width: 150,
                      height: 40,
                      onPressed: _postComment,
                      borderRadius: BorderRadius.circular(40),
                      child: const Text(
                        'Đăng',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = data['listComment']['results'].length-1;
                            i >= 0;
                            i--)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(data['listComment']
                                    ['results'][i]['createdBy']['imageUrl']),
                                radius: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(data['listComment']['results'][i]['createdBy']['fullName'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold
                                            ),),
                                            const SizedBox(width: 6),
                                            Text(data['listComment']['results'][i]['createdBy']['packageType'])
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(data['listComment']['results'][i]['comment']),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(daysBetween(data['listComment']['results'][i]['createdAt']),style: const TextStyle(fontSize: 11)),
                                            const SizedBox(width: 24),
                                            const Icon(EneftyIcons.like_outline, size: 15.0),
                                            const SizedBox(width: 4),
                                            Text(data['listComment']['results'][i]['likes'].toString(),style: const TextStyle(fontSize: 11)),
                                            const SizedBox(width: 24),
                                            const Icon(FluentIcons.comment_16_regular, size: 16.0),
                                            const SizedBox(width: 4),
                                            Text(data['listComment']['results'][i]['replies'].toString(),style: const TextStyle(fontSize: 11)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )

                            ]),
                          ),
                        // Text(data['listComment']['results'][i]['comment']),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
