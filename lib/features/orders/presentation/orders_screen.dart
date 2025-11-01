import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/state/orders/orders_controller.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(ordersControllerProvider);
    final controller = ref.read(ordersControllerProvider.notifier);

    if (ordersState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ordersState.orders.isEmpty
          ? const ListView(
              children: [
                SizedBox(height: 120),
                Center(child: Text('No orders found. Complete checkout to create one.')),
              ],
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemBuilder: (context, index) {
                final order = ordersState.orders[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: Text(order.number),
                    subtitle:
                        Text('${order.cart.items.length} items · ${order.status.name.toUpperCase()}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(order.placedAt.toLocal().toString().split('.').first),
                        Text('Total: ${order.cart.total.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: ordersState.orders.length,
            ),
    );
  }
}
