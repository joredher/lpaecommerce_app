import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lpaecomms/app/routing/app_router.dart';
import 'package:lpaecomms/features/catalog/data/catalog_models.dart';
import 'package:lpaecomms/features/catalog/data/catalog_providers.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(catalogProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Catalog')),
      body: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: Text('No products found in the catalog yet.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: _CatalogThumbnail(product: product),
                  title: Text(product.name),
                  subtitle: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.goNamed(
                    AppRouteNames.product,
                    pathParameters: {'productId': product.id},
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Failed to load catalog products. ${error.toString()}'),
          ),
        ),
      ),
    );
  }
}

class _CatalogThumbnail extends StatelessWidget {
  const _CatalogThumbnail({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return const CircleAvatar(
        backgroundColor: Color(0xFFE0F2F1),
        child: Icon(Icons.devices_other_outlined, color: Color(0xFF00695C)),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const CircleAvatar(
            backgroundColor: Color(0xFFE0F2F1),
            child: Icon(Icons.image_not_supported_outlined, color: Color(0xFF00695C)),
          );
        },
      ),
    );
  }
}
