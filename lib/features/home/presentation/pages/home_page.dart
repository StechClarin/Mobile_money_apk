import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/walliss_bottom_nav_bar.dart';
import '../manager/home_tab_provider.dart';
import 'tabs/money_tab.dart';
import 'tabs/boutique_tab.dart';
import '../../../transactions/presentation/pages/transactions_page.dart';
import '../../../account/presentation/pages/account_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const List<Widget> _pages = [
    MoneyTab(),          // 0: Balance (Portefeuille & Envois)
    BoutiqueTab(),       // 1: Market (Boutique Walliss)
    TransactionsPage(),  // 2: Exchange (Transactions & Historique)
    AccountPage(),       // 3: Setting (Profil & Paramètres)
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(homeTabIndexProvider);

    return Scaffold(
      backgroundColor: AppColors.darkScaffold,
      drawer: Drawer(
        backgroundColor: AppColors.spotifyCard,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: AppColors.monarchPurpleGradient,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.spotifyBlack,
                    child: const Icon(Icons.account_balance_wallet_rounded, color: AppColors.monarchPurpleNeon, size: 36),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Walliss & Shop',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Portefeuille numérique +237 677 00 00 00',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz_rounded, color: AppColors.monarchPurpleNeon),
              title: const Text('Transactions d\'argent', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                ref.read(homeTabIndexProvider.notifier).state = 2;
              },
            ),
            ListTile(
              leading: const Icon(Icons.storefront_outlined, color: AppColors.monarchPurpleNeon),
              title: const Text('Boutique Walliss (Market)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                ref.read(homeTabIndexProvider.notifier).state = 1;
              },
            ),
            ListTile(
              leading: const Icon(Icons.credit_card_rounded, color: AppColors.monarchPurpleNeon),
              title: const Text('Cartes virtuelles', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.cards);
              },
            ),
            const Divider(color: Color(0xFF282828)),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: AppColors.spotifyGrey),
              title: const Text('Paramètres & Sécurité', style: TextStyle(color: AppColors.spotifyGrey)),
              onTap: () {
                Navigator.pop(context);
                ref.read(homeTabIndexProvider.notifier).state = 3;
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: WallissBottomNavBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(homeTabIndexProvider.notifier).state = index;
        },
      ),
      floatingActionButton: currentIndex == 0 // Show Scan FAB on Balance tab
          ? FloatingActionButton.extended(
              onPressed: () {
                context.push(
                  AppRoutes.payment,
                  extra: {'name': 'Scan Captured: Jean D.', 'number': '677 88 99 00'},
                );
              },
              backgroundColor: AppColors.monarchPurpleNeon,
              foregroundColor: Colors.white,
              elevation: 4,
              icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
              label: const Text(
                'Scan & Pay',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.3),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
