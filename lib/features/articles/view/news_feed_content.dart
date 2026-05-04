import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/features/articles/controller/news_controller.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/articles/widgets/animated_news_item.dart';
import 'package:news_app/features/articles/widgets/article_grid_card.dart';
import 'package:news_app/features/articles/widgets/featured_article_card.dart';
import 'package:news_app/features/articles/widgets/news_category_nav_bar.dart';
import 'package:news_app/features/articles/widgets/news_top_header.dart';
import 'package:news_app/features/bookmarks/controller/bookmark_controller.dart';
import 'package:news_app/utils/categories.dart';
import 'package:news_app/utils/screen_sizes.dart';

class NewsFeedContent extends ConsumerWidget {
  const NewsFeedContent({super.key, required this.onArticleTap});

  final ValueChanged<Article> onArticleTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsState = ref.watch(newsControllerProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: ref.read(newsControllerProvider.notifier).refresh,
        child: newsState.when(
          data: (newsResponse) => _FeedList(
            selectedCategory: selectedCategory,
            newsResponse: newsResponse,
            onSelectCategory: (category) => ref
                .read(newsControllerProvider.notifier)
                .changeCategory(category),
            onArticleTap: onArticleTap,
          ),
          loading: () => _LoadingState(selectedCategory: selectedCategory),
          error: (error, _) => _ErrorState(
            message: error.toString(),
            onRetry: () => ref.invalidate(newsControllerProvider),
          ),
        ),
      ),
    );
  }
}

class _FeedList extends ConsumerWidget {
  const _FeedList({
    required this.selectedCategory,
    required this.newsResponse,
    required this.onSelectCategory,
    required this.onArticleTap,
  });

  final String selectedCategory;
  final NewsResponse newsResponse;
  final ValueChanged<String> onSelectCategory;
  final ValueChanged<Article> onArticleTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articles = newsResponse.articles;
    final hasArticles = articles.isNotEmpty;
    final featuredArticle = hasArticles ? articles.first : null;
    final gridArticles = hasArticles ? articles.skip(1).toList() : <Article>[];
    final bookmarksAsync = ref.watch(bookmarksControllerProvider);
    final bookmarksCtrl = ref.read(bookmarksControllerProvider.notifier);
    final bookmarked = bookmarksAsync.value ?? const <Article>[];
    final isDesktop = context.isDesktop;

    bool isBookmarked(Article article) {
      return bookmarked.any((a) => a.url == article.url || a.id == article.id) ||
          bookmarksCtrl.isBookmarked(article);
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isDesktop && !context.isTablet) const NewsTopHeader(),
                if (!isDesktop && !context.isTablet) const SizedBox(height: 12),
                NewsCategoryNavBar(
                  categories: categories,
                  selectedCategory: selectedCategory,
                  onSelectCategory: onSelectCategory,
                ),
                const SizedBox(height: 14),
                const Text(
                  'SECTION',
                  style: TextStyle(
                    fontFamily: 'Jetbrains Mono',
                    color: Color(0xFFFF3A4B),
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _displayCategoryName(selectedCategory),
                  style: const TextStyle(
                    fontFamily: "Georgia",
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                if (featuredArticle != null)
                  AnimatedNewsItem(
                    index: 0,
                    child: FeaturedArticleCard(
                      article: featuredArticle,
                      isBookmarked: isBookmarked(featuredArticle),
                      onToggleBookmark: () {
                        if (isBookmarked(featuredArticle)) {
                          bookmarksCtrl.removeBookmark(featuredArticle);
                        } else {
                          bookmarksCtrl.addBookmark(featuredArticle);
                        }
                      },
                      onOpen: () => onArticleTap(featuredArticle),
                    ),
                  ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
        if (gridArticles.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: isDesktop ? 0.8 : 0.64,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final article = gridArticles[index];
                  return AnimatedNewsItem(
                    index: index + 1,
                    child: ArticleGridCard(
                      article: article,
                      isBookmarked: isBookmarked(article),
                      onToggleBookmark: () {
                        if (isBookmarked(article)) {
                          bookmarksCtrl.removeBookmark(article);
                        } else {
                          bookmarksCtrl.addBookmark(article);
                        }
                      },
                      onOpen: () => onArticleTap(article),
                    ),
                  );
                },
                childCount: gridArticles.length,
              ),
            ),
          ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState({required this.selectedCategory});

  final String selectedCategory;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
      children: [
        if (!context.isDesktop && !context.isTablet) const NewsTopHeader(),
        if (!context.isDesktop && !context.isTablet) const SizedBox(height: 12),
        NewsCategoryNavBar(
          categories: categories,
          selectedCategory: selectedCategory,
          onSelectCategory: (_) {},
        ),
        const SizedBox(height: 80),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 20),
      children: [
        if (!context.isDesktop && !context.isTablet) const NewsTopHeader(),
        if (!context.isDesktop && !context.isTablet) const SizedBox(height: 48),
        const Icon(
          Icons.wifi_off_rounded,
          color: Color(0xFF6F7A8F),
          size: 44,
        ),
        const SizedBox(height: 12),
        const Text(
          'Unable to load stories',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: FilledButton(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFF3A4B),
              foregroundColor: Colors.white,
            ),
            child: const Text('Try Again'),
          ),
        ),
      ],
    );
  }
}

String _displayCategoryName(String category) {
  if (category.isEmpty) {
    return 'Headlines';
  }

  return category[0].toUpperCase() + category.substring(1).toLowerCase();
}
