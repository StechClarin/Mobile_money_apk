import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobilemoney/core/constants.dart';
import 'package:mobilemoney/core/design_system/app_colors.dart';
import 'package:mobilemoney/features/shop/domain/entities/product.dart';
import 'package:mobilemoney/features/shop/domain/entities/product_variant.dart';
import 'package:mobilemoney/features/shop/presentation/manager/shop_providers.dart';
import 'package:mobilemoney/features/shop/presentation/utils/icon_mapper.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final Product product;

  const ProductDetailPage({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  int _quantity = 1;
  late final PageController _imagePageController;
  int _currentImageIndex = 0;
  late ProductVariant _selectedVariant;

  final List<Map<String, dynamic>> _defaultAngles = [
    {'title': 'Vue Principale', 'iconSuffix': Icons.view_in_ar_rounded},
    {'title': 'Angle 3D Profil', 'iconSuffix': Icons.threed_rotation_rounded},
    {'title': 'Connectiques & Ports', 'iconSuffix': Icons.settings_input_composite_rounded},
    {'title': 'Pack & Accessoires', 'iconSuffix': Icons.inventory_2_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _imagePageController = PageController();
    final variants = widget.product.allVariants;
    _selectedVariant = variants.isNotEmpty
        ? variants.first
        : ProductVariant(
            id: '${widget.product.id}_def',
            name: 'Standard',
            price: widget.product.price,
            originalPrice: widget.product.originalPrice,
          );
  }

  @override
  void didUpdateWidget(covariant ProductDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      final variants = widget.product.allVariants;
      _selectedVariant = variants.isNotEmpty
          ? variants.first
          : ProductVariant(
              id: '${widget.product.id}_def',
              name: 'Standard',
              price: widget.product.price,
              originalPrice: widget.product.originalPrice,
            );
    }
  }

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final variants = product.allVariants;
    final currentPrice = _selectedVariant.price;
    final currentOriginalPrice = _selectedVariant.originalPrice ?? product.originalPrice;
    final currentDiscount = _selectedVariant.discountPercentage ?? product.discountPercentage;
    final currentStock = _selectedVariant.stock;

    final isFavorite = ref.watch(wishlistProvider).contains(product.id);
    final cartCount = ref.watch(cartProvider).length;
    final allProductsAsync = ref.watch(productsProvider);
    final galleryImages = product.allImages;

    return Scaffold(
      backgroundColor: AppColors.spotifyBlack,
      body: CustomScrollView(
        slivers: [
          // 1. Sleek SliverAppBar with Swipeable Multi-Image Gallery
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: AppColors.spotifyBlack,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.spotifyBlack.withValues(alpha: 0.75),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white12),
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.spotifyBlack.withValues(alpha: 0.75),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Icon(
                    isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: isFavorite ? const Color(0xFFEF4444) : Colors.white,
                    size: 20,
                  ),
                ),
                onPressed: () {
                  ref.read(wishlistProvider.notifier).toggleFavorite(product.id);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Badge(
                  label: Text('$cartCount'),
                  isLabelVisible: cartCount > 0,
                  backgroundColor: AppColors.monarchPurpleNeon,
                  textColor: Colors.white,
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.spotifyBlack.withValues(alpha: 0.75),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white12),
                      ),
                      child: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
                    ),
                    onPressed: () => context.push(AppRoutes.cart),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Subtle Radial Glow
                  Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.2),
                        radius: 0.9,
                        colors: [
                          AppColors.monarchPurpleDeep.withValues(alpha: 0.35),
                          AppColors.spotifyCard,
                          AppColors.spotifyBlack,
                        ],
                      ),
                    ),
                  ),

                  // Horizontal Scrollable / Swipeable Images Gallery (PageView)
                  Positioned.fill(
                    bottom: 70,
                    child: PageView.builder(
                      controller: _imagePageController,
                      itemCount: galleryImages.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final angleInfo = _defaultAngles[index % _defaultAngles.length];
                        final isFirst = index == 0;

                        return Center(
                          child: Hero(
                            tag: isFirst ? 'product_icon_${product.id}' : 'product_icon_${product.id}_$index',
                            child: Container(
                              width: 170,
                              height: 170,
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.spotifyElevated,
                                border: Border.all(
                                  color: AppColors.monarchPurpleNeon.withValues(alpha: 0.35),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.monarchPurple.withValues(alpha: 0.35),
                                    blurRadius: 32,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Transform.rotate(
                                    angle: index * 0.15,
                                    child: Icon(
                                      IconMapper.getIcon(product.icon),
                                      size: 82,
                                      color: AppColors.monarchPurpleNeon,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.spotifyBlack.withValues(alpha: 0.8),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.white12),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(angleInfo['iconSuffix'] as IconData, size: 11, color: AppColors.monarchCyan),
                                          const SizedBox(width: 4),
                                          Text(
                                            angleInfo['title'] as String,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: Colors.white70,
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Floating Image Counter Badge (Top-Right under actions)
                  Positioned(
                    top: 90,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.spotifyBlack.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.photo_library_outlined, size: 12, color: AppColors.monarchPurpleNeon),
                          const SizedBox(width: 5),
                          Text(
                            '${_currentImageIndex + 1} / ${galleryImages.length}',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tag Badge if present (Bottom-Left)
                  if (product.tag != null)
                    Positioned(
                      top: 90,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: AppColors.monarchGradient,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.monarchPurple.withValues(alpha: 0.4),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Text(
                          product.tag!,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),

                  // Bottom Thumbnails Scrollable Bar & Dots
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Horizontal thumbnails strip
                        SizedBox(
                          height: 48,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: galleryImages.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final isSelected = index == _currentImageIndex;
                              return GestureDetector(
                                onTap: () {
                                  _imagePageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.spotifyElevated,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected ? AppColors.monarchPurpleNeon : Colors.white12,
                                      width: isSelected ? 2 : 1,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: AppColors.monarchPurple.withValues(alpha: 0.4),
                                              blurRadius: 8,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Center(
                                    child: Transform.rotate(
                                      angle: index * 0.15,
                                      child: Icon(
                                        IconMapper.getIcon(product.icon),
                                        size: 22,
                                        color: isSelected ? AppColors.monarchPurpleNeon : Colors.white60,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),


          // 2. Main Product Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category & Brand
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.category.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.monarchPurpleNeon,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$currentStock en stock',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.greenAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Product Name
                  Text(
                    product.name,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Rating & Reviews Count
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: Color(0xFFF59E0B)),
                            const SizedBox(width: 4),
                            Text(
                              product.rating.toStringAsFixed(1),
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFF59E0B),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '(${product.reviewCount} avis vérifiés)',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.spotifyGrey,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.verified_rounded, size: 16, color: AppColors.monarchCyan),
                      const SizedBox(width: 4),
                      Text(
                        'Certifié Walliss',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.monarchCyan,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Variantes / Options du Produit (Impactant le prix)
                  if (variants.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.tune_rounded, size: 16, color: AppColors.monarchPurpleNeon),
                        const SizedBox(width: 8),
                        Text(
                          product.effectiveVariantTitle,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.monarchPurple.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.monarchPurpleNeon.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            _selectedVariant.name,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.monarchPurpleNeon,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                      children: variants.map((variant) {
                        final isSelected = variant.id == _selectedVariant.id;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedVariant = variant;
                                if (_quantity > variant.stock) {
                                  _quantity = variant.stock > 0 ? variant.stock : 1;
                                }
                              });
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.spotifyElevated : AppColors.spotifyCard,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isSelected ? AppColors.monarchPurpleNeon : Colors.white.withValues(alpha: 0.08),
                                  width: isSelected ? 1.8 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.monarchPurple.withValues(alpha: 0.25),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  // Radio / Check indicator
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected ? AppColors.monarchPurpleNeon : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected ? AppColors.monarchPurpleNeon : Colors.white38,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 12),

                                  // Variant Details (Name & optional description)
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                variant.name,
                                                style: GoogleFonts.plusJakartaSans(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            if (variant.badge != null) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  gradient: AppColors.monarchGradient,
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  variant.badge!,
                                                  style: GoogleFonts.plusJakartaSans(
                                                    color: Colors.white,
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        if (variant.description != null) ...[
                                          const SizedBox(height: 3),
                                          Text(
                                            variant.description!,
                                            style: GoogleFonts.plusJakartaSans(
                                              color: isSelected ? Colors.white70 : AppColors.spotifyGrey,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // Variant Price tag
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${variant.price.toInt()} F',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: isSelected ? AppColors.monarchPurpleNeon : Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      if (variant.originalPrice != null)
                                        Text(
                                          '${variant.originalPrice!.toInt()} F',
                                          style: GoogleFonts.plusJakartaSans(
                                            color: AppColors.spotifyGrey,
                                            fontSize: 10,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],

                  // Price Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.spotifyCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${currentPrice.toInt()} FCFA',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.monarchPurpleNeon,
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            if (currentOriginalPrice != null) ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    '${currentOriginalPrice.toInt()} FCFA',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppColors.spotifyGrey,
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (currentDiscount != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '-$currentDiscount%',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: const Color(0xFFEF4444),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ],
                        ),
                        const Spacer(),

                        // Quantity Selector
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.spotifyElevated,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, size: 16, color: Colors.white),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                onPressed: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  '$_quantity',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                onPressed: () {
                                  if (_quantity < currentStock) {
                                    setState(() => _quantity++);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Trust Perks (Jumia / Alibaba style)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.spotifyCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                    child: Column(
                      children: [
                        _buildPerkRow(Icons.local_shipping_outlined, 'Livraison Express Walliss', 'Reçu chez vous en 24h à 48h'),
                        const Divider(color: Colors.white10, height: 16),
                        _buildPerkRow(Icons.verified_user_outlined, 'Garantie Marchande 12 Mois', 'Échange ou remboursement certifié'),
                        const Divider(color: Colors.white10, height: 16),
                        _buildPerkRow(Icons.credit_card_outlined, 'Paiement Sécurisé Walliss', 'Protection des fonds jusqu\'à livraison'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Specifications Section
                  if (product.specs.isNotEmpty) ...[
                    Text(
                      'Caractéristiques Principales',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.specs.map((spec) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.spotifyElevated,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: AppColors.monarchPurpleNeon.withValues(alpha: 0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.monarchPurpleNeon),
                              const SizedBox(width: 6),
                              Text(
                                spec,
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Description
                  Text(
                    'Description du Produit',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.spotifyGrey,
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Related Products Section
                  Text(
                    'Produits Similaires Recommandés',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),

                  allProductsAsync.when(
                    data: (products) {
                      final related = products.where((p) => p.id != product.id && p.category == product.category).toList();
                      final displayList = related.isNotEmpty ? related : products.where((p) => p.id != product.id).take(6).toList();

                      return SizedBox(
                        height: 170,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: displayList.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = displayList[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailPage(product: item),
                                  ),
                                );
                              },
                              child: Container(
                                width: 140,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppColors.spotifyCard,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: AppColors.spotifyElevated,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          IconMapper.getIcon(item.icon),
                                          size: 32,
                                          color: AppColors.monarchPurpleNeon,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${item.price.toInt()} F',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.monarchPurpleNeon,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, _) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. Bottom Sticky Checkout / Add to Cart Bar
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: BoxDecoration(
          color: AppColors.spotifyCard,
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Add to cart button
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      final variantProduct = product.copyWith(
                        id: '${product.id}_${_selectedVariant.id}',
                        name: '${product.name} (${_selectedVariant.name})',
                        price: currentPrice,
                        originalPrice: currentOriginalPrice,
                        stock: currentStock,
                      );
                      for (int i = 0; i < _quantity; i++) {
                        ref.read(cartProvider.notifier).addToCart(variantProduct);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '$_quantity x ${variantProduct.name} ajouté au panier',
                            style: GoogleFonts.plusJakartaSans(color: Colors.white),
                          ),
                          backgroundColor: AppColors.spotifyElevated,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.monarchPurpleNeon),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      foregroundColor: Colors.white,
                    ),
                    child: const Icon(Icons.shopping_bag_outlined, color: AppColors.monarchPurpleNeon),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Buy Now button
              Expanded(
                flex: 3,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: AppColors.monarchGradient,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.monarchPurple.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      final variantProduct = product.copyWith(
                        id: '${product.id}_${_selectedVariant.id}',
                        name: '${product.name} (${_selectedVariant.name})',
                        price: currentPrice,
                        originalPrice: currentOriginalPrice,
                        stock: currentStock,
                      );
                      for (int i = 0; i < _quantity; i++) {
                        ref.read(cartProvider.notifier).addToCart(variantProduct);
                      }
                      context.push(AppRoutes.cart);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      'Acheter (${(currentPrice * _quantity).toInt()} FCFA)',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerkRow(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.monarchPurpleNeon),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.spotifyGrey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
