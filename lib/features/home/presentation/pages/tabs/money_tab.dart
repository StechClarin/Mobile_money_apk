import 'package:flutter/material.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/design_system/app_colors.dart';
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
          backgroundColor: AppColors.darkScaffold,
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded, color: AppColors.monarchPurpleNeon),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(right: 8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.monarchPurpleNeon,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.monarchPurpleNeon,
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const Text(
                'Walliss Pay',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: AppColors.monarchPurpleNeon),
              onPressed: () {},
            ),
          ],
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
              PromoBanner(
                id: '1',
                imageUrl: 'url1',
                title: '0% de frais sur vos 3 premiers transferts',
                redirectLink: '/recipient-selection',
              ),
              PromoBanner(
                id: '2',
                imageUrl: 'url2',
                title: 'Boutique Walliss : -20% sur les équipements',
                redirectLink: '/shop',
              ),
              PromoBanner(
                id: '3',
                imageUrl: 'url3',
                title: 'Payez en 1 clic chez vos marchands favoris',
                redirectLink: '/payment',
              ),
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
