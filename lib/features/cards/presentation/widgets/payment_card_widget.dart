import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../domain/entities/card_model.dart';

class PaymentCardWidget extends StatelessWidget {
  final PaymentCard card;
  final bool isCompact;
  final VoidCallback? onTap;

  const PaymentCardWidget({
    super.key,
    required this.card,
    this.isCompact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCompact ? 300 : double.infinity,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: card.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.8],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: card.gradientColors.first.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Noise/Texture Overlay (Subtle)
            Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: Image.network(
                  'https://www.transparenttextures.com/patterns/carbon-fibre.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const SizedBox(),
                ),
              ),
            ),
            
            // Glassmorphism highlight
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            // Content
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           _buildBrandLogo(),
                          const Icon(Icons.contactless_outlined, color: Colors.white, size: 28),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Chip Icon
                      Container(
                        width: 45,
                        height: 35,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.yellow.shade700,
                              Colors.yellow.shade200,
                              Colors.yellow.shade800,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: CustomPaint(
                          painter: ChipPainter(),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        card.cardNumber,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          letterSpacing: 3,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Outfit',
                          shadows: [
                            Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CARD HOLDER',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                card.holderName.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'EXPIRES',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                card.expiryDate,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Outfit',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandLogo() {
    switch (card.type) {
      case PaymentCardType.visa:
        return const Text(
          'VISA',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            fontFamily: 'Outfit',
          ),
        );
      case PaymentCardType.mastercard:
         return SizedBox(
           width: 50,
           height: 30,
           child: Stack(
             children: [
               Container(
                 width: 30,
                 height: 30,
                 decoration: BoxDecoration(
                   color: Colors.red.withValues(alpha: 0.9),
                   shape: BoxShape.circle,
                 ),
               ),
               Positioned(
                 left: 18,
                 child: Container(
                   width: 30,
                   height: 30,
                   decoration: BoxDecoration(
                     color: Colors.orange.withValues(alpha: 0.9),
                     shape: BoxShape.circle,
                   ),
                 ),
               ),
             ],
           ),
         );
      case PaymentCardType.momo:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.mtnYellow,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Text(
            'MoMo',
            style: TextStyle(
              color: AppTheme.black,
              fontWeight: FontWeight.w900,
              fontSize: 14,
              fontFamily: 'Outfit',
            ),
          ),
        );
    }
  }
}

class ChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black26
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (var i = 1; i < 4; i++) {
      canvas.drawLine(Offset(size.width * i / 4, 0), Offset(size.width * i / 4, size.height), paint);
      canvas.drawLine(Offset(0, size.height * i / 4), Offset(size.width, size.height * i / 4), paint);
    }
    
    final rrect = RRect.fromLTRBR(size.width * 0.2, size.height * 0.2, size.width * 0.8, size.height * 0.8, const Radius.circular(2));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
