import 'package:flutter/material.dart';
import 'package:news_app/features/articles/widgets/news_category_nav_bar.dart';
import 'package:news_app/features/articles/widgets/news_top_header.dart';
import 'package:news_app/utils/categories.dart';
import 'package:news_app/utils/screen_sizes.dart';
import 'package:shimmer/shimmer.dart';

/// Full shimmer loading state that mirrors the news feed layout.
class NewsFeedShimmer extends StatelessWidget {
  const NewsFeedShimmer({super.key, required this.selectedCategory});

  final String selectedCategory;

  static const _base = Color(0xFF1A2232);
  static const _highlight = Color(0xFF2C3A52);

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isMobile = context.isMobile;

    return Shimmer.fromColors(
      baseColor: _base,
      highlightColor: _highlight,
      period: const Duration(milliseconds: 2000),
      child: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isMobile) const NewsTopHeader(),
                  if (isMobile) const SizedBox(height: 12),
                  NewsCategoryNavBar(
                    categories: categories,
                    selectedCategory: selectedCategory,
                    onSelectCategory: (_) {},
                  ),
                  const SizedBox(height: 14),
                  const ShimmerBox(width: 58, height: 11, radius: 4),
                  const SizedBox(height: 8),
                  const ShimmerBox(width: 150, height: 26, radius: 6),
                  const SizedBox(height: 14),
                  ShimmerFeaturedCard(height: isDesktop ? 380 : 220),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.64,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, __) => const ShimmerGridCard(),
                childCount: 6,
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}


class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 4,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}



class ShimmerFeaturedCard extends StatelessWidget {
  const ShimmerFeaturedCard({super.key, required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // FEATURED badge
          const Positioned(
            top: 12,
            left: 12,
            child: ShimmerBox(width: 68, height: 20, radius: 4),
          ),
          // Bookmark button
          const Positioned(
            top: 12,
            right: 12,
            child: ShimmerBox(width: 34, height: 34, radius: 6),
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
                const ShimmerBox(height: 20, radius: 4),
                const SizedBox(height: 6),
                const ShimmerBox(width: 200, height: 20, radius: 4),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    ShimmerBox(width: 80, height: 11, radius: 3),
                    SizedBox(width: 8),
                    ShimmerBox(width: 4, height: 4, radius: 2),
                    SizedBox(width: 8),
                    ShimmerBox(width: 60, height: 11, radius: 3),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



class ShimmerGridCard extends StatelessWidget {
  const ShimmerGridCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Container(
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(width: 60, height: 10, radius: 3),
                  const SizedBox(height: 8),
                  const ShimmerBox(height: 14, radius: 4),
                  const SizedBox(height: 5),
                  const ShimmerBox(height: 14, radius: 4),
                  const SizedBox(height: 5),
                  const ShimmerBox(width: 100, height: 14, radius: 4),
                  const SizedBox(height: 8),
                  const ShimmerBox(height: 11, radius: 3),
                  const SizedBox(height: 4),
                  const ShimmerBox(width: 120, height: 11, radius: 3),
                  const Spacer(),
                  Row(
                    children: const [
                      ShimmerBox(width: 12, height: 12, radius: 6),
                      SizedBox(width: 4),
                      ShimmerBox(width: 70, height: 10, radius: 3),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
