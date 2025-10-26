import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        itemBuilder: (context, index) {
          final orderNumber = '#10${index + 1}45';
          return Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text('Order $orderNumber'),
              subtitle: const Text('Placeholder order summary'),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}
