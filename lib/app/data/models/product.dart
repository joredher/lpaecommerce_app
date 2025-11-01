import 'package:equatable/equatable.dart';

class ProductImage extends Equatable {
  const ProductImage({required this.url, this.alt});

  final String url;
  final String? alt;

  @override
  List<Object?> get props => [url, alt];
}

class ProductFeature extends Equatable {
  const ProductFeature({required this.label, required this.value});

  final String label;
  final String value;

  @override
  List<Object?> get props => [label, value];
}

class Product extends Equatable {
  const Product({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.inventory,
    required this.category,
    required this.images,
    this.features = const [],
    this.isScheduled,
    this.scheduleDate,
    this.badges = const [],
  });

  final String id;
  final String slug;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int inventory;
  final String category;
  final List<ProductImage> images;
  final List<ProductFeature> features;
  final bool? isScheduled;
  final DateTime? scheduleDate;
  final List<String> badges;

  bool get isInStock => inventory > 0;

  Product copyWith({
    String? name,
    String? description,
    double? price,
    String? currency,
    int? inventory,
    String? category,
    List<ProductImage>? images,
    List<ProductFeature>? features,
    bool? isScheduled,
    DateTime? scheduleDate,
    List<String>? badges,
  }) {
    return Product(
      id: id,
      slug: slug,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      inventory: inventory ?? this.inventory,
      category: category ?? this.category,
      images: images ?? this.images,
      features: features ?? this.features,
      isScheduled: isScheduled ?? this.isScheduled,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      badges: badges ?? this.badges,
    );
  }

  @override
  List<Object?> get props => [
        id,
        slug,
        name,
        description,
        price,
        currency,
        inventory,
        category,
        images,
        features,
        isScheduled,
        scheduleDate,
        badges,
      ];
}
