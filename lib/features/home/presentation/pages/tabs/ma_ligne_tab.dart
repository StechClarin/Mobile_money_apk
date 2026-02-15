import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobilemoney/core/design_system/app_colors.dart';
import 'package:mobilemoney/core/theme/app_transitions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../widgets/conso_status.dart';
import '../../widgets/promo_carousel.dart';
import '../../../../shop/presentation/widgets/category_tabs.dart'; // Reusing existing widget
import '../../../domain/entities/promo_banner.dart';
import '../../../../bundles/domain/entities/bundle.dart';
import '../../../../bundles/presentation/manager/bundle_providers.dart';
import '../../../../bundles/presentation/widgets/bundle_card.dart';

class MaLigneTab extends ConsumerStatefulWidget {
  const MaLigneTab({super.key});

  @override
  ConsumerState<MaLigneTab> createState() => _MaLigneTabState();
}

class _MaLigneTabState extends ConsumerState<MaLigneTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final bundles = ref.watch(filteredBundlesProvider);
    final selectedType = ref.watch(selectedBundleCategoryProvider);
    final selectedDuration = ref.watch(selectedBundleDurationProvider);

    final categories = ['Tous', 'Internet', 'Appels', 'SMS', 'Maxi Mixte', 'Spéciaux', 'Oversize', 'VSD'];
    final durations = ['Tous', 'Illimité', '1j', '7j', '30j'];
    
    final selectedCategoryLabel = _getLabelFromType(selectedType);
    final selectedDurationLabel = _getLabelFromDuration(selectedDuration);

    return CustomScrollView(
      key: const PageStorageKey('MaLigneTab'),
      slivers: [
        SliverAppBar(
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          title: const Text(
            '677 00 00 00',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          pinned: true,
          elevation: 0,
        ),
        
        // 1. Consumption Status
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: ConsoStatus(),
          ),
        ),

        // 2. Special Offers Section
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, AppSpacing.sm),
          sliver: SliverToBoxAdapter(
            child: Text(
              'Offres Spéciales',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.black),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                children: [
                   _HeroOfferCard(
                      title: 'SOS', 
                      subtitle: 'Empruntez vos pass maintenant', 
                      icon: Icons.sos, 
                      color: Colors.red,
                      tag: 'sos_icon',
                      onTap: () => _showSOSSelection(context),
                   ),
                   _buildOfferCard(
                      context, 
                      'Illimité', 
                      'Pass Internet Illimité 24h', 
                      Icons.all_inclusive, 
                      Colors.blue,
                      onTap: () {},
                   ),
                   _buildOfferCard(
                      context, 
                      'Cadeau', 
                      'Offrez un forfait à un proche', 
                      Icons.card_giftcard, 
                      Colors.orange,
                      onTap: () {},
                   ),
                ],
              ),
            ),
          ),
        ),

        // 4. Promotional Carousel (Standard)
        SliverToBoxAdapter(
          child: PromoCarousel(
            banners: const [
              PromoBanner(id: 'n1', imageUrl: 'url_news_1', title: 'Nouveau Pass Giga'),
              PromoBanner(id: 'n2', imageUrl: 'url_news_2', title: 'Promotions de la Semaine'),
            ],
          ),
        ),
        
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSpacing.md),
        ),

        // 4. Category & Duration Filters
        SliverPersistentHeader(
          pinned: true,
          delegate: _SliverAppBarDelegate(
            minHeight: 110.0,
            maxHeight: 110.0,
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CategoryTabs(
                      categories: categories,
                      selectedCategory: selectedCategoryLabel,
                      onCategorySelected: (label) {
                        ref.read(selectedBundleCategoryProvider.notifier).state = _getTypeFromLabel(label);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: CategoryTabs(
                      categories: durations,
                      selectedCategory: selectedDurationLabel,
                      onCategorySelected: (label) {
                        ref.read(selectedBundleDurationProvider.notifier).state = _getDurationFromLabel(label);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // 5. Bundles Grid
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return BundleCard(
                  bundle: bundles[index],
                  onBuy: () => _showPlanDetails(context, bundles[index]),
                );
              },
              childCount: bundles.length,
            ),
          ),
        ),

        if (bundles.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(
              child: Text('Aucun forfait trouvé pour ces critères.'),
            ),
          ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 100), // Bottom padding for FAB/NavBar
        ),
      ],
    );
  }

  String _getLabelFromType(BundleType? type) {
    if (type == null) return 'Tous';
    switch (type) {
      case BundleType.internet: return 'Internet';
      case BundleType.call: return 'Appels';
      case BundleType.sms: return 'SMS';
      case BundleType.special: return 'Spéciaux';
      case BundleType.mixte: return 'Maxi Mixte';
      case BundleType.oversize: return 'Oversize';
      case BundleType.vsd: return 'VSD';
    }
  }

  BundleType? _getTypeFromLabel(String label) {
    switch (label) {
      case 'Internet': return BundleType.internet;
      case 'Appels': return BundleType.call;
      case 'SMS': return BundleType.sms;
      case 'Spéciaux': return BundleType.special;
      case 'Maxi Mixte': return BundleType.mixte;
      case 'Oversize': return BundleType.oversize;
      case 'VSD': return BundleType.vsd;
      default: return null;
    }
  }

  String _getLabelFromDuration(String? duration) {
    if (duration == null) return 'Tous';
    switch (duration) {
      case 'illimite': return 'Illimité';
      default: return duration;
    }
  }

  String? _getDurationFromLabel(String label) {
    switch (label) {
      case 'Illimité': return 'illimite';
      case '1j': return '1j';
      case '7j': return '7j';
      case '30j': return '30j';
      default: return null;
    }
  }

  void _showPlanDetails(BuildContext context, Bundle bundle) {
    AppTransitions.showAppBottomSheet(
      context: context,
      child: _PlanDetailsSheet(bundle: bundle),
    );
  }


  void _showSOSSelection(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black54,
        pageBuilder: (context, animation, secondaryAnimation) => const _SOSSelectionSheet(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutQuart;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Widget _buildOfferCard(BuildContext context, String title, String subtitle, IconData icon, Color color, {required VoidCallback onTap}) {
    return _HeroOfferCard(title: title, subtitle: subtitle, icon: icon, color: color, onTap: onTap);
  }
}

class _HeroOfferCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? tag;

  const _HeroOfferCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.tag,
  });

  @override
  State<_HeroOfferCard> createState() => _HeroOfferCardState();
}

class _HeroOfferCardState extends State<_HeroOfferCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
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
        child: Container(
          width: 140,
          margin: const EdgeInsets.only(right: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: widget.color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: widget.tag != null 
                  ? Hero(tag: widget.tag!, child: Icon(widget.icon, color: widget.color, size: 24))
                  : Icon(widget.icon, color: widget.color, size: 24),
              ),
              const Spacer(),
              Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(widget.subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }
}

class _SOSSelectionSheet extends StatefulWidget {
  const _SOSSelectionSheet();

  @override
  State<_SOSSelectionSheet> createState() => _SOSSelectionSheetState();
}

class _SOSSelectionSheetState extends State<_SOSSelectionSheet> {
  String _selectedCategory = 'Internet'; // 'Internet', 'Voix', 'SMS'
  final List<int> _creditAmounts = [300, 500, 1000, 1500, 2000, 3000, 5000];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        behavior: HitTestBehavior.opaque,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // Prevent dismissal when tapping the sheet itself
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Hero(
                          tag: 'sos_icon',
                          child: Icon(Icons.sos, color: Colors.red, size: 28),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'SOS Emprunt',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Besoin d\'un coup de pouce ? Empruntez maintenant.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 32),
                    
                    // 1. Section: Emprunter du crédit
                    const Text(
                      'Emprunter du crédit',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _creditAmounts.map((amount) => _buildCreditButton(amount)).toList(),
                    ),
                    const SizedBox(height: 40),
                    
                    // 2. Section: Emprunter un pass
                    const Text(
                      'Emprunter un pass',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    
                    // Category Filter
                    Row(
                      children: ['Internet', 'Voix', 'SMS'].map((cat) => _buildCategoryChip(cat)).toList(),
                    ),
                    const SizedBox(height: 20),
                    
                    // Pass List based on category
                    SizedBox(
                      height: 130,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _getSOSPassesForCategory(_selectedCategory),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreditButton(int amount) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        _showConfirmationDialog(amount.toString());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Text(
          '$amount FCFA',
          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.black),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = category),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.mtnYellow : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.mtnYellow : Colors.grey.shade300),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: AppTheme.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  List<Widget> _getSOSPassesForCategory(String category) {
    // Mocking SOS passes based on category
    if (category == 'Internet') {
      return [
        _buildSOSCard('SOS Internet S', '100 MB', '300 FCFA'),
        _buildSOSCard('SOS Internet M', '500 MB', '1000 FCFA'),
        _buildSOSCard('SOS Internet L', '2 GB', '2500 FCFA'),
      ];
    } else if (category == 'Voix') {
      return [
        _buildSOSCard('SOS Voix S', '5 min', '200 FCFA'),
        _buildSOSCard('SOS Voix M', '15 min', '500 FCFA'),
        _buildSOSCard('SOS Voix L', '60 min', '1500 FCFA'),
      ];
    } else {
      return [
        _buildSOSCard('SOS SMS S', '20 SMS', '100 FCFA'),
        _buildSOSCard('SOS SMS M', '100 SMS', '400 FCFA'),
      ];
    }
  }

  Widget _buildSOSCard(String title, String desc, String price) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _showConfirmationDialog(title);
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.withValues(alpha: 0.1)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 13)),
            const Spacer(),
            Text(desc, style: const TextStyle(fontSize: 11)),
            const SizedBox(height: 4),
            Text(price, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(String item) {
    AppTransitions.showAppDialog(
      context: context,
      child: AlertDialog(
        title: const Text('Confirmation SOS'),
        content: Text('Voulez-vous emprunter "$item" ? Montant à rembourser lors de votre prochaine recharge.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Emprunt de "$item" réussi !'), backgroundColor: Colors.green),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.mtnYellow, foregroundColor: AppTheme.black),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }
}

class _PlanDetailsSheet extends StatefulWidget {
  final Bundle bundle;
  const _PlanDetailsSheet({required this.bundle});

  @override
  State<_PlanDetailsSheet> createState() => _PlanDetailsSheetState();
}

class _PlanDetailsSheetState extends State<_PlanDetailsSheet> {
  String _paymentMethod = 'credit'; // 'credit' or 'momo'

  @override
  Widget build(BuildContext context) {
    final bundle = widget.bundle;
    
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    bundle.type == BundleType.internet ? Icons.wifi : bundle.type == BundleType.call ? Icons.call : Icons.layers,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bundle.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.black),
                      ),
                      Text(
                        bundle.validity,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${bundle.price.toInt()} FCFA',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.black),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Details
            const Text('Détails du forfait', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.data_usage, 'Data', bundle.dataAmount ?? '0 MB'),
            _buildDetailRow(Icons.timer, 'Validité', bundle.validity),
            if (bundle.minutesAmount != null)
              _buildDetailRow(Icons.phone_in_talk, 'Appels', bundle.minutesAmount!),
              
            const SizedBox(height: 32),
            
            // Payment Method
            const Text('Mode de paiement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPaymentOption(
                    id: 'credit',
                    title: 'Crédit',
                    subtitle: 'Solde principal',
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPaymentOption(
                    id: 'momo',
                    title: 'MoMo',
                    subtitle: 'Mobile Money',
                    icon: Icons.payments_outlined,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Confirmation Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Achat de "${bundle.name}" via $_paymentMethod réussi !'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.mtnYellow,
                  foregroundColor: AppTheme.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Acheter maintenant', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade400),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _paymentMethod == id;
    return InkWell(
      onTap: () => setState(() => _paymentMethod = id),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.mtnYellow.withValues(alpha: 0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.mtnYellow : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppTheme.black : Colors.grey),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
