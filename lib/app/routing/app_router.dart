import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/presentation/account_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/catalog/presentation/catalog_screen.dart';
import '../../features/catalog/presentation/product_detail_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../state/app_state_provider.dart';

class AppRouteNames {
  static const home = 'home';
  static const catalog = 'catalog';
  static const product = 'product';
  static const cart = 'cart';
  static const checkout = 'checkout';
  static const orders = 'orders';
  static const profile = 'profile';
}

class AppRoutePaths {
  static const home = '/';
  static const catalog = '/catalog';
  static const product = '/product/:productId';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orders = '/orders';
  static const profile = '/account';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final appState = ref.watch(appStateProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: AppRoutePaths.home,
    routes: <RouteBase>[
      GoRoute(
        name: AppRouteNames.home,
        path: AppRoutePaths.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        name: AppRouteNames.catalog,
        path: AppRoutePaths.catalog,
        builder: (context, state) => const CatalogScreen(),
      ),
      GoRoute(
        name: AppRouteNames.product,
        path: AppRoutePaths.product,
        builder: (context, state) {
          final productId = state.pathParameters['productId'] ?? '';
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        name: AppRouteNames.cart,
        path: AppRoutePaths.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        name: AppRouteNames.checkout,
        path: AppRoutePaths.checkout,
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        name: AppRouteNames.orders,
        path: AppRoutePaths.orders,
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        name: AppRouteNames.profile,
        path: AppRoutePaths.profile,
        builder: (context, state) => const AccountScreen(),
      ),
    ],
    redirect: (context, state) {
      final requiresAuth = <String>{
        AppRoutePaths.checkout,
        AppRoutePaths.orders,
        AppRoutePaths.profile,
      };

      final isLoggedIn = appState.authSession != null;
      if (!isLoggedIn && requiresAuth.contains(state.uri.path)) {
        return AppRoutePaths.home;
      }

      return null;
    },
  );
});
