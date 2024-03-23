import 'package:diemdaochieu_app/services/articleServices.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final articlesDataProvider = FutureProvider.family<dynamic,int>((ref,size) async {
  return ref.watch(articleProvider).getArticles(size);
});

final articlesByIdProvider = FutureProvider.family<dynamic, int>((ref, id) async {
  return ref.watch(articleProvider).getArticleById(id);
});

final premiumArticlesProvider = FutureProvider<List<dynamic>>((ref) async {
  return ref.watch(articleProvider).getPremiumArticles();
});