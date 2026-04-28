import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/articles/services/news_service.dart';
import 'package:news_app/utils/categories.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => categories.first);

final newsControllerProvider =
    AsyncNotifierProvider<NewsController, NewsResponse>(NewsController.new);

class NewsController extends AsyncNotifier<NewsResponse> {
  static const _cacheBoxName = 'news_cache';
  static const _topHeadlinesKey = 'top_headlines';
  static const _cacheTtl = Duration(hours: 1);
  static const _refreshThrottle = Duration(minutes: 5);

  late Box<dynamic> _cacheBox;
  final Map<String, Future<NewsResponse>> _inFlight = {};
  final Map<String, DateTime> _lastRefreshStartedAt = {};
  bool _forceNextRefresh = false;

  @override
  Future<NewsResponse> build() async {
    _cacheBox = await Hive.openBox<dynamic>(_cacheBoxName);
    final category = ref.watch(selectedCategoryProvider);
    final cacheKey = _cacheKeyFor(category);
    final cached = _decodeCacheEntry(_cacheBox.get(cacheKey));

    if (cached != null) {
      unawaited(_refreshInBackground(
        cacheKey: cacheKey,
        category: category,
        fetcher: _fetcherFor(category),
      ));
      return NewsResponse(
        totalResults: cached.articles.length,
        articles: cached.articles,
      );
    }

    final fresh = await _fetchOnce(cacheKey, _fetcherFor(category));
    await _writeCacheEntry(cacheKey, fresh.articles);
    return fresh;
  }

  void changeCategory(String category) {
    if (!categories.contains(category)) return;
    ref.read(selectedCategoryProvider.notifier).state = category;
  }

  Future<void> refresh() async {
    _forceNextRefresh = true;
    ref.invalidateSelf();
    await future;
  }

  Future<NewsResponse> Function() _fetcherFor(String category) {
    final service = ref.read(newsServiceProvider);
    return category == categories.first
        ? service.getTopHeadlines
        : () => service.getTopHeadlinesByCategory(category);
  }

  Future<NewsResponse> _fetchOnce(
    String cacheKey,
    Future<NewsResponse> Function() fetcher,
  ) {
    if (_inFlight[cacheKey] case final existing?) return existing;

    final request = fetcher();
    _inFlight[cacheKey] = request;
    request.whenComplete(() => _inFlight.remove(cacheKey));
    return request;
  }

  Future<void> _refreshInBackground({
    required String cacheKey,
    required String category,
    required Future<NewsResponse> Function() fetcher,
  }) async {
    if (ref.read(selectedCategoryProvider) != category) return;

    final cached = _decodeCacheEntry(_cacheBox.get(cacheKey));
    final isExpired = cached == null ||
        DateTime.now().difference(cached.cachedAt) > _cacheTtl;

    final lastStartedAt = _lastRefreshStartedAt[cacheKey];
    final isThrottled = !_forceNextRefresh &&
        !isExpired &&
        lastStartedAt != null &&
        DateTime.now().difference(lastStartedAt) < _refreshThrottle;

    if (isThrottled) return;

    _lastRefreshStartedAt[cacheKey] = DateTime.now();
    _forceNextRefresh = false;

    try {
      final fresh = await _fetchOnce(cacheKey, fetcher);
      if (fresh.articles.isEmpty) return;

      await _writeCacheEntry(cacheKey, fresh.articles);

      if (ref.read(selectedCategoryProvider) != category) return;
      state = AsyncData(fresh);
    } catch (e, st) {
      log('News refresh failed for $cacheKey: $e', stackTrace: st);
    }
  }

  _NewsCacheEntry? _decodeCacheEntry(Object? value) {
    if (value is! Map) return null;

    final rawArticles = value['articles'];
    final rawCachedAt = value['cachedAt'];

    if (rawArticles is! List) return null;
    final articles = rawArticles.whereType<Article>().toList();
    if (articles.isEmpty) return null;

    final cachedAt = switch (rawCachedAt) {
      DateTime d => d,
      String s => DateTime.tryParse(s),
      _ => null,
    };

    return _NewsCacheEntry(
      articles: articles,
      cachedAt: cachedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Future<void> _writeCacheEntry(String key, List<Article> articles) async {
    await _cacheBox.put(key, {
      'articles': articles,
      'cachedAt': DateTime.now(),
    });
  }

  String _cacheKeyFor(String category) {
    return category == categories.first
        ? _topHeadlinesKey
        : '$_topHeadlinesKey$category';
  }
}

class _NewsCacheEntry {
  const _NewsCacheEntry({required this.articles, required this.cachedAt});

  final List<Article> articles;
  final DateTime cachedAt;
}
