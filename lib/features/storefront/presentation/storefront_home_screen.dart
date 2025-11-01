import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routing/app_router.dart';
import '../../../app/state/catalog/catalog_controller.dart';
import '../../support/presentation/support_center_screen.dart';
import '../widgets/product_card.dart';

class StorefrontHomeScreen extends ConsumerWidget {
  const StorefrontHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogControllerProvider);
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 900;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: isWide ? 2 : 1,
                      child: _HeroBanner(onExplore: () => context.goNamed(AppRouteNames.catalog)),
                    ),
                    if (isWide) const SizedBox(width: 24),
                    if (isWide)
                      const Expanded(
                        child: _SupportShortcut(),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: catalogState.categories
                      .map(
                        (category) => ActionChip(
                          label: Text(category),
                          onPressed: () => ref
                              .read(catalogControllerProvider.notifier)
                              .updateQuery(
                                catalogState.query.copyWith(category: category, page: 1),
                              ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 32),
                Text(
                  'Trending products',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ),
        if (catalogState.isLoading)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size.width < 600
                    ? 1
                    : size.width < 900
                        ? 2
                        : size.width < 1400
                            ? 3
                            : 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 3 / 4,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = catalogState.products[index];
                  return ProductCard(product: product);
                },
                childCount: catalogState.products.length.clamp(0, 8) as int,
              ),
            ),
          ),
      ],
    );
  }
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.onExplore});

  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Branded storefront rebuilt in Flutter',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Explore catalog parity, stock-aware carts, and admin controls aligned with the legacy PHP platform.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.explore),
                onPressed: onExplore,
                label: const Text('Start browsing'),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.support_agent_outlined),
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (context) => const Dialog(child: SizedBox(height: 520, child: SupportCenterScreen(compact: true))),
                ),
                label: const Text('Contact support'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupportShortcut extends StatelessWidget {
  const _SupportShortcut();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.support_agent_outlined),
            ),
            title: const Text('Need help fast?'),
            subtitle: const Text('Track tickets and live chat with the customer care squad.'),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => GoRouter.of(context).goNamed(AppRouteNames.support),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Support workspace'),
          ),
        ],
      ),
    );
  }
}
