import 'dart:async';
import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/promo_banner.dart';
import 'momo_banner.dart';

class PromoCarousel extends StatefulWidget {
  final List<PromoBanner> banners;

  const PromoCarousel({super.key, required this.banners});

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    if (widget.banners.isNotEmpty) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < widget.banners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink(); // Optimization for empty list
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 21 / 9,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return Padding(
                 padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                 child: MomoBanner(banner: banner),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SmoothPageIndicator(
          controller: _pageController,
          count: widget.banners.length,
          effect: const ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppTheme.mtnYellow,
            dotColor: Colors.black12,
          ),
        ),
      ],
    );
  }
}
