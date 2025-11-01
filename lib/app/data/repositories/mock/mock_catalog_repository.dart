import '../../models/product.dart';
import '../../services/mock_data_service.dart';
import '../catalog_repository.dart';

class MockCatalogRepository implements CatalogRepository {
  MockCatalogRepository(this._mockDataService);

  final MockDataService _mockDataService;

  @override
  Future<List<String>> getCategories() async {
    return _mockDataService.products
        .map((product) => product.category)
        .toSet()
        .toList()
      ..sort();
  }

  @override
  Future<CatalogPage> fetchProducts(CatalogQuery query) async {
    var products = _mockDataService.products;
    if (query.searchTerm != null && query.searchTerm!.isNotEmpty) {
      final needle = query.searchTerm!.toLowerCase();
      products = products
          .where((product) =>
              product.name.toLowerCase().contains(needle) ||
              product.description.toLowerCase().contains(needle))
          .toList();
    }
    if (query.category != null && query.category!.isNotEmpty) {
      products = products
          .where((product) => product.category.toLowerCase() == query.category!.toLowerCase())
          .toList();
    }

    if (query.sort == 'price-asc') {
      products = [...products]..sort((a, b) => a.price.compareTo(b.price));
    } else if (query.sort == 'price-desc') {
      products = [...products]..sort((a, b) => b.price.compareTo(a.price));
    }

    final total = products.length;
    final start = (query.page - 1) * query.pageSize;
    final end = start + query.pageSize;
    final startIndex = start.clamp(0, total).toInt();
    final endIndex = end.clamp(0, total).toInt();
    final pageItems = products.sublist(startIndex, endIndex);

    return CatalogPage(items: pageItems, total: total, page: query.page, pageSize: query.pageSize);
  }

  @override
  Future<Product?> fetchProductBySlug(String slug) async {
    try {
      return _mockDataService.products.firstWhere((product) => product.slug == slug);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Product>> fetchRelatedProducts(String productId) async {
    final current = _mockDataService.products.firstWhere((product) => product.id == productId);
    return _mockDataService.products
        .where((product) => product.category == current.category && product.id != current.id)
        .take(4)
        .toList();
  }
}
