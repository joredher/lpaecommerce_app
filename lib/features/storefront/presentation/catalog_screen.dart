import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/state/catalog/catalog_controller.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogControllerProvider);
    final notifier = ref.read(catalogControllerProvider.notifier);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Wrap(
            runSpacing: 12,
            spacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: 'Search products',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (value) => notifier.updateQuery(
                    catalogState.query.copyWith(searchTerm: value, page: 1),
                  ),
                ),
              ),
              DropdownButton<String>(
                value: catalogState.query.sort ?? 'relevance',
                items: const [
                  DropdownMenuItem(value: 'relevance', child: Text('Relevance')),
                  DropdownMenuItem(value: 'price-asc', child: Text('Price: Low to high')),
                  DropdownMenuItem(value: 'price-desc', child: Text('Price: High to low')),
                ],
                onChanged: (value) {
                  notifier.updateQuery(catalogState.query.copyWith(sort: value));
                },
              ),
              DropdownButton<String>(
                value: catalogState.query.category ?? 'all',
                items: [
                  const DropdownMenuItem(value: 'all', child: Text('All categories')),
                  ...catalogState.categories
                      .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                      .toList(),
                ],
                onChanged: (value) {
                  if (value == 'all') {
                    notifier.updateQuery(catalogState.query.copyWith(category: null, page: 1));
                  } else {
                    notifier.updateQuery(catalogState.query.copyWith(category: value, page: 1));
                  }
                },
              ),
              TextButton.icon(
                onPressed: () => notifier.refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Refresh'),
              ),
            ],
          ),
        ),
        Expanded(
          child: catalogState.isLoading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: size.width < 600
                        ? 1
                        : size.width < 900
                            ? 2
                            : size.width < 1400
                                ? 3
                                : 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 3 / 4,
                  ),
                  itemCount: catalogState.products.length,
                  itemBuilder: (context, index) {
                    final product = catalogState.products[index];
                    return ProductCard(product: product);
                  },
                ),
        ),
        if (!catalogState.isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total results: ${catalogState.total}'),
                Row(
                  children: [
                    IconButton(
                      onPressed: catalogState.query.page > 1
                          ? () => notifier.updateQuery(
                                catalogState.query.copyWith(page: catalogState.query.page - 1),
                              )
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text('Page ${catalogState.query.page}'),
                    IconButton(
                      onPressed: catalogState.products.length == catalogState.query.pageSize
                          ? () => notifier.updateQuery(
                                catalogState.query.copyWith(page: catalogState.query.page + 1),
                              )
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
