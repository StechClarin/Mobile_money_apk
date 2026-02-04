import 'package:flutter/material.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../widgets/promo_carousel.dart';
import '../../widgets/services_grid.dart';
import '../../widgets/home_header.dart';
import '../../widgets/recent_transactions.dart';
import '../../../domain/entities/promo_banner.dart';

class MoneyTab extends StatefulWidget {
  const MoneyTab({super.key});

  @override
  State<MoneyTab> createState() => _MoneyTabState();
}

class _MoneyTabState extends State<MoneyTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      key: const PageStorageKey('MoneyTab'),
      slivers: [
        SliverAppBar(
          backgroundColor: AppTheme.mtnYellow,
          title: Text(
            'My MoMo',
            style: TextStyle(
              color: AppTheme.black,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.0,
              fontFamily: 'Serif', // Fallback to a serif if available, or just distinct style
              shadows: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  offset: const Offset(2, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          centerTitle: false,
          floating: true,
          pinned: true,
          snap: true,
          expandedHeight: 320, // Increased for larger QR header
          flexibleSpace: const FlexibleSpaceBar(
            background: Padding(
              padding: EdgeInsets.only(top: 60.0),
              child: HomeHeader(),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.md),
        ),
        
        // 1. Promo Banner
        SliverToBoxAdapter(
          child: PromoCarousel(
            banners: const [
              PromoBanner(id: '1', imageUrl: 'url1', redirectLink: '/bundles'),
              PromoBanner(id: '2', imageUrl: 'url2', redirectLink: '/transactions'),
              PromoBanner(id: '3', imageUrl: 'url3'),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.lg),
        ),

        // 2. Services Grid (Cards are now here)
        const SliverToBoxAdapter(
          child: ServicesGrid(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.lg),
        ),

        // 3. Recent Transactions
        const SliverToBoxAdapter(
          child: RecentTransactions(),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        ),
      ],
    );
  }
}
