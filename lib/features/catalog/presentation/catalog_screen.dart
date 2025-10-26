import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lpaecomms/app/routing/app_router.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = <String>[
      'Latest drops',
      'Gaming gear',
      'Studio audio',
      'Smart home',
      'Accessories',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Catalog')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.grid_view_outlined),
              title: Text(category),
              subtitle: const Text('Tap to view a sample product detail page'),
              onTap: () => context.goNamed(
                AppRouteNames.product,
                pathParameters: {'productId': category.toLowerCase().replaceAll(' ', '-')},
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: categories.length,
      ),
    );
  }
}
