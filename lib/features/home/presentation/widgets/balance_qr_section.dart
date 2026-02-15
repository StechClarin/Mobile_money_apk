import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_transitions.dart';
import '../../../../core/design_system/app_colors.dart';

class BalanceQrSection extends StatefulWidget {
  const BalanceQrSection({super.key});

  @override
  State<BalanceQrSection> createState() => _BalanceQrSectionState();
}

class _BalanceQrSectionState extends State<BalanceQrSection> with SingleTickerProviderStateMixin {
  bool _isBalanceVisible = true;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          // 1. Premium Balance Card
          GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) => _controller.reverse(),
            onTapCancel: () => _controller.reverse(),
            onTap: () {
              setState(() => _isBalanceVisible = !_isBalanceVisible);
            },
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  boxShadow: AppColors.softShadow,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Solde principal',
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _isBalanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: AppColors.black.withValues(alpha: 0.4),
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _isBalanceVisible ? '145 000 FCFA' : '•••••• FCFA',
                              key: ValueKey(_isBalanceVisible),
                              style: const TextStyle(
                                color: AppColors.black,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'Outfit',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // QR Code Small Card
                    GestureDetector(
                      onTap: () => _showZoomedQR(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: 'https://mobilemoney.mtn.cm',
                          version: QrVersions.auto,
                          size: 64.0,
                          eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.circle, color: AppColors.black),
                          dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.circle, color: AppColors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // 2. Modern Quick Actions Container
          // Container(
          //   padding: const EdgeInsets.all(20),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          //     boxShadow: AppColors.softShadow,
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       _buildQuickAction(Icons.qr_code_scanner, 'Scanner', Colors.blue),
          //       _buildQuickAction(Icons.account_balance_wallet_outlined, 'Dépôt', Colors.green),
          //       _buildQuickAction(Icons.payment_outlined, 'Paiement', Colors.orange),
          //       _buildQuickAction(Icons.more_horiz, 'Plus', AppColors.grey),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }

  void _showZoomedQR(BuildContext context) {
    AppTransitions.showAppDialog(
      context: context,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Mon Code QR',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 24),
              QrImageView(
                data: 'https://mobilemoney.mtn.cm',
                version: QrVersions.auto,
                size: 200.0,
                eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: AppColors.black),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Fermer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
