import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_transitions.dart';

class StaticQRCard extends StatelessWidget {
  const StaticQRCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content
        children: [
          GestureDetector(
            onTap: () => _showZoomedQR(context),
            child: QrImageView(
              data: 'https://mobilemoney.mtn.cm',
              version: QrVersions.auto,
              size: 100.0, // Reduced size significantly
            ),
          ),
          const SizedBox(height: AppSpacing.sm), // Reduced spacing
          SizedBox(
            height: 32, // Fixed small height for button
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined, color: AppTheme.black, size: 16),
              label: const Text(
                'Share', // Shortened text
                style: TextStyle(color: AppTheme.black, fontSize: 12),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
                  side: const BorderSide(color: Colors.black12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showZoomedQR(BuildContext context) {
    AppTransitions.showAppDialog(
      context: context,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'My QR Code',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.black,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              QrImageView(
                data: 'https://mobilemoney.mtn.cm',
                version: QrVersions.auto,
                size: 280.0, // Zoomed size
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(color: AppTheme.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
