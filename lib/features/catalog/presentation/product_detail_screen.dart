import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lpaecomms/app/routing/app_router.dart';
import 'package:lpaecomms/app/state/app_state_provider.dart';
import 'package:lpaecomms/features/catalog/data/catalog_providers.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(appStateProvider.notifier);
    final appState = ref.watch(appStateProvider);
    final productAsync = ref.watch(productByIdProvider(productId));

    return Scaffold(
      appBar: AppBar(title: const Text('Product detail')),
      body: productAsync.when(
        data: (product) {
          final isInCart = appState.cartItems.any((item) => item.productId == product.id);
          final featureLines = _splitLines(product.features);
          final descriptionLines = _splitLines(product.description);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      product.imageUrl!,
                      width: double.infinity,
                      height: 240,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 240,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Center(
                            child: Icon(Icons.image_not_supported_outlined, size: 48),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Icon(Icons.devices_other_outlined, size: 48),
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'SKU: ${product.slug.isEmpty ? product.id : product.slug}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.blueGrey,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (descriptionLines.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  for (final line in descriptionLines)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(line),
                    ),
                ],
                if (featureLines.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'Key features',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  for (final line in featureLines)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(child: Text(line)),
                        ],
                      ),
                    ),
                ],
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (isInCart) {
                        context.goNamed(AppRouteNames.cart);
                      } else {
                        cartNotifier.addToCart(CartItem(productId: product.id));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                      }
                    },
                    icon: Icon(isInCart ? Icons.shopping_cart : Icons.add_shopping_cart_outlined),
                    label: Text(isInCart ? 'View cart' : 'Add to cart'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Unable to load product details. ${error.toString()}'),
          ),
        ),
      ),
    );
  }

  List<String> _splitLines(String? value) {
    if (value == null || value.trim().isEmpty) {
      return const [];
    }
    return value
        .split(RegExp(r'\r?\n'))
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);
  }
}
