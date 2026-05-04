import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/features/nav_bar/navbar_ctrl.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeIndex = ref.watch(currentScreenProvider) ?? 0;

    return Container(
      width: 220,
      color: const Color(0xFF121821),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
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
            shortcut: '⌘1',
            isActive: activeIndex == 0,
            onTap: () => navigateTo(ref, 0),
          ),
          const SizedBox(height: 8),
          _NavItem(
            title: 'SEARCH',
            shortcut: '⌘F',
            isActive: activeIndex == 1,
            onTap: () => navigateTo(ref, 1),
          ),
          const SizedBox(height: 8),
          _NavItem(
            title: 'SAVED',
            shortcut: '⌘3',
            isActive: activeIndex == 2,
            onTap: () => navigateTo(ref, 2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.title,
    required this.shortcut,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final String shortcut;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;
    final isHighlighted = isActive || _hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFFFF3A4B).withValues(alpha: 0.1)
                : _hovered
                    ? const Color(0xFFFF3A4B).withValues(alpha: 0.06)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              // Active indicator bar
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 3,
                height: 16,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? const Color(0xFFFF3A4B)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    color: isHighlighted
                        ? const Color(0xFFFF3A4B)
                        : const Color(0xFF8A94A8),
                    fontSize: 14,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              // Keyboard shortcut hint
              AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: _hovered || isActive ? 1.0 : 0.0,
                child: Text(
                  widget.shortcut,
                  style: TextStyle(
                    color: const Color(0xFFFF3A4B).withValues(alpha: 0.6),
                    fontSize: 10,
                    letterSpacing: 0.3,
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
