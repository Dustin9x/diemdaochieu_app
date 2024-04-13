import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class AppUtils {
  factory AppUtils() {
    return _singleton;
  }

  static var storage = const FlutterSecureStorage();

  AppUtils._internal();
  static final AppUtils _singleton = AppUtils._internal();

  static String daysBetween(String postedAt) {
    var from = DateTime.parse(postedAt);
    var to = DateTime.now();
    int seconds = to.difference(from).inSeconds;
    String date = DateFormat("dd-MM-yyyy").format(from);
    String time = DateFormat("hh:mm").format(from);

    if (seconds >= 24 * 3600)  return '$date lúc $time';
    int interval = (seconds / 3600).floor();
    if (interval >= 1)  return 'Khoảng $interval tiếng';
    interval = (seconds / 60).floor();
    if (interval >= 1) return '$interval phút';

    return '${(seconds).floor()} giây';
  }


  static Future<bool> checkLoginState() async {
    var userToken = await storage.read(key: 'jwt');
    const baseUrl = 'https://api-prod.diemdaochieu.com/user/get-info';
    Map<String, String> requestHeaders = {
      'platform': 'ANDROID',
      'Content-Type': 'application/json',
      'x-ddc-token': userToken.toString(),
    };
    Response response = await get(Uri.parse(baseUrl),headers: requestHeaders);
    if (response.statusCode == 200) {
      return true;
    } else {
      await storage.deleteAll();
      return false;
    }
  }


  static Color colorPackage(String type){
    switch(type){
      case 'PREMIUM':
        return Colors.green;
      case 'GOLD':
        return Colors.amber;
      case 'FUND':
        return Colors.deepPurple;
    }
    return Colors.grey.withOpacity(0.3);
  }

  static String notiBadge(int count){
    return count > 99 ? '99+' : count.toString();
  }
}