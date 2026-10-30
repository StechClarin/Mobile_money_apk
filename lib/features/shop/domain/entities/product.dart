import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'product_variant.dart';

@immutable
class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> images;
  final String category;
  final String icon;
  final bool isAvailable;
  final bool isFavorite;
  final double rating;
  final int reviewCount;
  final int? discountPercentage;
  final String? tag;
  final List<String> specs;
  final String brand;
  final int stock;
  final double imageCardHeight;
  final List<ProductVariant>? variants;
  final String? variantCategoryTitle;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.images = const [],
    required this.category,
    required this.icon,
    this.isAvailable = true,
    this.isFavorite = false,
    this.rating = 4.8,
    this.reviewCount = 54,
    this.discountPercentage,
    this.tag,
    this.specs = const [],
    this.brand = 'Walliss Pro',
    this.stock = 25,
    this.imageCardHeight = 135.0,
    this.variants,
    this.variantCategoryTitle,
  });

  String get effectiveVariantTitle => variantCategoryTitle ?? 'Modèle & Options';

  List<String> get allImages => images.isNotEmpty ? images : [imageUrl, '${imageUrl}_2', '${imageUrl}_3', '${imageUrl}_4'];

  List<ProductVariant> get allVariants {
    final v = variants;
    if (v != null && v.isNotEmpty) return v;

    // Tailored variants by category influencing price
    if (category == 'Smartphones' || category == 'Ordinateurs & Tablettes') {
      return [
        ProductVariant(
          id: '${id}_v1',
          name: '128 Go',
          price: price,
          originalPrice: originalPrice,
          description: 'Version Standard rapide & équilibrée',
        ),
        ProductVariant(
          id: '${id}_v2',
          name: '256 Go Pro',
          price: (price * 1.2).roundToDouble(),
          originalPrice: originalPrice != null ? (originalPrice! * 1.2).roundToDouble() : null,
          badge: 'Le Plus Choisi',
          description: 'Idéal pour le multitâche et les applications pros',
        ),
        ProductVariant(
          id: '${id}_v3',
          name: '512 Go Ultra',
          price: (price * 1.45).roundToDouble(),
          originalPrice: originalPrice != null ? (originalPrice! * 1.45).roundToDouble() : null,
          badge: 'Max Puissance',
          description: 'Espace géant pour bases de données et médias 4K',
        ),
      ];
    } else if (category == 'Terminaux POS') {
      return [
        ProductVariant(
          id: '${id}_v1',
          name: 'Terminal Seul',
          price: price,
          originalPrice: originalPrice,
          description: 'Équipement prêt à l\'emploi avec carte SIM',
        ),
        ProductVariant(
          id: '${id}_v2',
          name: 'Pack Pro (+ 10 Rouleaux)',
          price: price + 12000,
          originalPrice: originalPrice != null ? originalPrice! + 15000 : null,
          badge: 'Pack Commerçant',
          description: 'Inclus papier thermique haute cadence 58mm',
        ),
        ProductVariant(
          id: '${id}_v3',
          name: 'Pack Caisse Intégrale',
          price: price + 35000,
          originalPrice: originalPrice != null ? originalPrice! + 45000 : null,
          badge: 'Clé en main',
          description: 'Support de table rotatif + lot de 20 rouleaux + sacoche',
        ),
      ];
    } else {
      return [
        ProductVariant(
          id: '${id}_v1',
          name: 'Édition Solo',
          price: price,
          originalPrice: originalPrice,
          description: '1 unité standard certifiée Walliss',
        ),
        ProductVariant(
          id: '${id}_v2',
          name: 'Pack Duo (-15%)',
          price: (price * 1.7).roundToDouble(),
          originalPrice: (price * 2),
          badge: 'Économie 15%',
          description: 'Lot de 2 unités pour équiper plusieurs caisses',
        ),
        ProductVariant(
          id: '${id}_v3',
          name: 'Pack Équipe x5',
          price: (price * 3.9).roundToDouble(),
          originalPrice: (price * 5),
          badge: 'Prix Grossiste',
          description: 'Lot de 5 unités pour grands établissements',
        ),
      ];
    }
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    List<String>? images,
    String? category,
    String? icon,
    bool? isAvailable,
    bool? isFavorite,
    double? rating,
    int? reviewCount,
    int? discountPercentage,
    String? tag,
    List<String>? specs,
    String? brand,
    int? stock,
    double? imageCardHeight,
    List<ProductVariant>? variants,
    String? variantCategoryTitle,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      category: category ?? this.category,
      icon: icon ?? this.icon,
      isAvailable: isAvailable ?? this.isAvailable,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      tag: tag ?? this.tag,
      specs: specs ?? this.specs,
      brand: brand ?? this.brand,
      stock: stock ?? this.stock,
      imageCardHeight: imageCardHeight ?? this.imageCardHeight,
      variants: variants ?? this.variants,
      variantCategoryTitle: variantCategoryTitle ?? this.variantCategoryTitle,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        originalPrice,
        imageUrl,
        images,
        category,
        icon,
        isAvailable,
        isFavorite,
        rating,
        reviewCount,
        discountPercentage,
        tag,
        specs,
        brand,
        stock,
        imageCardHeight,
        variants,
        variantCategoryTitle,
      ];
}



