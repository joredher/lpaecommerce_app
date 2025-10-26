import 'package:flutter/foundation.dart';

@immutable
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.slug,
    this.description,
    this.features,
    this.imageUrl,
  });

  final String id;
  final String name;
  final double price;
  final String slug;
  final String? description;
  final String? features;
  final String? imageUrl;
}

@immutable
class Category {
  const Category({
    required this.id,
    required this.name,
    this.description,
  });

  final String id;
  final String name;
  final String? description;
}
