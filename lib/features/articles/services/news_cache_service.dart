import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/utils/categories.dart';

final newsCacheServiceProvider = Provider<NewsCacheService>((ref) {
  return NewsCacheService();
});

class NewsCacheService {
  static const boxName = 'news_cache';

  static const topHeadlinesKey = 'top_headlines';

  String keyForCategory(String category) {
    return category == categories.first ? topHeadlinesKey : '${topHeadlinesKey}_$category';
  }

  Future<Box<dynamic>> _openBox() => Hive.openBox<dynamic>(boxName);

  Future<List<Article>?> getArticles(String cacheKey) async {
    final box = await _openBox();
    final value = box.get(cacheKey);

    if (value is List) {
      final items = value.whereType<Article>().toList(growable: false);
      return items.isEmpty ? null : items;
    }

    if (value is Map) {
      final rawArticles = value['articles'];
      if (rawArticles is List) {
        final items = rawArticles.whereType<Article>().toList(growable: false);
        return items.isEmpty ? null : items;
      }
    }

    return null;
  }

  Future<void> saveArticles(String cacheKey, List<Article> articles) async {
    if (articles.isEmpty) {
      return;
    }
    final box = await _openBox();
    await box.put(cacheKey, {
      'articles': articles,
      'cachedAt': DateTime.now(),
    });
  }
}

