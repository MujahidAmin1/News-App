import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/articles/services/news_cache_service.dart';
import 'package:news_app/features/articles/services/news_service.dart';
import 'package:news_app/utils/categories.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => categories.first);

final newsControllerProvider =
    AsyncNotifierProvider<NewsController, NewsResponse>(NewsController.new);

class NewsController extends AsyncNotifier<NewsResponse> {
  @override
  Future<NewsResponse> build() async {
    state = const AsyncValue.loading();

    final category = ref.watch(selectedCategoryProvider);
    final cache = ref.read(newsCacheServiceProvider);
    final cacheKey = cache.keyForCategory(category);

    final cachedArticles = await cache.getArticles(cacheKey);
    if (cachedArticles != null) {
      final cachedResponse = NewsResponse(
        totalResults: cachedArticles.length,
        articles: cachedArticles,
      );

      state = AsyncData(cachedResponse);
      return cachedResponse;
    }

    final fresh = await _fetchFromApi(category);
    state = AsyncData(fresh);
    await cache.saveArticles(cacheKey, fresh.articles);
    return fresh;
  }

  void changeCategory(String category) {
    if (!categories.contains(category)) return;
    ref.read(selectedCategoryProvider.notifier).state = category;
  }

  Future<void> refresh() async {
    final category = ref.read(selectedCategoryProvider);
    final cache = ref.read(newsCacheServiceProvider);
    final cacheKey = cache.keyForCategory(category);

    state = const AsyncValue.loading();
    try {
      final fresh = await _fetchFromApi(category);
      await cache.saveArticles(cacheKey, fresh.articles);
      state = AsyncData(fresh);
    } catch (e, st) {
      final cached = await cache.getArticles(cacheKey);
      if (cached != null) {
        state = AsyncData(NewsResponse(totalResults: cached.length, articles: cached));
        return;
      }
      state = AsyncError(e, st);
    }
  }

  Future<NewsResponse> _fetchFromApi(String category) {
    final service = ref.read(newsServiceProvider);
    return category == categories.first
        ? service.getTopHeadlines()
        : service.getTopHeadlinesByCategory(category);
  }
}
