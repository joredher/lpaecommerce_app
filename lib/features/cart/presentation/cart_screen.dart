import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routing/app_router.dart';
import '../../../app/state/cart/cart_controller.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartControllerProvider);
    final notifier = ref.read(cartControllerProvider.notifier);

    if (cartState.cart.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_cart_outlined, size: 64),
            const SizedBox(height: 16),
            const Text('Your cart is empty. Browse the catalog to add items.'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.goNamed(AppRouteNames.catalog),
              child: const Text('Go to catalog'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cart', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: cartState.cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cartState.cart.items[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            item.product.images.first.url,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text('${item.product.currency} ${item.product.price.toStringAsFixed(2)}'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text('Qty:'),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 72,
                                    child: TextFormField(
                                      initialValue: item.quantity.toString(),
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      ),
                                      onFieldSubmitted: (value) {
                                        final qty = int.tryParse(value) ?? item.quantity;
                                        notifier.updateQuantity(item.product.id, qty);
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Remove',
                                    onPressed: () => showDialog<void>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Remove item'),
                                        content: Text('Remove ${item.product.name} from the cart?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              notifier.removeProduct(item.product.id);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Remove'),
                                          ),
                                        ],
                                      ),
                                    ),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Coupon code',
                    prefixIcon: Icon(Icons.card_giftcard_outlined),
                  ),
                  onSubmitted: notifier.applyCoupon,
                ),
              ),
              const SizedBox(width: 12),
              FilledButton.tonal(
                onPressed: () => notifier.applyCoupon(null),
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _SummaryRow(label: 'Subtotal', value: cartState.cart.subtotal),
                _SummaryRow(label: 'Tax (10%)', value: cartState.cart.taxes),
                const Divider(),
                _SummaryRow(label: 'Total', value: cartState.cart.total, isEmphasised: true),
                if (cartState.appliedCoupon != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Coupon applied: ${cartState.appliedCoupon}'),
                  ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.goNamed(AppRouteNames.checkout),
                  icon: const Icon(Icons.lock_outline),
                  label: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.isEmphasised = false});

  final String label;
  final double value;
  final bool isEmphasised;

  @override
  Widget build(BuildContext context) {
    final textStyle = isEmphasised
        ? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.titleMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: textStyle),
          const SizedBox(width: 16),
          Text(value.toStringAsFixed(2), style: textStyle),
        ],
      ),
    );
  }
}
