import 'package:equatable/equatable.dart';

class PromoBanner extends Equatable {
  final String id;
  final String? title;
  final String imageUrl;
  final String? redirectLink;
  final int priority;

  const PromoBanner({
    required this.id,
    this.title,
    required this.imageUrl,
    this.redirectLink,
    this.priority = 0,
  });

  @override
  List<Object?> get props => [id, title, imageUrl, redirectLink, priority];
}
