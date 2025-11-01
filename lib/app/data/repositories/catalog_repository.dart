import '../models/product.dart';

class CatalogQuery {
  const CatalogQuery({
    this.searchTerm,
    this.category,
    this.sort,
    this.page = 1,
    this.pageSize = 12,
  });

  final String? searchTerm;
  final String? category;
  final String? sort;
  final int page;
  final int pageSize;

  CatalogQuery copyWith({
    String? searchTerm,
    String? category,
    String? sort,
    int? page,
    int? pageSize,
  }) {
    return CatalogQuery(
      searchTerm: searchTerm ?? this.searchTerm,
      category: category ?? this.category,
      sort: sort ?? this.sort,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

class CatalogPage {
  const CatalogPage({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<Product> items;
  final int total;
  final int page;
  final int pageSize;
}

abstract class CatalogRepository {
  Future<List<String>> getCategories();

  Future<CatalogPage> fetchProducts(CatalogQuery query);

  Future<Product?> fetchProductBySlug(String slug);

  Future<List<Product>> fetchRelatedProducts(String productId);
}
