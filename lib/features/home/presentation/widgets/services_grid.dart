import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class MomoServiceTile extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          splashColor: color.withValues(alpha: 0.2),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11, // Slightly reduced font size
            fontWeight: FontWeight.w500,
            color: AppTheme.black,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for Services
    final services = [
      {'title': 'Send Money', 'icon': Icons.send, 'color': Colors.blue, 'route': '/payment'},
      {'title': 'Buy Airtime', 'icon': Icons.phone_android, 'color': Colors.orange, 'route': '/bundles'},
      {'title': 'Pay Bills', 'icon': Icons.receipt_long, 'color': Colors.red, 'route': '/transactions'},
      {'title': 'Bank Transfer', 'icon': Icons.account_balance, 'color': Colors.green, 'route': '/transactions'},
      {'title': 'Cards', 'icon': Icons.credit_card, 'color': Colors.purple, 'route': '/cards'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: AppSpacing.servicesGridSpacing,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.8,
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
