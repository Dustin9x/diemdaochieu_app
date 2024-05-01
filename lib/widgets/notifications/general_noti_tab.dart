import 'package:diemdaochieu_app/services/notificationService.dart';
import 'package:diemdaochieu_app/utils/app_utils.dart';
import 'package:diemdaochieu_app/widgets/notifications/notification_item.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, utf8;

class GeneralNoti extends ConsumerStatefulWidget {
  const GeneralNoti({super.key});

  @override
  ConsumerState<GeneralNoti> createState() => _GeneralNotiState();
}

class _GeneralNotiState extends ConsumerState<GeneralNoti> {
  static const _pageSize = 35;
  var _activeCallbackIdentity;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 35);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    getUserInfo();
  }

  bool isPremium = false;

  void getUserInfo() async{
    if (await storage.read(key: "user") != null){
      var userInfo = await storage.read(key: 'user');
      var userPackage = json.decode(userInfo!);
      setState(() {
        isPremium = userPackage['permissions'].contains('WEB_CLIENT') || userPackage['permissions'].contains('PAID_ARTICLE') || !userPackage['packages'].contains('FREE');
      });
    }
  }

  Future<void> _fetchPage(int pageKey) async {
    final callbackIdentity = Object();
    _activeCallbackIdentity = callbackIdentity;
    var userToken = await storage.read(key: 'jwt');
    Map<String, String> requestHeaders = {
      'platform': 'ANDROID',
      'X-Ddc-Token': userToken.toString(),
    };
    try {
      final newItems = await http.get(Uri.parse(
          'https://api-prod.diemdaochieu.com/notification/list?size=$pageKey&type=GENERAL'),headers: requestHeaders);
      if (callbackIdentity == _activeCallbackIdentity) {
        pageKey = pageKey + _pageSize;
        final result = json.decode(utf8.decode(newItems.bodyBytes))['data']['pageData']['content'];
        final data = result.sublist(result.length - _pageSize);
        final finalData = deleteDate(data);
        _pagingController.appendPage(finalData, pageKey);
      }
    } catch (error) {
      if (callbackIdentity == _activeCallbackIdentity) {
        _pagingController.error = error;
      }
    }
  }

  deleteDate(List<dynamic> items) {
    String date = items[0]['pushFinishAt'];
    for(int i = 1; i <items.length; i++){
      if(items[i]['pushFinishAt'] == date){
        items[i]['pushFinishAt'] = '';
      }else{
        date = items[i]['pushFinishAt'];
      }
    }
    return items;
  }

  groupByDay(List<dynamic> items) {
    final Map<String, List<dynamic>> resultMap = {};
    for (var item in items) {
      final date = item['pushFinishAt'];
      if (!resultMap.containsKey(date)) {
        resultMap[date] = [];
      }
      resultMap[date]!.add(item);
    }
    return resultMap;
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _activeCallbackIdentity = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return RefreshIndicator(
        onRefresh: () => Future.sync(
              () => _pagingController.refresh(),
            ),
        child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child:  PagedListView<int, dynamic>(
                padding: EdgeInsets.zero,
                pagingController: _pagingController,
                builderDelegate:  PagedChildBuilderDelegate<dynamic>(
                  itemBuilder: (context, item, index) {
                    return Column(
                      children: [
                        if(item['pushFinishAt'] != '') const SizedBox(height: 4),
                        if(item['pushFinishAt'] != '') AppUtils.dateNoti(item['pushFinishAt'], isPremium),
                        Notifications(notification: item),
                      ],
                    );
                  },
                ),
              ),
            ));
  }
}
