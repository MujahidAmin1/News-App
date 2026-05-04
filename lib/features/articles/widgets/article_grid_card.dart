import 'package:flutter/material.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/articles/widgets/news_network_image.dart';
import 'package:news_app/utils/article_time_ago.dart';

class ArticleGridCard extends StatefulWidget {
  const ArticleGridCard({
    super.key,
    required this.article,
    required this.isBookmarked,
    required this.onToggleBookmark,
    required this.onOpen,
  });

  final Article article;
  final bool isBookmarked;
  final VoidCallback onToggleBookmark;
  final VoidCallback onOpen;

  @override
  State<ArticleGridCard> createState() => _ArticleGridCardState();
}

class _ArticleGridCardState extends State<ArticleGridCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onOpen,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFF151D2A)
                : const Color(0xFF101620),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFFFF3A4B).withValues(alpha: 0.3)
                  : Colors.transparent,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF3A4B).withValues(alpha: 0.08),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    child: AnimatedScale(
                      scale: _hovered ? 1.05 : 1.0,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      child: NewsNetworkImage(
                        imageUrl: widget.article.image,
                        height: 120,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: _BookmarkButton(
                      isBookmarked: widget.isBookmarked,
                      onTap: widget.onToggleBookmark,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.article.source.name.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFFF6170),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 180),
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          color: _hovered
                              ? Colors.white
                              : const Color(0xF0FFFFFF),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.15,
                        ),
                        child: Text(
                          widget.article.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.article.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFAAB4C4),
                          fontSize: 14,
                          height: 1.25,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            color: Color(0xFF7A8598),
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              formatTimeAgo(widget.article.publishedAt)
                                  .toUpperCase(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF7A8598),
                                fontSize: 10,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
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

class _BookmarkButton extends StatefulWidget {
  const _BookmarkButton({
    required this.isBookmarked,
    required this.onTap,
  });

  final bool isBookmarked;
  final VoidCallback onTap;

  @override
  State<_BookmarkButton> createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<_BookmarkButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFFFF3A4B).withValues(alpha: 0.85)
                : const Color(0xFF0D121A).withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            widget.isBookmarked
                ? Icons.bookmark
                : Icons.bookmark_border_rounded,
            size: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
