import 'package:flutter/material.dart';

class UnderlineNavigationDestination {
  const UnderlineNavigationDestination({
    required this.icon,
    this.selectedIcon,
    required this.label,
    this.enabled = true,
    this.semanticLabel,
  });

  final Widget icon;
  final Widget? selectedIcon;
  final String label;
  final bool enabled;
  final String? semanticLabel;
}

class UnderlineNavigationBar extends StatelessWidget {
  const UnderlineNavigationBar({
    super.key,
    this.selectedIndex = 0,
    required this.destinations,
    this.onDestinationSelected,
    this.backgroundColor,
    this.elevation = 0,
    this.shadowColor,
    this.height = 86,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor = const Color(0xFFFF2D2D),
    this.indicatorHeight = 3,
    this.indicatorWidthFactor = 0.8,
    this.animationDuration = const Duration(milliseconds: 250),
    this.maintainBottomViewPadding = false,
  })  : assert(destinations.length >= 2),
        assert(0 <= selectedIndex && selectedIndex < destinations.length),
        assert(indicatorWidthFactor > 0 && indicatorWidthFactor <= 1);

  final int selectedIndex;
  final List<UnderlineNavigationDestination> destinations;
  final ValueChanged<int>? onDestinationSelected;

  final Color? backgroundColor;
  final double elevation;
  final Color? shadowColor;
  final double height;

  final Color? selectedColor;
  final Color? unselectedColor;

  final Color indicatorColor;
  final double indicatorHeight;
  final double indicatorWidthFactor;

  final Duration animationDuration;
  final bool maintainBottomViewPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);

    final bottomPadding = maintainBottomViewPadding ? mq.viewPadding.bottom : mq.padding.bottom;
    final resolvedSelectedColor = selectedColor ?? theme.colorScheme.onSurface;
    final resolvedUnselectedColor = unselectedColor ?? theme.colorScheme.onSurface.withOpacity(0.6);

    return Material(
      color: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation,
      shadowColor: shadowColor,
      child: SizedBox(
        height: height + bottomPadding,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Row(
            children: [
              for (int i = 0; i < destinations.length; i++)
                Expanded(
                  child: _UnderlineNavigationTile(
                    index: i,
                    destination: destinations[i],
                    selected: i == selectedIndex,
                    onSelected: onDestinationSelected,
                    selectedColor: resolvedSelectedColor,
                    unselectedColor: resolvedUnselectedColor,
                    indicatorColor: indicatorColor,
                    indicatorHeight: indicatorHeight,
                    indicatorWidthFactor: indicatorWidthFactor,
                    animationDuration: animationDuration,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UnderlineNavigationTile extends StatelessWidget {
  const _UnderlineNavigationTile({
    required this.index,
    required this.destination,
    required this.selected,
    required this.onSelected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.indicatorColor,
    required this.indicatorHeight,
    required this.indicatorWidthFactor,
    required this.animationDuration,
  });

  final int index;
  final UnderlineNavigationDestination destination;
  final bool selected;
  final ValueChanged<int>? onSelected;

  final Color selectedColor;
  final Color unselectedColor;
  final Color indicatorColor;
  final double indicatorHeight;
  final double indicatorWidthFactor;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    final color = selected ? selectedColor : unselectedColor;
    final effectiveIcon = selected ? (destination.selectedIcon ?? destination.icon) : destination.icon;
    final enabled = destination.enabled && onSelected != null;

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: destination.semanticLabel ?? destination.label,
      child: InkWell(
        onTap: enabled ? () => onSelected!(index) : null,
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: selected ? 1 : 0),
          duration: animationDuration,
          curve: Curves.easeOutCubic,
          builder: (context, t, child) {
            return SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    IconTheme.merge(
                      data: IconThemeData(color: color, size: 24),
                      child: DefaultTextStyle.merge(style: TextStyle(color: color), child: effectiveIcon),
                    ),
                    const SizedBox(height: 10),
                    AnimatedDefaultTextStyle(
                      duration: animationDuration,
                      curve: Curves.easeOutCubic,
                      style: TextStyle(
                        color: Color.lerp(unselectedColor, selectedColor, t),
                        fontSize: 12,
                        letterSpacing: 1.4,
                        fontWeight: t > 0.5 ? FontWeight.w600 : FontWeight.w500,
                      ),
                      child: Text(destination.label.toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: SizedBox(
                        height: indicatorHeight,
                        child: FractionallySizedBox(
                          widthFactor: indicatorWidthFactor,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color.lerp(Colors.transparent, indicatorColor, t),
                              borderRadius: BorderRadius.circular(indicatorHeight / 2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
