import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ProductVariant extends Equatable {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final int stock;
  final String? badge;
  final String? description;

  const ProductVariant({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    this.stock = 20,
    this.badge,
    this.description,
  });

  int? get discountPercentage {
    if (originalPrice == null || originalPrice! <= price) return null;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  ProductVariant copyWith({
    String? id,
    String? name,
    double? price,
    double? originalPrice,
    int? stock,
    String? badge,
    String? description,
  }) {
    return ProductVariant(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      stock: stock ?? this.stock,
      badge: badge ?? this.badge,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, name, price, originalPrice, stock, badge, description];
}
