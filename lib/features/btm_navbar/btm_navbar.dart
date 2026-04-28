import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:news_app/features/articles/view/news_page.dart';
import 'package:news_app/features/bookmarks/view/bookmarks.dart';
import 'package:news_app/features/btm_navbar/btm_navbar_ctrl.dart';
import 'package:news_app/features/btm_navbar/widgets/underline_navigation_bar.dart';
import 'package:news_app/features/search/view/search_screen.dart';

class BtmNavbar extends ConsumerWidget {
  const BtmNavbar({super.key});

  Widget _navIcon(String assetPath, Color color) {
    return SvgPicture.asset(
      assetPath,
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int currentScreen = ref.watch(currentScreenProvider) ?? 0;
    List<Widget> screens = const [
      NewsPage(),
      SearchScreen(),
      Bookmarks(),
    ];
    return Scaffold(
      body: IndexedStack(
        index: currentScreen,
        children: screens,
      ),
      bottomNavigationBar: UnderlineNavigationBar(
        selectedIndex: currentScreen,
        onDestinationSelected: (value) {
          navigateTo(ref, value);
        },
        backgroundColor: const Color(0xFF0B0F16),
        elevation: 10,
        shadowColor: Colors.black54,
        selectedColor: const Color(0xFFF0F2F5),
        unselectedColor: const Color(0xFF9498A2),
        indicatorColor: const Color(0xFFFF2D2D),
        destinations: [
          UnderlineNavigationDestination(
            selectedIcon: _navIcon(
              "assets/feeds_filled.svg",
              const Color(0xFFF0F2F5),
            ),
            icon: _navIcon(
              "assets/feeds.svg",
              const Color(0xFF9498A2),
            ),
            label: 'FEEDS',
          ),
          UnderlineNavigationDestination(
            selectedIcon: _navIcon(
              "assets/search_filled.svg",
              const Color(0xFFF0F2F5),
            ),
            icon: _navIcon(
              "assets/search.svg",
              const Color(0xFF9498A2),
            ),
            label: 'SEARCH',
          ),
          UnderlineNavigationDestination(
            selectedIcon: _navIcon(
              "assets/saved_filled.svg",
              const Color(0xFFF0F2F5),
            ),
            icon: _navIcon(
              "assets/saved.svg",
              const Color(0xFF9498A2),
            ),
            label: 'SAVED',
          ),
        ],
      ),
    );
  }
}
