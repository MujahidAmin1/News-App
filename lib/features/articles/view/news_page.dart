import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/features/articles/controller/news_controller.dart';
import 'package:news_app/utils/categories.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsState = ref.watch(newsControllerProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Top Headlines')),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final category = categories[index];

                return ChoiceChip(
                  label: Text(category),
                  selected: category == selectedCategory,
                  onSelected: (_) {
                    ref
                        .read(newsControllerProvider.notifier)
                        .changeCategory(category);
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemCount: categories.length,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: ref.read(newsControllerProvider.notifier).refresh,
              child: newsState.when(
                loading: () => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  ],
                ),
                error: (error, _) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Center(child: Text('Error: $error')),
                    ),
                  ],
                ),
                data: (newsResponse) {
                  if (newsResponse.articles.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [
                        SizedBox(
                          height: 240,
                          child: Center(child: Text('No data available')),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: newsResponse.articles.length,
                    itemBuilder: (context, index) {
                      final article = newsResponse.articles[index];
                      return ListTile(
                        leading: Text('${index + 1}'),
                        title: Text(article.title),
                        subtitle: Text(article.description),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
