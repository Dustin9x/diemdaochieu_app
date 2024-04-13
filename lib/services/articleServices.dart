import 'dart:convert' show json, utf8;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const baseUrl = 'https://api-prod.diemdaochieu.com';
var storage = const FlutterSecureStorage();

class ArticleService {
  Future<List<dynamic>> getArticles(int size) async {
    Response response = await get(Uri.parse('$baseUrl/article/client/recent-posts?size=$size'));

    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes))['data'];
      return result.map((e) => e).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<dynamic> getArticleById(int id) async {
    var userToken = await storage.read(key: 'jwt');
    Response response;
    if(userToken != null){
      Map<String, String> requestHeaders = {
        'platform': 'ANDROID',
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': 'origin',
        'Access-Control-Allow-Credentials': 'true',
        'x-ddc-token': userToken.toString(),
      };
      response = await get(Uri.parse('$baseUrl/article/client/get-info/web/$id'),headers: requestHeaders);
    }else{
      response = await get(Uri.parse('$baseUrl/article/client/get-info/web/$id'));
    }


    if (response.statusCode == 200) {
      final result = json.decode(utf8.decode(response.bodyBytes))['data'];
      return result;
    } else {
      throw Exception(response.reasonPhrase);
    }
  }


  Future<List<dynamic>> getPremiumArticles() async {
    Response response = await get(Uri.parse('$baseUrl/article/client/highlight-posts'));

    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes))['data'];
      return result.map((e) => e).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<dynamic>> getRPIArticles(int size) async {
    Response response = await get(Uri.parse('$baseUrl/article/client/posts-by-category?id=13&page=0&size=$size'));

    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes))['data'];
      return result.map((e) => e).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<dynamic>> submitSearch(String value) async {
    var userToken = await storage.read(key: 'jwt');
    Map<String, String> requestHeaders = {
      'platform': 'ANDROID',
      'Content-Type': 'application/json',
      'X-Ddc-Token': userToken.toString(),
    };

    Response response = await get(Uri.parse('$baseUrl/client/data/search?keyword=$value&type=ALL'),headers: requestHeaders);
    if (response.statusCode == 200) {
      final List result = json.decode(utf8.decode(response.bodyBytes))['data']['articles'];
      return result.map((e) => e).toList();
    }else{
      throw Exception(response.reasonPhrase);
    }
  }


  Future<bool> likePosts(dynamic articleId) async {
    var userToken = await storage.read(key: 'jwt');
    String baseUrl = 'https://api-prod.diemdaochieu.com/article/client/like-post/$articleId';
    try {
      Map<String, String> requestHeaders = {
        'platform': 'ANDROID',
        'Content-Type': 'application/json',
        'x-ddc-token': userToken.toString(),
      };

      Response response = await post(Uri.parse(baseUrl), headers: requestHeaders);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw e.toString();
    }
    return false;
  }

}

final articleProvider = Provider<ArticleService>((ref) => ArticleService());
