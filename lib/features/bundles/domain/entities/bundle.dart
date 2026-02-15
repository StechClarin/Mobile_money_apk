import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

enum BundleType { internet, call, sms, special, mixte, oversize, vsd }

@immutable
class Bundle extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final String validity;
  final String duration; // e.g., '1j', '7j', '30j', 'illimite'
  final String? dataAmount;
  final String? minutesAmount;
  final BundleType type;

  const Bundle({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.validity,
    required this.duration,
    this.dataAmount,
    this.minutesAmount,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, description, price, validity, duration, dataAmount, minutesAmount, type];
}
