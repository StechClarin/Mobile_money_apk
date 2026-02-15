import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/design_system/app_text_styles.dart';

class ConsoStatus extends StatelessWidget {
  const ConsoStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ma Ligne',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.stars, color: AppColors.accent, size: 12),
                      SizedBox(width: 4),
                      Text(
                        '1 240 MoMo Points',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.bar_chart, color: AppColors.primary, size: 20),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              // 1. Credit Balance (Electronic Money style)
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crédit',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.grey.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: '1 500',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColors.black,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: 'FCFA',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.mtnYellow,
                              fontFamily: 'Outfit',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Vertical Divider
              Container(
                height: 40,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                color: Colors.grey.withValues(alpha: 0.1),
              ),

              // 2. Data & Voice Indicators
              Expanded(
                flex: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildIndicator(context, 'Data', 0.7, Colors.purple, '3.5 Go'),
                    _buildIndicator(context, 'Voix', 0.4, Colors.blue, '25 Min'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(BuildContext context, String label, double value, Color color, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 48,
          width: 48,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: value,
                backgroundColor: color.withValues(alpha: 0.1),
                color: color,
                strokeWidth: 4,
                strokeCap: StrokeCap.round,
              ),
              Center(
                child: Text(
                  text.split(' ')[0],
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.grey.withValues(alpha: 0.8),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
