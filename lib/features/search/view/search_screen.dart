import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/bookmarks/controller/bookmark_controller.dart';
import 'package:news_app/features/search/controller/search_controller.dart';
import 'package:news_app/features/search/widgets/search_result_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, required this.onArticleTap});

  final ValueChanged<Article> onArticleTap;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: ref.read(searchSubmittedQueryProvider) ?? '',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(searchControllerProvider.notifier);
    final submittedQuery = ref.watch(searchSubmittedQueryProvider);
    final results = ref.watch(searchControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SEARCH',
                style: TextStyle(
                  color: Color(0xFFFF3A4B),
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Find articles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 14),
              SearchField(
                controller: _textController,
                onSubmitted: controller.submit,
                onClear: () {
                  _textController.clear();
                  controller.clear();
                },
              ),
              const SizedBox(height: 12),
              if (submittedQuery != null && submittedQuery.trim().isNotEmpty) ...[
                results.when(
                  loading: () => const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const Expanded(
                    child: Center(
                      child: Text(
                        'Unable to load results',
                        style: TextStyle(color: Color(0xFF93A0B6)),
                      ),
                    ),
                  ),
                  data: (items) => _ResultsList(
                    query: submittedQuery,
                    articles: items,
                    onArticleTap: widget.onArticleTap,
                  ),
                ),
              ] else ...[
                const Padding(
                  padding: EdgeInsets.only(top: 28),
                  child: Text(
                    'Search for any keyword and press enter.',
                    style: TextStyle(color: Color(0xFF93A0B6)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  const SearchField({
    required this.controller,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  State<SearchField> createState() => SearchFieldState();
}

class SearchFieldState extends State<SearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onChanged);
      widget.controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final hasText = widget.controller.text.trim().isNotEmpty;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0F141D),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFF3A4B), width: 1.2),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(Icons.search_rounded, color: Color(0xFF9AA4B5), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controller,
              textInputAction: TextInputAction.search,
              onSubmitted: widget.onSubmitted,
              style: const TextStyle(color: Colors.white),
              cursorColor: const Color(0xFFFF3A4B),
              decoration: const InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(color: Color(0xFF7A8598)),
                border: InputBorder.none,
              ),
            ),
          ),
          if (hasText)
            IconButton(
              onPressed: widget.onClear,
              icon: const Icon(Icons.close_rounded, size: 18, color: Color(0xFF7A8598)),
            )
          else
            const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _ResultsList extends ConsumerWidget {
  const _ResultsList({
    required this.query,
    required this.articles,
    required this.onArticleTap,
  });

  final String query;
  final List<Article> articles;
  final ValueChanged<Article> onArticleTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = articles;
    final bookmarksAsync = ref.watch(bookmarksControllerProvider);
    final bookmarkCtrl = ref.read(bookmarksControllerProvider.notifier);
    final bookmarked = bookmarksAsync.value ?? const <Article>[];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${items.length} RESULTS FOR "${query.toUpperCase()}"',
            style: const TextStyle(
              color: Color(0xFF7A8598),
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final article = items[index];
                final isBookmarked = bookmarked.any((a) => a.url == article.url || a.id == article.id) ||
                    bookmarkCtrl.isBookmarked(article);

                return SearchResultCard(
                  article: article,
                  isBookmarked: isBookmarked,
                  onToggleBookmark: () {
                    if (isBookmarked) {
                      bookmarkCtrl.removeBookmark(article);
                    } else {
                      bookmarkCtrl.addBookmark(article);
                    }
                  },
                  onOpen: () => onArticleTap(article),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
