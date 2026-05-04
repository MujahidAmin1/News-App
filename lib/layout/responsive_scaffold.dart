import 'package:flutter/material.dart';
import 'package:news_app/layout/desktop_layout.dart';
import 'package:news_app/layout/mobile_layout.dart';
import 'package:news_app/utils/screen_sizes.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (context.isDesktop || context.isTablet) {
          return const DesktopLayout();
        }
        return const MobileLayout();
      },
    );
  }
}
