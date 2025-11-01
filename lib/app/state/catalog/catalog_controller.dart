import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_providers.dart';
import '../../data/models/product.dart';
import '../../data/repositories/catalog_repository.dart';

class CatalogState {
  const CatalogState({
    this.query = const CatalogQuery(),
    this.categories = const [],
    this.products = const [],
    this.total = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  final CatalogQuery query;
  final List<String> categories;
  final List<Product> products;
  final int total;
  final bool isLoading;
  final String? errorMessage;

  CatalogState copyWith({
    CatalogQuery? query,
    List<String>? categories,
    List<Product>? products,
    int? total,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CatalogState(
      query: query ?? this.query,
      categories: categories ?? this.categories,
      products: products ?? this.products,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class CatalogController extends StateNotifier<CatalogState> {
  CatalogController(this._repository) : super(const CatalogState()) {
    _initialize();
  }

  final CatalogRepository _repository;

  Future<void> _initialize() async {
    final categories = await _repository.getCategories();
    state = state.copyWith(categories: categories);
    await refresh();
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final page = await _repository.fetchProducts(state.query);
      state = state.copyWith(
        isLoading: false,
        products: page.items,
        total: page.total,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> updateQuery(CatalogQuery query) async {
    state = state.copyWith(query: query);
    await refresh();
  }
}

final catalogControllerProvider = StateNotifierProvider<CatalogController, CatalogState>((ref) {
  final repository = ref.watch(catalogRepositoryProvider);
  return CatalogController(repository);
});
