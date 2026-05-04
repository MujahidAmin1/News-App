import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppMenuBar extends StatelessWidget {
  const AppMenuBar({
    super.key,
    required this.onGoToFeeds,
    required this.onGoToSearch,
    required this.onGoToSaved,
    required this.onRefresh,
    required this.onShowShortcuts,
    required this.onShowAbout,
  });

  final VoidCallback onGoToFeeds;
  final VoidCallback onGoToSearch;
  final VoidCallback onGoToSaved;
  final VoidCallback onRefresh;
  final VoidCallback onShowShortcuts;
  final VoidCallback onShowAbout;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: const Color(0xFF0D1119),
      child: Row(
        children: [
          const SizedBox(width: 8),
          MenuButton(
            label: 'File',
            items: [
              MenuItem(label: 'Refresh Feed', shortcut: 'Ctrl+R', onTap: onRefresh),
              const Divider(height: 1, thickness: 1, color: Color(0xFF253041)),
              MenuItem(label: 'Exit', onTap: () => SystemNavigator.pop()),
            ],
          ),
          MenuButton(
            label: 'Edit',
            items: [
              MenuItem(label: 'Search Articles', shortcut: 'Ctrl+F', onTap: onGoToSearch),
            ],
          ),
          MenuButton(
            label: 'View',
            items: [
              MenuItem(label: 'Feeds', shortcut: 'Ctrl+1', onTap: onGoToFeeds),
              MenuItem(label: 'Search', shortcut: 'Ctrl+2', onTap: onGoToSearch),
              MenuItem(label: 'Saved', shortcut: 'Ctrl+3', onTap: onGoToSaved),
            ],
          ),
          MenuButton(
            label: 'Help',
            items: [
              MenuItem(label: 'Keyboard Shortcuts', onTap: onShowShortcuts),
              const Divider(height: 1, thickness: 1, color: Color(0xFF253041)),
              MenuItem(label: 'About Newsroom', onTap: onShowAbout),
            ],
          ),
        ],
      ),
    );
  }
}

class MenuButton extends StatefulWidget {
  const MenuButton({super.key, required this.label, required this.items});

  final String label;
  final List<Widget> items;

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  bool _hovered = false;

  Future<void> _showMenu(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.localToGlobal(Offset(0, box.size.height));

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        offset.dx + 200,
        offset.dy + 300,
      ),
      color: const Color(0xFF141C27),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: Color(0xFF253041)),
      ),
      elevation: 8,
      items: widget.items
          .map((w) => PopupMenuItem<Never>(
                enabled: false,
                padding: EdgeInsets.zero,
                height: 0,
                child: w,
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showMenu(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered
                ? const Color(0xFFFF3A4B).withValues(alpha: 0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color: _hovered ? Colors.white : const Color(0xFFB0BAC8),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItem extends StatefulWidget {
  const MenuItem({
    super.key,
    required this.label,
    this.shortcut,
    required this.onTap,
  });

  final String label;
  final String? shortcut;
  final VoidCallback onTap;

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: _hovered
              ? const Color(0xFFFF3A4B).withValues(alpha: 0.12)
              : Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: _hovered ? Colors.white : const Color(0xFFCDD4DF),
                  fontSize: 13,
                ),
              ),
              if (widget.shortcut != null)
                Text(
                  widget.shortcut!,
                  style: TextStyle(
                    color: const Color(0xFF7A8598)
                        .withValues(alpha: _hovered ? 1.0 : 0.8),
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
