import 'package:flutter/material.dart';
import 'package:mobilemoney/core/design_system/app_colors.dart';
import 'package:mobilemoney/features/home/presentation/pages/tabs/boutique_tab.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.spotifyBlack,
      body: BoutiqueTab(isStandalonePage: true),
    );
  }
}
