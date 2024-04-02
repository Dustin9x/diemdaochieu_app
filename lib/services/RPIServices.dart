import 'dart:convert' show json, utf8;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const baseUrl = 'https://api-prod.diemdaochieu.com';
var storage = const FlutterSecureStorage();

class RPIService {
  Future<dynamic> getRPI() async {
    Response response = await get(Uri.parse('$baseUrl/api/v1/file/data/static'));

    if (response.statusCode == 200) {
      final result = json.decode(utf8.decode(response.bodyBytes))['data'];
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<dynamic> getRPIHisroty(String from, String to) async {
    Response response = await get(Uri.parse('$baseUrl/api/v1/file/data/history-data?from=$from&to=$to'));

    if (response.statusCode == 200) {
      final result = json.decode(utf8.decode(response.bodyBytes))['data'];
      return result.map((e) => e).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<dynamic> getVN30RPIHisroty(String selectedDate) async {
    Response response = await get(Uri.parse('$baseUrl/api/v1/data/money-flow-vn30s?date=$selectedDate'));

    if (response.statusCode == 200) {
      final result = json.decode(utf8.decode(response.bodyBytes))['data'];
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

}

final rpiProvider = Provider<RPIService>((ref) => RPIService());
