import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  final ValueNotifier<bool> _isBalanceVisible = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm, // Reduced padding
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Ensure minimum height
        children: [
           // Top Row: Greeting & QR Code
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Good Morning,',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const Text(
                    'Yello User!',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.black,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => _showZoomedQR(context),
                child: Container(
                   padding: const EdgeInsets.all(8),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(12),
                     border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.black.withValues(alpha: 0.1),
                         blurRadius: 8,
                         offset: const Offset(0, 2),
                       ),
                     ],
                   ),
                  child: QrImageView(
                    data: 'https://mobilemoney.mtn.cm',
                    version: QrVersions.auto,
                    size: 90.0,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: AppSpacing.md),
          
          // Balance Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: AppTheme.mtnYellow,
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.mtnYellow,
                  Color.lerp(AppTheme.mtnYellow, Colors.orange, 0.2)!,
                ],
              ),
              boxShadow: [
                // "Oil Painting" style layers of shadow for softness and depth
                BoxShadow(
                  color: AppTheme.mtnYellow.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: -5,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isBalanceVisible,
                      builder: (context, isVisible, child) {
                        return AnimatedCrossFade(
                          firstChild: const Text(
                            '2,500,000 FCFA',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.black,
                              letterSpacing: -0.5,
                            ),
                          ),
                          secondChild: const Text(
                            '•••••••••••••',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.black,
                              letterSpacing: 2,
                            ),
                          ),
                          crossFadeState: isVisible
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                   decoration: BoxDecoration(
                     color: Colors.black.withValues(alpha: 0.05),
                     shape: BoxShape.circle,
                   ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: ValueListenableBuilder<bool>(
                      valueListenable: _isBalanceVisible,
                      builder: (context, isVisible, child) {
                        return Icon(
                          isVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppTheme.black,
                          size: 22,
                        );
                      },
                    ),
                    onPressed: () {
                      _isBalanceVisible.value = !_isBalanceVisible.value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showZoomedQR(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
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
              const SizedBox(height: 16),
              QrImageView(
                data: 'https://mobilemoney.mtn.cm',
                version: QrVersions.auto,
                size: 250.0,
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close', style: TextStyle(color: AppTheme.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
