import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/features/articles/controller/news_controller.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/articles/view/news_detail_screen.dart';
import 'package:news_app/features/articles/view/news_page_desktop.dart';
import 'package:news_app/features/articles/widgets/app_menu_bar.dart';
import 'package:news_app/features/articles/widgets/sidebar.dart';
import 'package:news_app/features/bookmarks/view/bookmarks.dart';
import 'package:news_app/features/nav_bar/navbar_ctrl.dart';
import 'package:news_app/features/search/view/search_screen.dart';

class DesktopLayout extends ConsumerStatefulWidget {
  const DesktopLayout({super.key});

  @override
  ConsumerState<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends ConsumerState<DesktopLayout> {
  
  late final Map<ShortcutActivator, VoidCallback> _shortcuts = {
    const SingleActivator(LogicalKeyboardKey.digit1, control: true): () =>
        navigateTo(ref, 0),
    const SingleActivator(LogicalKeyboardKey.digit2, control: true): () =>
        navigateTo(ref, 1),
    const SingleActivator(LogicalKeyboardKey.digit3, control: true): () =>
        navigateTo(ref, 2),
    const SingleActivator(LogicalKeyboardKey.keyF, control: true): () =>
        navigateTo(ref, 1),
    const SingleActivator(LogicalKeyboardKey.keyR, control: true): () =>
        ref.read(newsControllerProvider.notifier).refresh(),
  };

  void _handleArticleTap(Article article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NewsDetailScreen(article: article)),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Newsroom Live Wire',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFFF3A4B),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'N',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  void _showShortcutsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF121821),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text(
          'Keyboard Shortcuts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const _ShortcutsTable(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFFFF3A4B)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentScreen = ref.watch(currentScreenProvider) ?? 0;

    final screens = [
      NewsFeedContent(onArticleTap: _handleArticleTap),
      SearchScreen(onArticleTap: _handleArticleTap),
      Bookmarks(onArticleTap: _handleArticleTap),
    ];

    return CallbackShortcuts(
      bindings: _shortcuts,
      child: Focus(
        autofocus: true,
        child: Scaffold(
          backgroundColor: const Color(0xFF0B0F16),
          body: Column(
            children: [
              AppMenuBar(
                onGoToFeeds: () => navigateTo(ref, 0),
                onGoToSearch: () => navigateTo(ref, 1),
                onGoToSaved: () => navigateTo(ref, 2),
                onRefresh: () =>
                    ref.read(newsControllerProvider.notifier).refresh(),
                onShowShortcuts: _showShortcutsDialog,
                onShowAbout: _showAboutDialog,
              ),
              Expanded(
                child: SafeArea(
                  top: false,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShortcutsTable extends StatelessWidget {
  const _ShortcutsTable();

  static const _rows = [
    ('Ctrl+1', 'Go to Feeds'),
    ('Ctrl+F / Ctrl+2', 'Go to Search'),
    ('Ctrl+3', 'Go to Saved'),
    ('Ctrl+R', 'Refresh news feed'),
    ('Ctrl+B', 'Bookmark current article'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _rows.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C2535),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: const Color(0xFF253041)),
                ),
                child: Text(
                  row.$1,
                  style: const TextStyle(
                    color: Color(0xFFFF6170),
                    fontSize: 12,
                    fontFamily: 'monospace',
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Text(
                row.$2,
                style: const TextStyle(color: Color(0xFFCDD4DF), fontSize: 13),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
