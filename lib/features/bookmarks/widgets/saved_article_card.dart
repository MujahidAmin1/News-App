import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app/features/articles/model/article.dart';
import 'package:news_app/features/articles/widgets/news_network_image.dart';
import 'package:news_app/utils/article_time_ago.dart';

class SavedArticleCard extends StatelessWidget {
  const SavedArticleCard({
    super.key,
    required this.article,
    required this.onRemove,
    required this.onOpen,
  });

  final Article article;
  final VoidCallback onRemove;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpen,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0F141D),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF253041)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                NewsNetworkImage(
                  imageUrl: article.image,
                  height: 220,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: const Color(0x990C1016),
                    borderRadius: BorderRadius.circular(6),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: onRemove,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: SvgPicture.asset("assets/saved.svg"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          article.source.name.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFFF6170),
                            fontSize: 10,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.schedule_rounded, size: 12, color: Color(0xFF7A8598)),
                      const SizedBox(width: 4),
                      Text(
                        formatTimeAgo(article.publishedAt).toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xFF7A8598),
                          fontSize: 10,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFC1C9D6),
                      fontSize: 14,
                      height: 1.25,
                    ),
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

