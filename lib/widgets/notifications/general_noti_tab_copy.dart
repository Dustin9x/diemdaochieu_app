import 'package:diemdaochieu_app/services/notificationService.dart';
import 'package:diemdaochieu_app/widgets/notifications/notification_item.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class GeneralNoti extends ConsumerWidget {
  const GeneralNoti({super.key});

  @override
  Widget build(BuildContext context, ref) {
    int size = 25;
    var data;
    getData(size) async {
      data = await ref.watch(notificationProvider).getNotificationGeneral(size);
    }

    Future<void> onRefresh() {
      return ref.refresh(notificationProvider).getNotificationGeneral(size);
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

    return FutureBuilder(
        future: getData(size),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          List<dynamic> notiList = data.map((e) => e).toList();
          final finalData = groupByDay(notiList);
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: finalData.entries.map((entry) {
                          String date = DateFormat("dd-MM-yyyy").format(
                            DateTime.parse(entry.key),
                          );
                          final value = entry.value;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  const Icon(FluentIcons.circle_12_filled,
                                      color: Colors.orangeAccent, size: 8),
                                  Text(
                                    " $date",
                                    style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              for (int i = 0; i < value.length; i++)
                                Notifications(notification: value[i]),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          );
                        }).toList()),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
