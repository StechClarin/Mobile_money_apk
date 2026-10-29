import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../../../core/constants.dart';

class MomoServiceTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const MomoServiceTile({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  State<MomoServiceTile> createState() => _MomoServiceTileState();
}

class _MomoServiceTileState extends State<MomoServiceTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
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
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.spotifyCard,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF282828), width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(widget.icon, color: widget.color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServicesGrid extends StatelessWidget {
  const ServicesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    // Services list updated for pure money transactions & shop
    final services = [
      {
        'title': 'Envoi Argent',
        'icon': Icons.send_rounded,
        'color': AppColors.monarchPurpleNeon,
        'action': () => context.push(AppRoutes.recipientSelection),
      },
      {
        'title': 'Boutique',
        'icon': Icons.shopping_bag_outlined,
        'color': Colors.orangeAccent,
        'action': () => context.push(AppRoutes.shop),
      },
      {
        'title': 'Cartes',
        'icon': Icons.credit_card_rounded,
        'color': Colors.purpleAccent,
        'action': () => context.push(AppRoutes.cards),
      },
      {
        'title': 'Coffre',
        'icon': Icons.shield_rounded,
        'color': const Color(0xFFF59E0B), // Warm Gold
        'action': () => _showVaultSheet(context),
      },
      {
        'title': 'Paiement',
        'icon': Icons.storefront_outlined,
        'color': Colors.amberAccent,
        'action': () => context.push(AppRoutes.payment),
      },
      {
        'title': 'Cadeaux',
        'icon': Icons.card_giftcard_rounded,
        'color': const Color(0xFFEC4899), // Neon Pink festive
        'action': () => _showGiftSheet(context),
      },
      {
        'title': 'Transport',
        'icon': Icons.directions_bus_rounded,
        'color': const Color(0xFF00E5FF), // Electric Cyan
        'action': () => _showTransportSheet(context),
      },
      {
        'title': 'Historique',
        'icon': Icons.receipt_long_rounded,
        'color': AppColors.spotifyGrey,
        'action': () => context.push(AppRoutes.transactions),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        0,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 24,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.65,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return MomoServiceTile(
          title: service['title'] as String,
          icon: service['icon'] as IconData,
          color: service['color'] as Color,
          onTap: service['action'] as VoidCallback,
        );
      },
    );
  }

  void _showGiftSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.spotifyCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEC4899).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.card_giftcard_rounded, color: Color(0xFFEC4899), size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Envoyer un Cadeau Walliss',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Envoyez de l\'argent avec une enveloppe animée et un mot personnalisé pour faire plaisir à vos proches.',
                style: TextStyle(color: AppColors.spotifyGrey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.recipientSelection);
                },
                icon: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
                label: const Text('Choisir le bénéficiaire', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEC4899),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showTransportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.spotifyCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E5FF).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.directions_bus_rounded, color: Color(0xFF00E5FF), size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Paiement Transport',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Réglez vos trajets en toute simplicité (Bus interurbains, Taxis, TER, Covoiturage certifié).',
                style: TextStyle(color: AppColors.spotifyGrey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  context.push(
                    AppRoutes.payment,
                    extra: {'name': 'Agence de Voyage Express', 'number': '699 00 11 22'},
                  );
                },
                icon: const Icon(Icons.confirmation_number_outlined, color: Colors.black, size: 20),
                label: const Text('Acheter un billet de transport', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00E5FF),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _showVaultSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.spotifyCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_rounded, color: Color(0xFFF59E0B), size: 26),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Coffre-fort Sécurisé',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.spotifyBlack,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF282828)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Solde Verrouillé', style: TextStyle(color: AppColors.spotifyGrey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '350 000 FCFA',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1DB954).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            '+5.5% / an',
                            style: TextStyle(color: Color(0xFF1DB954), fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Mettez votre argent à l\'abri des dépenses impulsives et générez des rendements garantis quotidiens.',
                style: TextStyle(color: AppColors.spotifyGrey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.lock_outline_rounded, color: Colors.black, size: 20),
                label: const Text('Déposer dans le coffre', style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

