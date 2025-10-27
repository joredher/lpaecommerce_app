import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lpaecomms/app/routing/app_router.dart';
import 'package:lpaecomms/app/state/app_state_provider.dart';

const _colorPrimary = Color(0xFF003459);
const _colorPrimaryHover = Color(0xFFCAF0F8);
const _colorSecondary = Color(0xFF013A63);
const _colorSecondaryHover = Color(0xFF01497C);
const _colorGradientStart = Color.fromRGBO(78, 181, 144, 0.7);
const _colorGradientMid = Color.fromRGBO(53, 153, 143, 0.7);
const _colorGradientEnd = Color.fromRGBO(53, 124, 130, 0.7);
const _colorSuccess = Color(0xFFAADA6F);
const _colorCTA = Color(0xFFB6E67B);
const _colorCTAHover = Color(0xFFA3D066);
const _colorNeutralBg = Color.fromRGBO(217, 217, 217, 0.45);

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appStateProvider);
    final cartCount = state.cartItems.length;
    final isAuthenticated = state.authSession != null;

    return Scaffold(
      backgroundColor: _colorNeutralBg,
      appBar: AppBar(
        backgroundColor: _colorPrimary,
        foregroundColor: Colors.white,
        title: const Text('LPAEcommerce'),
        actions: [
          _BadgeIconButton(
            count: cartCount,
            icon: Icons.shopping_cart_outlined,
            onTap: () => context.goNamed(AppRouteNames.cart),
            tooltip: 'Cart',
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.goNamed(AppRouteNames.profile),
            tooltip: isAuthenticated ? 'Account' : 'Sign in',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _colorGradientStart,
              _colorGradientMid,
              _colorGradientEnd,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeroSection(isAuthenticated: isAuthenticated),
                const SizedBox(height: 24),
                _QuickActionGrid(cartCount: cartCount),
                const SizedBox(height: 24),
                const _FeaturedCategories(),
                const SizedBox(height: 24),
                const _TrendingProducts(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.isAuthenticated});

  final bool isAuthenticated;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _colorCTA,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              isAuthenticated ? 'Welcome back' : 'Discover something new',
              style: textTheme.labelLarge?.copyWith(
                color: _colorSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Tap into daily deals tailored just for you.',
            style: textTheme.headlineSmall?.copyWith(
              color: _colorSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Browse curated picks or jump straight to categories. Your next favourite gadget is only a tap away.',
            style: textTheme.bodyMedium?.copyWith(
              color: _colorSecondaryHover,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _HeroCTAButton(
                label: 'Start shopping',
                routeName: AppRouteNames.catalog,
                backgroundColor: _colorSuccess,
                foregroundColor: _colorSecondary,
              ),
              _HeroCTAButton(
                label: 'View orders',
                routeName: AppRouteNames.orders,
                backgroundColor: _colorPrimary,
                foregroundColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroCTAButton extends StatelessWidget {
  const _HeroCTAButton({
    required this.label,
    required this.routeName,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final String routeName;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
        onPressed: () => context.goNamed(routeName),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _QuickActionGrid extends StatelessWidget {
  const _QuickActionGrid({required this.cartCount});

  final int cartCount;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _QuickAction(
        title: 'Catalog',
        icon: Icons.grid_view_rounded,
        description: 'Browse everything in-store',
        color: _colorPrimary,
        onTap: () => context.goNamed(AppRouteNames.catalog),
      ),
      _QuickAction(
        title: 'Categories',
        icon: Icons.dashboard_customize_outlined,
        description: 'Jump to curated collections',
        color: _colorSecondary,
        onTap: () => context.goNamed(AppRouteNames.catalog),
      ),
      _QuickAction(
        title: 'My Cart',
        icon: Icons.shopping_cart_checkout,
        badge: cartCount > 0 ? '$cartCount' : null,
        description: 'Review items before checkout',
        color: _colorCTA,
        onTap: () => context.goNamed(AppRouteNames.cart),
      ),
      _QuickAction(
        title: 'Account',
        icon: Icons.person_outline,
        description: 'Profile, addresses & more',
        color: _colorSuccess,
        onTap: () => context.goNamed(AppRouteNames.profile),
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: tiles,
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.title,
    required this.icon,
    required this.description,
    required this.color,
    this.badge,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final String description;
  final Color color;
  final String? badge;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.white.withValues(alpha: 0.85),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(icon, color: color),
                  ),
                  const Spacer(),
                  if (badge != null)
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _colorPrimary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  color: _colorSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: textTheme.bodySmall?.copyWith(
                  color: _colorSecondaryHover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeaturedCategories extends StatelessWidget {
  const _FeaturedCategories();

  static const _categories = [
    _CategoryData('Smart Home', Icons.lightbulb_circle),
    _CategoryData('Audio', Icons.headphones_rounded),
    _CategoryData('Computing', Icons.computer_rounded),
    _CategoryData('Accessories', Icons.watch_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(
          title: 'Featured categories',
          actionLabel: 'See all',
          onAction: () => context.goNamed(AppRouteNames.catalog),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final category = _categories[index];
              return _CategoryCard(
                title: category.title,
                icon: category.icon,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Material(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.85),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => context.goNamed(AppRouteNames.catalog),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _colorPrimary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: _colorPrimary),
                ),
                const Spacer(),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _colorSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrendingProducts extends ConsumerWidget {
  const _TrendingProducts();

  static const _products = [
    _ProductData('Smart Speaker Mini', 'demo-speaker'),
    _ProductData('Noise Cancelling Headphones', 'demo-headphones'),
    _ProductData('Wireless Keyboard', 'demo-keyboard'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final cart = ref.read(appStateProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(
          title: 'Trending for you',
          actionLabel: 'View catalog',
          onAction: () => context.goNamed(AppRouteNames.catalog),
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            for (final product in _products)
              Builder(
                builder: (context) {
                  final isInCart = appState.cartItems
                      .any((item) => item.productId == product.sku);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _TrendingProductTile(
                      title: product.title,
                      sku: product.sku,
                      inCart: isInCart,
                      onTap: () => context.goNamed(
                        AppRouteNames.product,
                        pathParameters: {'productId': product.sku},
                      ),
                      onPrimaryAction: () {
                        if (isInCart) {
                          context.goNamed(AppRouteNames.cart);
                        } else {
                          cart.addToCart(
                            CartItem(productId: product.sku, quantity: 1),
                          );
                        }
                      },
                    ),
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _TrendingProductTile extends StatelessWidget {
  const _TrendingProductTile({
    required this.title,
    required this.sku,
    required this.onTap,
    required this.onPrimaryAction,
    required this.inCart,
  });

  final String title;
  final String sku;
  final VoidCallback onTap;
  final VoidCallback onPrimaryAction;
  final bool inCart;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.white.withValues(alpha: 0.88),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      _colorGradientStart,
                      _colorGradientMid,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.devices_other_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        color: _colorSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SKU: $sku',
                      style: textTheme.bodySmall?.copyWith(
                        color: _colorSecondaryHover,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: inCart ? _colorCTAHover : _colorCTA,
                  foregroundColor: _colorSecondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: onPrimaryAction,
                child: Text(inCart ? 'View cart' : 'Add to cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: _colorPrimaryHover,
          ),
          child: Text(actionLabel),
        ),
      ],
    );
  }
}

class _BadgeIconButton extends StatelessWidget {
  const _BadgeIconButton({
    required this.count,
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final int count;
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon),
          if (count > 0)
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryData {
  const _CategoryData(this.title, this.icon);

  final String title;
  final IconData icon;
}

class _ProductData {
  const _ProductData(this.title, this.sku);

  final String title;
  final String sku;
}
