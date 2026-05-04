import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/articles/view/news_detail_screen.dart';
import 'package:news_app/features/articles/view/news_feed_content.dart';
import 'package:news_app/features/articles/widgets/sidebar.dart';
import 'package:news_app/features/bookmarks/view/bookmarks.dart';
import 'package:news_app/features/btm_navbar/btm_navbar_ctrl.dart';
import 'package:news_app/features/search/view/search_screen.dart';
import 'package:news_app/utils/screen_sizes.dart';

class DesktopLayout extends ConsumerWidget {
  const DesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentScreen = ref.watch(currentScreenProvider) ?? 0;

    void handleArticleTap(Article article) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => NewsDetailScreen(article: article)),
      );
    }

    List<Widget> screens = [
      NewsFeedContent(onArticleTap: handleArticleTap),
      SearchScreen(onArticleTap: handleArticleTap),
      Bookmarks(onArticleTap: handleArticleTap),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      body: SafeArea(
        child: Row(
          children: [
            const Sidebar(),
            Expanded(
              child: IndexedStack(
                index: currentScreen,
                children: screens,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
