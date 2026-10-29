import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilemoney/core/design_system/app_colors.dart';
import 'package:mobilemoney/features/shop/presentation/manager/shop_providers.dart';

class ShopSearchBar extends ConsumerWidget {
  const ShopSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.spotifyCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 14),
        onChanged: (value) {
          ref.read(searchQueryProvider.notifier).state = value;
        },
        decoration: InputDecoration(
          hintText: 'Rechercher un terminal, accessoire...',
          hintStyle: GoogleFonts.plusJakartaSans(
            color: AppColors.spotifyGrey,
            fontSize: 14,
          ),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.monarchPurpleNeon),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
    );
  }
}

