import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Item definition for [WallissBottomNavBar].
class WallissNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const WallissNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

/// A premium Dark & Sung Jin-woo (Shadow Monarch Purple) bottom navigation bar.
///
/// Features:
/// - Dark obsidian surface with subtle purple border and spectral glow.
/// - 4 items: Balance, Market, Exchange, Setting (or custom items).
/// - Micro-animations on selection with glowing active indicator.
class WallissBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<WallissNavItem> items;

  const WallissBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = defaultItems,
  });

  /// The standard items inspired by the FinTech UI reference:
  /// Balance, Market, Exchange, Setting
  static const List<WallissNavItem> defaultItems = [
    WallissNavItem(
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet_rounded,
      label: 'Balance',
    ),
    WallissNavItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
      label: 'Market',
    ),
    WallissNavItem(
      icon: Icons.swap_horiz_rounded,
      activeIcon: Icons.swap_horiz_rounded,
      label: 'Exchange',
    ),
    WallissNavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      label: 'Setting',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        boxShadow: AppColors.navBarDarkShadow,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(
          top: BorderSide(
            color: AppColors.monarchPurple.withValues(alpha: 0.25),
            width: 1.2,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            top: 10,
            bottom: bottomPadding > 0 ? 4 : 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;

              return Expanded(
                child: _NavBarItemWidget(
                  item: item,
                  isSelected: isSelected,
                  onTap: () => onTap(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavBarItemWidget extends StatelessWidget {
  final WallissNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItemWidget({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.monarchPurpleNeon : AppColors.textMutedDark;
    final icon = (isSelected && item.activeIcon != null) ? item.activeIcon! : item.icon;

    return InkWell(
      onTap: onTap,
      splashColor: AppColors.monarchPurple.withValues(alpha: 0.15),
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.monarchPurple.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with Sung Jin-woo purple aura when active
            AnimatedScale(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              scale: isSelected ? 1.15 : 1.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (isSelected)
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.monarchPurpleNeon.withValues(alpha: 0.45),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  Icon(
                    icon,
                    size: 26,
                    color: color,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            // Text Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.3,
                fontFamily: 'Inter',
              ),
              child: Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
