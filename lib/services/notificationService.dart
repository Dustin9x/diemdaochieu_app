import 'dart:convert' show json, utf8;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const baseUrl = 'https://api-prod.diemdaochieu.com';
var storage = const FlutterSecureStorage();

class NotificationService {

  Future<List<dynamic>> getNotificationGeneral(int size) async {
    var userToken = await storage.read(key: 'jwt');
    Map<String, String> requestHeaders = {
      'platform': 'ANDROID',
      'X-Ddc-Token': userToken.toString(),
    };
    Response response = await get(
      Uri.parse('$baseUrl/notification/list?page=0&size=$size&type=GENERAL'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes))['data']
      ['pageData']['content'];
      return result.map((e) => e).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<dynamic>> getNotificationRealtime(int size) async {
    var userToken = await storage.read(key: 'jwt');
    Map<String, String> requestHeaders = {
      'platform': 'ANDROID',
      'X-Ddc-Token': userToken.toString(),
    };
    Response response = await get(
      Uri.parse('$baseUrl/notification/list?page=0&size=$size&type=REALTIME'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes))['data']
      ['pageData']['content'];
      return result.map((e) => e).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }


  Future<List<dynamic>> getNotificationBuySell(int size) async {
    var userToken = await storage.read(key: 'jwt');
    Map<String, String> requestHeaders = {
      'platform': 'ANDROID',
      'X-Ddc-Token': userToken.toString(),
    };
    Response response = await get(
      Uri.parse('$baseUrl/notification/list?page=0&size=$size&type=BUY_SALE'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes))['data']
      ['pageData']['content'];
      return result.map((e) => e).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }


  Future<List<dynamic>> getNotificationCount() async {
    var userToken = await storage.read(key: 'jwt');
    Map<String, String> requestHeaders = {
      'platform': 'ANDROID',
      'X-Ddc-Token': userToken.toString(),
    };
    Response response = await get(
      Uri.parse('$baseUrl/notification/group-by-type?'),
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes))['data'];
      return result.map((e) => e).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }


}



final notificationProvider = Provider<NotificationService>((ref) => NotificationService());

