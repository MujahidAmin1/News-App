import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/features/articles/controller/news_controller.dart';
import 'package:news_app/features/btm_navbar/btm_navbar_ctrl.dart';
import 'package:news_app/utils/categories.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(currentScreenProvider) ?? 0;
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Container(
      width: 220,
      color: const Color(0xFF121821), // Sidebar background color
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF3A4B),
                  borderRadius: BorderRadius.circular(4),
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
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NEWSROOM',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    'LIVE WIRE',
                    style: TextStyle(
                      color: Color(0xFF8A94A8),
                      fontSize: 10,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),
          _NavItem(
            title: 'FEEDS',
            isActive: activeIndex == 0,
            onTap: () => navigateTo(ref, 0),
          ),
          const SizedBox(height: 16),
          _NavItem(
            title: 'SEARCH',
            isActive: activeIndex == 1,
            onTap: () => navigateTo(ref, 1),
          ),
          const SizedBox(height: 16),
          _NavItem(
            title: 'SAVED',
            isActive: activeIndex == 2,
            onTap: () => navigateTo(ref, 2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          if (isActive)
            Container(
              width: 3,
              height: 16,
              color: const Color(0xFFFF3A4B),
              margin: const EdgeInsets.only(right: 12),
            )
          else
            const SizedBox(width: 15),
          Text(
            title,
            style: TextStyle(
              color: isActive
                  ? const Color(0xFFFF3A4B)
                  : const Color(0xFF8A94A8),
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
