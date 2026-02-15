import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/promo_banner.dart';

class MomoBanner extends StatefulWidget {
  final PromoBanner banner;

  const MomoBanner({super.key, required this.banner});

  @override
  State<MomoBanner> createState() => _MomoBannerState();
}

class _MomoBannerState extends State<MomoBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
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
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: AppColors.softShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) => _controller.reverse(),
              onTapCancel: () => _controller.reverse(),
              onTap: () {
                if (widget.banner.redirectLink != null) {
                  context.push(widget.banner.redirectLink!);
                }
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Image Placeholder / Background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(Icons.star, size: 100, color: Colors.white),
                      ),
                    ),
                  ),
                  // Rich Gradient Overlay for text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.4),
                          Colors.black.withValues(alpha: 0.8),
                        ],
                        stops: const [0.4, 0.7, 1.0],
                      ),
                    ),
                  ),
                  // Text Content
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'OFFRE',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.banner.title ?? 'Promo ${widget.banner.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
