import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/promo_banner.dart';

class MomoBanner extends StatelessWidget {
  final PromoBanner banner;

  const MomoBanner({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.0),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (banner.redirectLink != null) {
            context.push(banner.redirectLink!);
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Placeholder for Image (NetworkImage would go here)
            Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(Icons.movie, size: 40, color: Colors.white), // Cinema icon for cinema look
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
            // Text Content
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Promo ${banner.id}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
