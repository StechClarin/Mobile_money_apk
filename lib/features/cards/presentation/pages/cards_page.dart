import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/design_system/app_colors.dart';
import '../../domain/entities/card_model.dart';
import '../widgets/payment_card_widget.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedFilter = 0; // 0: All, 1: Virtual, 2: Physical
  bool _obscureNumbers = true;

  // Mock FinTech Cards
  late List<PaymentCard> _allCards;

  @override
  void initState() {
    super.initState();
    _allCards = [
      const PaymentCard(
        id: '1',
        cardName: 'Walliss Shadow Monarch',
        cardNumber: '•••• •••• •••• 9412',
        holderName: 'Clarin S.',
        expiryDate: '09/29',
        type: PaymentCardType.walliss,
        balance: 450000,
        gradientColors: [
          Color(0xFF0F0B1E),
          Color(0xFF2A085C),
          Color(0xFF6B21A8),
        ],
        cvv: '742',
        isVirtual: true,
        isFrozen: false,
      ),
      const PaymentCard(
        id: '2',
        cardName: 'Walliss Obsidian Black',
        cardNumber: '•••• •••• •••• 3180',
        holderName: 'Clarin S.',
        expiryDate: '12/28',
        type: PaymentCardType.visa,
        balance: 1850000,
        gradientColors: [
          Color(0xFF141414),
          Color(0xFF242424),
          Color(0xFF0A0A0A),
        ],
        cvv: '519',
        isVirtual: false,
        isFrozen: false,
      ),
      const PaymentCard(
        id: '3',
        cardName: 'Walliss Cyber Edition',
        cardNumber: '•••• •••• •••• 6204',
        holderName: 'Clarin S.',
        expiryDate: '04/30',
        type: PaymentCardType.mastercard,
        balance: 125000,
        gradientColors: [
          Color(0xFF0D1B2A),
          Color(0xFF1B263B),
          Color(0xFF415A77),
        ],
        cvv: '931',
        isVirtual: true,
        isFrozen: false,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PaymentCard> get _filteredCards {
    return _allCards.where((card) {
      if (_selectedFilter == 1 && !card.isVirtual) return false;
      if (_selectedFilter == 2 && card.isVirtual) return false;
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        return card.cardName.toLowerCase().contains(query) ||
            card.cardNumber.contains(query) ||
            card.holderName.toLowerCase().contains(query);
      }
      return true;
    }).toList();
  }

  void _toggleFreeze(PaymentCard card) {
    setState(() {
      final index = _allCards.indexWhere((c) => c.id == card.id);
      if (index != -1) {
        final updated = _allCards[index].copyWith(isFrozen: !_allCards[index].isFrozen);
        _allCards[index] = updated;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          card.isFrozen ? 'Carte ${card.cardName} dégelée' : 'Carte ${card.cardName} gelée',
          style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.spotifyElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCards;

    return Scaffold(
      backgroundColor: AppColors.spotifyBlack,
      appBar: AppBar(
        backgroundColor: AppColors.spotifyBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Mes Cartes Walliss',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Masquer/Afficher numéros',
            icon: Icon(
              _obscureNumbers ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.monarchPurpleNeon,
            ),
            onPressed: () {
              setState(() {
                _obscureNumbers = !_obscureNumbers;
              });
            },
          ),
          IconButton(
            tooltip: 'Ajouter une carte',
            icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white),
            onPressed: () => _showCreateCardDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.spotifyCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
              child: TextField(
                controller: _searchController,
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 14),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Rechercher une carte...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    color: AppColors.spotifyGrey,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, color: AppColors.monarchPurpleNeon),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),

          // 2. Filter Pills
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildFilterChip(0, 'Toutes (${_allCards.length})'),
                const SizedBox(width: 8),
                _buildFilterChip(1, 'Virtuelles (${_allCards.where((c) => c.isVirtual).length})'),
                const SizedBox(width: 8),
                _buildFilterChip(2, 'Physiques (${_allCards.where((c) => !c.isVirtual).length})'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 3. Cards List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'Aucune carte trouvée',
                      style: GoogleFonts.plusJakartaSans(color: AppColors.spotifyGrey),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      final card = filtered[index];
                      final displayCard = _obscureNumbers
                          ? card
                          : card.copyWith(
                              cardNumber: card.cardNumber.replaceAll('•••• •••• ••••', '4125 8920 6734'),
                            );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PaymentCardWidget(
                            card: displayCard,
                            onTap: () => _showCardDetails(context, card),
                          ),
                          const SizedBox(height: 12),
                          // Card Quick Actions
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppColors.spotifyCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildCardActionItem(
                                  icon: card.isFrozen ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
                                  label: card.isFrozen ? 'Dégeler' : 'Geler',
                                  color: card.isFrozen ? AppColors.monarchPurpleNeon : Colors.white70,
                                  onTap: () => _toggleFreeze(card),
                                ),
                                Container(width: 1, height: 24, color: Colors.white10),
                                _buildCardActionItem(
                                  icon: Icons.info_outline_rounded,
                                  label: 'Détails',
                                  color: Colors.white70,
                                  onTap: () => _showCardDetails(context, card),
                                ),
                                Container(width: 1, height: 24, color: Colors.white10),
                                _buildCardActionItem(
                                  icon: Icons.account_balance_wallet_outlined,
                                  label: '${card.balance.toInt()} F',
                                  color: AppColors.monarchPurpleNeon,
                                  onTap: () => _showTopUpDialog(context, card),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int index, String label) {
    final isSelected = _selectedFilter == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.monarchPurple : AppColors.spotifyCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.monarchPurpleNeon : Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: isSelected ? Colors.white : AppColors.spotifyGrey,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildCardActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCardDetails(BuildContext context, PaymentCard card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.spotifyCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
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
                        card.cardName,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        card.isVirtual ? 'Carte Virtuelle Sécurisée' : 'Carte Physique Contactless',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.spotifyGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: card.isFrozen
                          ? Colors.red.withValues(alpha: 0.2)
                          : Colors.green.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      card.isFrozen ? 'GELÉE' : 'ACTIVE',
                      style: GoogleFonts.plusJakartaSans(
                        color: card.isFrozen ? Colors.redAccent : Colors.greenAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildDetailTile(
                Icons.credit_card_rounded,
                'Numéro de carte',
                '4125 8920 6734 ${card.cardNumber.replaceAll('•••• •••• •••• ', '')}',
                canCopy: true,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailTile(
                      Icons.calendar_today_rounded,
                      'Date d\'expiration',
                      card.expiryDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDetailTile(
                      Icons.shield_rounded,
                      'Cryptogramme (CVV)',
                      card.cvv,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildDetailTile(
                Icons.account_balance_wallet_rounded,
                'Solde disponible',
                '${card.balance.toInt()} FCFA',
                isHighlight: true,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.spotifyElevated,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Fermer',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailTile(IconData icon, String label, String value, {bool canCopy = false, bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.spotifyElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isHighlight
              ? AppColors.monarchPurpleNeon.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.04),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isHighlight ? AppColors.monarchPurpleNeon : AppColors.spotifyGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.spotifyGrey,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.plusJakartaSans(
                    color: isHighlight ? AppColors.monarchPurpleNeon : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          if (canCopy)
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.monarchPurpleNeon),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value.replaceAll(' ', '')));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Numéro de carte copié',
                      style: GoogleFonts.plusJakartaSans(color: Colors.white),
                    ),
                    backgroundColor: AppColors.spotifyElevated,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  void _showTopUpDialog(BuildContext context, PaymentCard card) {
    final amountController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.spotifyCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Recharger la carte',
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Transférez des fonds depuis votre solde Walliss vers votre ${card.cardName}.',
                style: GoogleFonts.plusJakartaSans(color: AppColors.spotifyGrey, fontSize: 13),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: 'Montant en FCFA',
                  hintStyle: GoogleFonts.plusJakartaSans(color: AppColors.spotifyGrey),
                  suffixText: 'FCFA',
                  suffixStyle: GoogleFonts.plusJakartaSans(color: AppColors.monarchPurpleNeon),
                  filled: true,
                  fillColor: AppColors.spotifyElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Annuler', style: GoogleFonts.plusJakartaSans(color: AppColors.spotifyGrey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.monarchPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0;
                if (amount > 0) {
                  setState(() {
                    final index = _allCards.indexWhere((c) => c.id == card.id);
                    if (index != -1) {
                      _allCards[index] = _allCards[index].copyWith(balance: _allCards[index].balance + amount);
                    }
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Carte rechargée avec succès de ${amount.toInt()} FCFA'),
                      backgroundColor: AppColors.spotifyElevated,
                    ),
                  );
                }
              },
              child: Text('Confirmer', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showCreateCardDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.spotifyCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Créer une nouvelle carte',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Générez instantanément une carte virtuelle internationale Walliss.',
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.spotifyGrey,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 24),
              _buildNewCardOption(
                title: 'Carte Virtuelle Shadow Monarch',
                subtitle: 'Paiements en ligne sécurisés & sans frais cachés',
                icon: Icons.bolt_rounded,
                isRecommended: true,
                onTap: () {
                  setState(() {
                    _allCards.insert(
                      0,
                      PaymentCard(
                        id: '${DateTime.now().millisecondsSinceEpoch}',
                        cardName: 'Walliss Ultra Virtual',
                        cardNumber: '•••• •••• •••• ${1000 + _allCards.length}',
                        holderName: 'Clarin S.',
                        expiryDate: '10/31',
                        type: PaymentCardType.walliss,
                        balance: 50000,
                        gradientColors: const [
                          Color(0xFF1E1035),
                          Color(0xFF3B0764),
                          Color(0xFF7E22CE),
                        ],
                        cvv: '912',
                        isVirtual: true,
                        isFrozen: false,
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Nouvelle carte virtuelle Walliss générée !',
                        style: GoogleFonts.plusJakartaSans(color: Colors.white),
                      ),
                      backgroundColor: AppColors.spotifyElevated,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNewCardOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isRecommended,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.spotifyElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isRecommended
                ? AppColors.monarchPurpleNeon.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                gradient: AppColors.monarchGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.spotifyGrey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.spotifyGrey),
          ],
        ),
      ),
    );
  }
}

