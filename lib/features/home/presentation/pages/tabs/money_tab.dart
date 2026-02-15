import 'package:flutter/material.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../widgets/promo_carousel.dart';
import '../../widgets/services_grid.dart';
import '../../widgets/balance_qr_section.dart'; // New section
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
          leading: IconButton(
            icon: const Icon(Icons.menu, color: AppTheme.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          title: const Text(
            '677 00 00 00', // Center connected number
            style: TextStyle(
              color: AppTheme.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          floating: true,
          pinned: true,
          elevation: 0,
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.lg),
        ),
        
        // 1. Balance & QR Section (New location)
        const SliverToBoxAdapter(
          child: BalanceQrSection(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.lg),
        ),
        
        // 2. Promo Banner
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

        // 3. Services Grid
        const SliverToBoxAdapter(
          child: ServicesGrid(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.lg),
        ),

        // 4. Recent Transactions
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
