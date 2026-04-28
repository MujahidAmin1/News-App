import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/articles/services/news_service.dart';
import 'package:news_app/utils/categories.dart';

final selectedCategoryProvider = StateProvider<String>((ref) {
  return categories.first;
});

final newsControllerProvider =
    AsyncNotifierProvider<NewsController, NewsResponse>(NewsController.new);

class NewsController extends AsyncNotifier<NewsResponse> {
  @override
  Future<NewsResponse> build() async {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final newsService = ref.read(newsServiceProvider);

    if (selectedCategory == categories.first) {
      return newsService.getTopHeadlines();
    }

    return newsService.getTopHeadlinesByCategory(selectedCategory);
  }

  void changeCategory(String category) {
    if (!categories.contains(category)) {
      return;
    }
    ref.read(selectedCategoryProvider.notifier).state = category;
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
