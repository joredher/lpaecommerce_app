import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/data/data_providers.dart';
import '../../../app/data/models/product.dart';
import '../../../app/routing/app_router.dart';
import '../../../app/state/cart/cart_controller.dart';

final productDetailProvider = FutureProvider.autoDispose.family<Product?, String>((ref, slug) async {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.fetchProductBySlug(slug);
});

final relatedProductsProvider = FutureProvider.autoDispose.family<List<Product>, String>((ref, productId) async {
  final repository = ref.watch(catalogRepositoryProvider);
  return repository.fetchRelatedProducts(productId);
});

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(slug));

    return productAsync.when(
      data: (product) {
        if (product == null) {
          return const Scaffold(body: Center(child: Text('Product not found')));
        }
        final relatedAsync = ref.watch(relatedProductsProvider(product.id));
        return Scaffold(
          appBar: AppBar(title: Text(product.name)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 960;
                    return Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      crossAxisAlignment:
                          isWide ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: PageView.builder(
                                itemCount: product.images.length,
                                itemBuilder: (context, index) {
                                  final image = product.images[index];
                                  return Image.network(
                                    image.url,
                                    fit: BoxFit.cover,
                                    semanticLabel: image.alt,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24, height: 24),
                        Expanded(
                          flex: 2,
                          child: _ProductSummary(product: product),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  'Key features',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: product.features
                      .map(
                        (feature) => Chip(
                          label: Text('${feature.label}: ${feature.value}'),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 24),
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                relatedAsync.when(
                  data: (related) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (related.isNotEmpty)
                        Text(
                          'Related products',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 280,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: related.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 16),
                          itemBuilder: (context, index) {
                            final item = related[index];
                            return SizedBox(
                              width: 220,
                              child: Card(
                                child: InkWell(
                                  onTap: () => GoRouter.of(context).goNamed(
                                    AppRouteNames.product,
                                    pathParameters: {'slug': item.slug},
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 4 / 3,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                          ),
                                          child: Image.network(item.images.first.url, fit: BoxFit.cover),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(fontWeight: FontWeight.w600),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Text('${item.currency} ${item.price.toStringAsFixed(2)}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, _) => Text('Failed to load related products: $error'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(body: Center(child: Text('Failed to load product: $error'))),
    );
  }
}

class _ProductSummary extends ConsumerWidget {
  const _ProductSummary({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text('${product.currency} ${product.price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Text('Stock available: ${product.inventory}'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: product.isInStock
                    ? () {
                        cartNotifier.addProduct(product);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Added to cart')));
                      }
                    : null,
                icon: const Icon(Icons.shopping_cart_checkout_outlined),
                label: Text(product.isInStock ? 'Add to cart' : 'Out of stock'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product.features
                    .map(
                      (feature) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(feature.label),
                        subtitle: Text(feature.value),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          icon: const Icon(Icons.info_outline),
          label: const Text('View specs'),
        ),
      ],
    );
  }
}
