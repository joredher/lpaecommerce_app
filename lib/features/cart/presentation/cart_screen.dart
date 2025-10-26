import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lpaecomms/app/routing/app_router.dart';
import 'package:lpaecomms/app/state/app_state_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final items = appState.cartItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: items.isEmpty
          ? const Center(
              child: Text('Your cart is empty. Add products from the catalog.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: Text('Product ${item.productId}'),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => ref
                          .read(appStateProvider.notifier)
                          .updateCartItemQuantity(item.productId, 0),
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: items.isEmpty
              ? null
              : () => context.pushNamed(AppRouteNames.checkout),
          child: const Text('Proceed to checkout'),
        ),
      ),
    );
  }
}
