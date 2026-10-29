import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/walliss_bottom_nav_bar.dart';
import 'tabs/money_tab.dart';
import 'tabs/ma_ligne_tab.dart';
import 'tabs/boutique_tab.dart';
import '../../../account/presentation/pages/account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Default to Balance (0: Balance, 1: Market, 2: Exchange, 3: Setting)

  final List<Widget> _pages = [
    const MoneyTab(),      // 0: Balance
    const BoutiqueTab(),   // 1: Market
    const MaLigneTab(),    // 2: Exchange
    const AccountPage(),   // 3: Setting
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkScaffold,
      drawer: Drawer(
        backgroundColor: AppColors.darkCard,
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
                    backgroundColor: AppColors.darkCard,
                    child: const Icon(Icons.person, color: AppColors.monarchPurpleNeon, size: 40),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Walliss User',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '+237 677 00 00 00',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history, color: AppColors.monarchPurpleNeon),
              title: const Text('Historique', style: TextStyle(color: AppColors.textLight)),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.transactions);
              },
            ),
            ListTile(
              leading: const Icon(Icons.credit_card, color: AppColors.monarchPurpleNeon),
              title: const Text('Cartes Walliss', style: TextStyle(color: AppColors.textLight)),
              onTap: () {
                Navigator.pop(context);
                context.push(AppRoutes.cards);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: AppColors.monarchPurpleNeon),
              title: const Text('Paramètres', style: TextStyle(color: AppColors.textLight)),
              onTap: () {
                Navigator.pop(context);
                setState(() => _currentIndex = 3);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: WallissBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: _currentIndex == 0 // Show Scan FAB on Balance tab
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
