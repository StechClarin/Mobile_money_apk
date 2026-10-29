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
        color: AppColors.spotifyCard, // Spotify matte surface
        boxShadow: AppColors.navBarDarkShadow,
        border: const Border(
          top: BorderSide(
            color: Color(0xFF282828), // Spotify discrete divider
            width: 0.8,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            top: 8,
            bottom: bottomPadding > 0 ? 4 : 8,
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
    // Spotify active / inactive color contrast
    final iconColor = isSelected ? AppColors.monarchPurpleNeon : AppColors.spotifyGrey;
    final labelColor = isSelected ? Colors.white : AppColors.spotifyGrey;
    final icon = (isSelected && item.activeIcon != null) ? item.activeIcon! : item.icon;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Spotify style icon animation with Sung Jin-woo purple touch
            AnimatedScale(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              scale: isSelected ? 1.08 : 1.0,
              child: Icon(
                icon,
                size: 25,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 5),
            // Spotify Label styling
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: labelColor,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: 0.2,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
