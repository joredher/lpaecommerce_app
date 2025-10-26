import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lpaecomms/app/state/app_state_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(appStateProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Product detail')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Demo product: $productId',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              'This stub screen represents the product detail page wiring. Tap the button below to simulate adding the item to your cart and then check the cart route.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  notifier.addToCart(CartItem(productId: productId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Added to cart')), 
                  );
                },
                icon: const Icon(Icons.add_shopping_cart_outlined),
                label: const Text('Add to cart'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
