import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/features/articles/controller/news_controller.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/articles/view/news_detail_screen.dart';
import 'package:news_app/features/articles/view/news_page_desktop.dart';
import 'package:news_app/features/articles/widgets/app_menu_bar.dart';
import 'package:news_app/features/articles/widgets/shortcuts_table.dart';
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
  // Keyboard shortcuts — desktop/native only, not web
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text(
          'Keyboard Shortcuts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const ShortcutsTable(),
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

    // Core layout — shared between web and native
    Widget layout = Scaffold(
      backgroundColor: const Color(0xFF0B0F16),
      body: Column(
        children: [
          // App menu bar — native desktop only
          if (!kIsWeb)
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
    );

    // Wrap with keyboard shortcuts on native desktop only
    if (!kIsWeb) {
      layout = CallbackShortcuts(
        bindings: _shortcuts,
        child: Focus(
          autofocus: true,
          child: layout,
        ),
      );
    }

    return layout;
  }
}
