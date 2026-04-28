import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:news_app/features/articles/model/article.dart';

final bookmarksControllerProvider =
    AsyncNotifierProvider<BookmarksController, List<Article>>(
  BookmarksController.new,
);

class BookmarksController extends AsyncNotifier<List<Article>> {
  static const _boxName = 'bookmarks_box';

  Box<Article>? _box;

  Future<Box<Article>> _ensureBox() async {
    final existing = _box;
    if (existing != null) {
      return existing;
    }
    final opened = await Hive.openBox<Article>(_boxName);
    _box = opened;
    return opened;
  }

  @override
  Future<List<Article>> build() async {
    final box = await _ensureBox();
    return box.values.toList(growable: false);
  }

  Future<void> addBookmark(Article article) async {
    final box = await _ensureBox();
    final key = _keyFor(article);
    if (box.containsKey(key)) return;

    try {
      await box.put(key, article);
      _emit(box);
    } catch (e, st) {
      log('Failed to add bookmark: $e', stackTrace: st);
    }
  }

  Future<void> removeBookmark(Article article) async {
    final box = await _ensureBox();
    final key = _keyFor(article);
    if (!box.containsKey(key)) return;

    try {
      await box.delete(key);
      _emit(box);
    } catch (e, st) {
      log('Failed to remove bookmark: $e', stackTrace: st);
    }
  }

  Future<void> clearAll() async {
    final box = await _ensureBox();
    try {
      await box.clear();
      _emit(box);
    } catch (e, st) {
      log('Failed to clear bookmarks: $e', stackTrace: st);
    }
  }

  bool isBookmarked(Article article) {
    final box = _box;
    if (box == null) {
      return false;
    }
    return box.containsKey(_keyFor(article));
  }

  List<Article> get bookmarks {
    return switch (state) {
      AsyncData(:final value) => value,
      _ => const [],
    };
  }

  void _emit(Box<Article> box) {
    state = AsyncData(box.values.toList(growable: false));
  }

  /// URL is preferred as the stable key; falls back to id.
  String _keyFor(Article article) {
    final url = article.url.trim();
    return url.isNotEmpty ? url : article.id.trim();
  }
}
