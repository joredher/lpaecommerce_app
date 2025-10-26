import 'package:mysql_client/mysql_client.dart';

import '../../../app/data/mysql/mysql_database.dart';
import 'catalog_models.dart';

class CatalogRepository {
  CatalogRepository({required MySqlDatabase database}) : _database = database;

  final MySqlDatabase _database;

  Future<List<Category>> fetchCategories() async {
    const query = '''
      SELECT lpa_category_ID, lpa_category_name, lpa_category_desc
      FROM lpa_category
      ORDER BY lpa_category_name ASC
    ''';

    final result = await _database.execute(query);
    return result.rows.map(_mapCategory).toList(growable: false);
  }

  Future<List<Product>> fetchProducts({int? limit}) async {
    final buffer = StringBuffer(
      '''
      SELECT
        lpa_stock_ID,
        lpa_stock_name,
        lpa_stock_price,
        lpa_stock_image,
        lpa_stock_slug,
        lpa_stock_desc,
        lpa_stock_features
      FROM lpa_stock
      WHERE lpa_stock_status = 'P'
      ORDER BY COALESCE(lpa_stock_publish_at, NOW()) DESC, lpa_stock_ID DESC
      '''
    );

    if (limit != null && limit > 0) {
      buffer.write(' LIMIT $limit');
    }

    final result = await _database.execute(buffer.toString());
    return result.rows.map(_mapProduct).toList(growable: false);
  }

  Future<Product> fetchProductById(String id) async {
    const query = '''
      SELECT
        lpa_stock_ID,
        lpa_stock_name,
        lpa_stock_price,
        lpa_stock_image,
        lpa_stock_slug,
        lpa_stock_desc,
        lpa_stock_features
      FROM lpa_stock
      WHERE lpa_stock_ID = :id
      LIMIT 1
    ''';

    final result = await _database.execute(query, params: {'id': id});
    if (result.rows.isEmpty) {
      throw StateError('Product $id was not found');
    }
    return _mapProduct(result.rows.first);
  }

  Category _mapCategory(IResultSetRow row) {
    final assoc = row.assoc();
    return Category(
      id: assoc['lpa_category_ID'] ?? '',
      name: assoc['lpa_category_name'] ?? '',
      description: assoc['lpa_category_desc'],
    );
  }

  Product _mapProduct(IResultSetRow row) {
    final assoc = row.assoc();
    final priceString = assoc['lpa_stock_price'] ?? '0';
    final price = double.tryParse(priceString) ?? 0;
    final imageName = assoc['lpa_stock_image'];

    return Product(
      id: assoc['lpa_stock_ID'] ?? '',
      name: assoc['lpa_stock_name'] ?? '',
      price: price,
      slug: assoc['lpa_stock_slug'] ?? '',
      description: assoc['lpa_stock_desc'],
      features: assoc['lpa_stock_features'],
      imageUrl: _resolveImageUrl(imageName),
    );
  }

  String? _resolveImageUrl(String? imageName) {
    if (imageName == null || imageName.isEmpty) {
      return 'https://via.placeholder.com/300x300?text=No+Image';
    }

    final normalized = imageName.trim();
    if (normalized.isEmpty) {
      return 'https://via.placeholder.com/300x300?text=No+Image';
    }

    final baseUrl = const String.fromEnvironment('LPA_ASSET_BASE_URL', defaultValue: 'https://example.com/');
    final productPath = const String.fromEnvironment('LPA_PRODUCT_IMAGE_PATH', defaultValue: 'assets/images/products/');
    final testPath = const String.fromEnvironment('LPA_PRODUCT_TEST_IMAGE_PATH', defaultValue: 'assets/images/test-images/');

    final sanitizedBase = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final candidateUrls = <String>[];

    if (productPath.isNotEmpty) {
      candidateUrls.add('$sanitizedBase${productPath.trimLeft('/')}$normalized');
    }
    if (testPath.isNotEmpty) {
      candidateUrls.add('$sanitizedBase${testPath.trimLeft('/')}$normalized');
    }

    if (candidateUrls.isEmpty) {
      return 'https://via.placeholder.com/300x300?text=No+Image';
    }

    return candidateUrls.first;
  }
}
