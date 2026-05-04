import 'package:flutter/material.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/articles/widgets/news_network_image.dart';
import 'package:news_app/utils/article_time_ago.dart';
import 'package:news_app/utils/screen_sizes.dart';

class FeaturedArticleCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpen,
      child: Container(
        height: context.isDesktop ? 380 : 220,
        decoration: BoxDecoration(
          color: const Color(0xFF0F141D),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF253041)),
        ),
        child: Stack(
          children: [
            NewsNetworkImage(
              imageUrl: article.image,
              height: double.infinity,
              width: double.infinity,
              borderRadius: BorderRadius.circular(8),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xDD090D14)],
                    stops: [0.3, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: const Color(0x990C1016),
                borderRadius: BorderRadius.circular(6),
                child: InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: onToggleBookmark,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Georgia',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        article.source.name.toUpperCase(),
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
                        formatTimeAgo(article.publishedAt).toUpperCase(),
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
    );
  }
}
