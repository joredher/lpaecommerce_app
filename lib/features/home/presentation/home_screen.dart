import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lpaecomms/app/routing/app_router.dart';
import 'package:lpaecomms/app/state/app_state_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(appStateProvider).cartItems.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LPAEcommerce'),
        actions: [
          IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (cartCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          '$cartCount',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => context.goNamed(AppRouteNames.cart),
            tooltip: 'Cart',
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.goNamed(AppRouteNames.profile),
            tooltip: 'Account',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Welcome back! Browse the areas of the shop to verify the new routing skeleton.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          _NavigationCard(
            title: 'Showcase',
            subtitle: 'See the featured landing page experience.',
            icon: Icons.home_outlined,
            onTap: () => context.goNamed(AppRouteNames.home),
          ),
          _NavigationCard(
            title: 'Catalog',
            subtitle: 'Jump into categories and search results.',
            icon: Icons.category_outlined,
            onTap: () => context.goNamed(AppRouteNames.catalog),
          ),
          _NavigationCard(
            title: 'Sample Product',
            subtitle: 'Preview what the PDP route wiring looks like.',
            icon: Icons.shopping_bag_outlined,
            onTap: () => context.goNamed(
              AppRouteNames.product,
              pathParameters: const {'productId': 'demo-sku-1'},
            ),
          ),
          _NavigationCard(
            title: 'Cart',
            subtitle: 'Inspect the cart stub and checkout entry point.',
            icon: Icons.shopping_cart_checkout_outlined,
            onTap: () => context.goNamed(AppRouteNames.cart),
          ),
          _NavigationCard(
            title: 'Orders',
            subtitle: 'Placeholder for recent purchases.',
            icon: Icons.receipt_long_outlined,
            onTap: () => context.goNamed(AppRouteNames.orders),
          ),
          _NavigationCard(
            title: 'Account',
            subtitle: 'Profile, addresses, and saved items.',
            icon: Icons.person_outline,
            onTap: () => context.goNamed(AppRouteNames.profile),
          ),
        ],
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
