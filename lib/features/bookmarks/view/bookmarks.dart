import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/bookmarks/controller/bookmark_controller.dart';
import 'package:news_app/features/bookmarks/widgets/saved_article_card.dart';

class Bookmarks extends ConsumerWidget {
  const Bookmarks({super.key, required this.onArticleTap});

  final ValueChanged<Article> onArticleTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmarks = ref.watch(bookmarksControllerProvider);
    final bookmarksCtrl = ref.read(bookmarksControllerProvider.notifier);
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
          child: bookmarks.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Failed to load bookmarks: $e')),
            data: (items) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'LIBRARY',
                              style: TextStyle(
                                color: Color(0xFFFF3A4B),
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Saved Articles',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                height: 1.05,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${items.length} article${items.length == 1 ? '' : 's'} saved on this device',
                              style: const TextStyle(color: Color(0xFF93A0B6)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      TextButton.icon(
                        onPressed: items.isEmpty ? null : bookmarksCtrl.clearAll,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF9AA4B5),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFF253041)),
                          ),
                        ),
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text(
                          'CLEAR ALL',
                          style: TextStyle(fontSize: 11, letterSpacing: 1.1, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  if (items.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          'No saved articles yet',
                          style: TextStyle(color: Color(0xFF93A0B6)),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final article = items[index];
                          return SavedArticleCard(
                            article: article,
                            onRemove: () => bookmarksCtrl.removeBookmark(article),
                            onOpen: () => onArticleTap(article),
                          );
                        },
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
