import 'package:flutter/material.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/articles/widgets/news_network_image.dart';
import 'package:news_app/utils/article_time_ago.dart';
import 'package:news_app/utils/screen_sizes.dart';

class FeaturedArticleCard extends StatefulWidget {
  const FeaturedArticleCard({
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
  State<FeaturedArticleCard> createState() => _FeaturedArticleCardState();
}

class _FeaturedArticleCardState extends State<FeaturedArticleCard> {
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
          height: context.isDesktop ? 380 : 220,
          decoration: BoxDecoration(
            color: const Color(0xFF0F141D),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFFFF3A4B).withValues(alpha: 0.6)
                  : const Color(0xFF253041),
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF3A4B).withValues(alpha: 0.12),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Stack(
            children: [
              // Background image with subtle scale on hover
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: AnimatedScale(
                  scale: _hovered ? 1.03 : 1.0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  child: NewsNetworkImage(
                    imageUrl: widget.article.image,
                    height: double.infinity,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Gradient overlay — slightly darker on hover
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        _hovered
                            ? const Color(0xF0090D14)
                            : const Color(0xDD090D14),
                      ],
                      stops: const [0.3, 1],
                    ),
                  ),
                ),
              ),
              // FEATURED badge
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3A4B),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'FEATURED',
                    style: TextStyle(
                      fontFamily: 'Jetbrains Mono',
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              // Bookmark button
              Positioned(
                top: 12,
                right: 12,
                child: _BookmarkButton(
                  isBookmarked: widget.isBookmarked,
                  onTap: widget.onToggleBookmark,
                ),
              ),
              // Title + meta
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 180),
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        color: _hovered
                            ? Colors.white
                            : const Color(0xF0FFFFFF),
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        height: 1.2,
                      ),
                      child: Text(
                        widget.article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          widget.article.source.name.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFFF6170),
                            fontSize: 11,
                            letterSpacing: 0.7,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '•',
                          style: TextStyle(
                            color: Color(0xFF7A8598),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          formatTimeAgo(widget.article.publishedAt)
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF7A8598),
                            fontSize: 11,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ],
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFFFF3A4B).withValues(alpha: 0.85)
                : const Color(0xFF0C1016).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(
            widget.isBookmarked
                ? Icons.bookmark
                : Icons.bookmark_border_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}
