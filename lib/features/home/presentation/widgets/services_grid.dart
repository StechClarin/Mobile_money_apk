import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
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
                color: widget.color.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
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
                color: AppColors.black,
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
    // Mock Data for Services
    final services = [
      {'title': 'Envoi Argent', 'icon': Icons.send, 'color': Colors.blue, 'route': AppRoutes.recipientSelection},
      {'title': 'Pass & Crédit', 'icon': Icons.phone_android, 'color': Colors.orange, 'route': '/bundles'},
      {'title': 'Factures', 'icon': Icons.receipt_long, 'color': Colors.red, 'route': '/transactions'},
      {'title': 'Banque', 'icon': Icons.account_balance, 'color': Colors.green, 'route': '/transactions'},
      {'title': 'Cartes MoMo', 'icon': Icons.credit_card, 'color': Colors.purple, 'route': '/cards'},
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
