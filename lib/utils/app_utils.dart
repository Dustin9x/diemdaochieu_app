import 'dart:math' as math;
import 'package:intl/intl.dart';

// import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  factory AppUtils() {
    return _singleton;
  }

  AppUtils._internal();
  static final AppUtils _singleton = AppUtils._internal();

  double degreeToRadian(double degree) {
    return degree * math.pi / 180;
  }

  double radianToDegree(double radian) {
    return radian * 180 / math.pi;
  }

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

  // Future<bool> tryToLaunchUrl(String url) async {
  //   final uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     return await launchUrl(uri);
  //   }
  //   return false;
  // }
}