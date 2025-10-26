import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lpaecomms/app/routing/app_router.dart';
import 'package:lpaecomms/app/state/app_state_provider.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(appStateProvider).cartItems;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Review order (${items.length} item${items.length == 1 ? '' : 's'})',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'This is a placeholder checkout flow. Completing it will clear the cart.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: items.isEmpty
                    ? null
                    : () {
                        ref.read(appStateProvider.notifier).clearCart();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Order placed!')),
                        );
                        context.pushNamed(AppRouteNames.orders);
                      },
                child: const Text('Place order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
