import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/constants.dart';

class MomoServiceTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MomoServiceTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<MomoServiceTile> createState() => _MomoServiceTileState();
}

class _MomoServiceTileState extends State<MomoServiceTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.spotifyCard,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF282828), width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(widget.icon, color: widget.color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for Pure Money Transactions & Shop Services
    final services = [
      {'title': 'Envoi Argent', 'icon': Icons.send_rounded, 'color': AppColors.monarchPurpleNeon, 'route': AppRoutes.recipientSelection},
      {'title': 'Boutique', 'icon': Icons.shopping_bag_outlined, 'color': Colors.orangeAccent, 'route': AppRoutes.shop},
      {'title': 'Scan QR', 'icon': Icons.qr_code_scanner_rounded, 'color': const Color(0xFF1DB954), 'route': AppRoutes.payment},
      {'title': 'Cartes', 'icon': Icons.credit_card_rounded, 'color': Colors.purpleAccent, 'route': AppRoutes.cards},
      {'title': 'Dépôt', 'icon': Icons.add_circle_outline_rounded, 'color': Colors.lightBlueAccent, 'route': AppRoutes.payment},
      {'title': 'Retrait', 'icon': Icons.arrow_circle_down_rounded, 'color': Colors.tealAccent, 'route': AppRoutes.payment},
      {'title': 'Paiement', 'icon': Icons.storefront_outlined, 'color': Colors.amberAccent, 'route': AppRoutes.shop},
      {'title': 'Historique', 'icon': Icons.receipt_long_rounded, 'color': AppColors.spotifyGrey, 'route': AppRoutes.transactions},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 24,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.65,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return MomoServiceTile(
          title: service['title'] as String,
          icon: service['icon'] as IconData,
          color: service['color'] as Color,
          onTap: () {
            final route = service['route'] as String?;
            if (route != null) {
              context.push(route);
            }
          },
        );
      },
    );
  }
}
