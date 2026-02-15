import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants.dart';
import 'package:mobilemoney/core/design_system/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import 'tabs/money_tab.dart';
import 'tabs/ma_ligne_tab.dart';
import 'tabs/boutique_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1; // Default to Money Tab

  final List<Widget> _pages = [
    const MaLigneTab(),
    const MoneyTab(),
    const BoutiqueTab(),
    const Scaffold(body: Center(child: Text('Me Tab'))), // Placeholder for Me Tab
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.mtnYellow),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: AppColors.primary, size: 40),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Yello User',
                    style: TextStyle(color: AppTheme.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '677 00 00 00',
                    style: TextStyle(color: AppTheme.black.withValues(alpha: 0.7)),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historique'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: AppTheme.mtnYellow,
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          elevation: 0, // Remove default elevation to use custom shadow
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: _currentIndex == 0 ? BoxDecoration(color: AppTheme.mtnYellow.withValues(alpha: 0.1), shape: BoxShape.circle) : null,
                child: const Icon(Icons.show_chart),
              ),
              label: 'Ma Ligne',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                 decoration: _currentIndex == 1 ? BoxDecoration(color: AppTheme.mtnYellow.withValues(alpha: 0.1), shape: BoxShape.circle) : null,
                child: const Icon(Icons.account_balance_wallet),
              ),
              label: 'Money',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                 decoration: _currentIndex == 2 ? BoxDecoration(color: AppTheme.mtnYellow.withValues(alpha: 0.1), shape: BoxShape.circle) : null,
                child: const Icon(Icons.shopping_bag_outlined),
              ),
              label: 'Boutique',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(8),
                 decoration: _currentIndex == 3 ? BoxDecoration(color: AppTheme.mtnYellow.withValues(alpha: 0.1), shape: BoxShape.circle) : null,
                child: const Icon(Icons.person_outline),
              ),
              label: 'Me',
            ),
          ],
        ),
      ),
      floatingActionButton: _currentIndex == 1 // Only show FAB on Money Tab
          ? FloatingActionButton.extended(
              onPressed: () {
                // Simulate scan capture and navigate to payment
                context.push(
                  AppRoutes.payment,
                  extra: {'name': 'Scan Captured: Jean D.', 'number': '677 88 99 00'},
                );
              },
              backgroundColor: AppTheme.mtnYellow,
              foregroundColor: AppTheme.black,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan'),
              elevation: 4,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
