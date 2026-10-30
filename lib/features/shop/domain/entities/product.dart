import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
  });

  List<String> get allImages => images.isNotEmpty ? images : [imageUrl, '${imageUrl}_2', '${imageUrl}_3', '${imageUrl}_4'];

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
      ];
}


