import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'catalog_models.dart';
import 'catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return const CatalogRepository();
});

final catalogCategoriesProvider = FutureProvider.autoDispose<List<Category>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.fetchCategories();
});

final trendingProductsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.fetchProducts(limit: 5);
});

final catalogProductsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.fetchProducts();
});

final productByIdProvider = FutureProvider.autoDispose.family<Product, String>((ref, id) async {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.fetchProductById(id);
});
