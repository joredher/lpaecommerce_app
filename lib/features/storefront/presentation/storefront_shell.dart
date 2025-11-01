import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routing/app_router.dart';
import '../../../app/state/accessibility/accessibility_controller.dart';
import '../../../app/state/auth/auth_controller.dart';
import '../../../app/state/cart/cart_controller.dart';

class StorefrontShell extends ConsumerWidget {
  const StorefrontShell({super.key, required this.child, required this.state});

  final Widget child;
  final GoRouterState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final cart = ref.watch(cartControllerProvider).cart;
    final prefs = ref.watch(accessibilityControllerProvider).valueOrNull ??
        const AccessibilityPreferences();

    final isDesktop = MediaQuery.of(context).size.width >= 1024;
    final navItems = [
      _HeaderNavItem('Home', AppRouteNames.storefrontHome),
      _HeaderNavItem('Catalog', AppRouteNames.catalog),
      _HeaderNavItem('Orders', AppRouteNames.orders, requiresAuth: true),
      _HeaderNavItem('Support', AppRouteNames.support),
    ];

    final currentName = state.name;

    return Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              constraints: const BoxConstraints(maxHeight: 80),
              child: Row(
                children: [
                  Text(
                    'LPA eComms',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const Spacer(),
                  if (isDesktop)
                    ...navItems
                        .where((item) => !item.requiresAuth || authState.isAuthenticated)
                        .map((item) => TextButton(
                              onPressed: () => context.goNamed(item.routeName),
                              child: Text(item.label,
                                  style: TextStyle(
                                    decoration: prefs.underlineLinks
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  )),
                            )),
                  const SizedBox(width: 12),
                  IconButton(
                    tooltip: 'Cart (${cart.items.length})',
                    onPressed: () => context.goNamed(AppRouteNames.cart),
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.shopping_cart_outlined),
                        if (cart.items.isNotEmpty)
                          Positioned(
                            right: -4,
                            top: -4,
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                cart.items.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    tooltip: 'Account',
                    onSelected: (value) async {
                      if (value == 'profile') {
                        context.goNamed(AppRouteNames.account);
                      } else if (value == 'admin') {
                        context.goNamed(AppRouteNames.adminDashboard);
                      } else if (value == 'logout') {
                        await ref.read(authControllerProvider.notifier).logout();
                        if (context.mounted) {
                          context.goNamed(AppRouteNames.onboarding);
                        }
                      } else if (value == 'login') {
                        context.goNamed(AppRouteNames.login);
                      }
                    },
                    itemBuilder: (context) {
                      final items = <PopupMenuEntry<String>>[];
                      if (authState.isAuthenticated) {
                        items.add(
                          const PopupMenuItem<String>(
                            value: 'profile',
                            child: Text('Account'),
                          ),
                        );
                        if (authState.isAdmin) {
                          items.add(
                            const PopupMenuItem<String>(
                              value: 'admin',
                              child: Text('Admin workspace'),
                            ),
                          );
                        }
                        items.add(
                          const PopupMenuItem<String>(
                            value: 'logout',
                            child: Text('Sign out'),
                          ),
                        );
                      } else {
                        items.add(
                          const PopupMenuItem<String>(
                            value: 'login',
                            child: Text('Sign in'),
                          ),
                        );
                      }
                      return items;
                    },
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        authState.session?.profile.displayName.substring(0, 1).toUpperCase() ?? 'G',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                if (!isDesktop)
                  Builder(
                    builder: (context) {
                      final filtered = navItems
                          .where((item) => !item.requiresAuth || authState.isAuthenticated)
                          .toList();
                      final selectedIndex = filtered.indexWhere((item) => item.routeName == currentName);
                      return NavigationRail(
                        selectedIndex: selectedIndex < 0 ? 0 : selectedIndex,
                        destinations: filtered
                            .map((item) => NavigationRailDestination(
                              icon: const Icon(Icons.circle_outlined, size: 16),
                              selectedIcon: const Icon(Icons.circle, size: 16),
                              label: Text(item.label),
                            ))
                            .toList(),
                        onDestinationSelected: (index) {
                          context.goNamed(filtered[index].routeName);
                        },
                      );
                    },
                  ),
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: child,
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Text(
                  '© ${DateTime.now().year} Local Public Affairs',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.goNamed(AppRouteNames.support),
                  child: const Text('Contact support'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderNavItem {
  const _HeaderNavItem(this.label, this.routeName, {this.requiresAuth = false});

  final String label;
  final String routeName;
  final bool requiresAuth;
}
