import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/articles/services/news_service.dart';

final searchSubmittedQueryProvider = StateProvider.autoDispose<String?>((ref) => null);

final searchControllerProvider =
    AsyncNotifierProvider.autoDispose<SearchController, List<Article>>(SearchController.new);

class SearchController extends AsyncNotifier<List<Article>> {

  @override
  Future<List<Article>> build() async => const [];

  Future<void> submit(String query) async {
    final trimmed = query.trim();
    ref.read(searchSubmittedQueryProvider.notifier).state = trimmed.isEmpty ? null : trimmed;

    if (trimmed.isEmpty) {
      state = const AsyncData([]);
      return;
    }

    state = const AsyncLoading();
    try {
      final articles = await _fetch(trimmed);
      state = AsyncData(articles);
    } catch (e, st) {
      log('Search failed for "$trimmed": $e', stackTrace: st);
      state = const AsyncData([]);
    }
  }

  void clear() {
    ref.read(searchSubmittedQueryProvider.notifier).state = null;
    state = const AsyncData([]);
  }

  Future<List<Article>> _fetch(String query) async {
    final service = ref.read(newsServiceProvider);
    final response = await service.searchArticles(query);
    return response.articles;
  }
}
