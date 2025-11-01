import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../state/auth/auth_controller.dart';
import '../../features/account/presentation/account_screen.dart';
import '../../features/account/presentation/login_screen.dart';
import '../../features/account/presentation/password_reset_screen.dart';
import '../../features/account/presentation/registration_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/catalog/presentation/product_detail_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/storefront/presentation/catalog_screen.dart';
import '../../features/storefront/presentation/storefront_home_screen.dart';
import '../../features/storefront/presentation/storefront_shell.dart';
import '../../features/support/presentation/support_center_screen.dart';

class AppRouteNames {
  static const onboarding = 'onboarding';
  static const login = 'login';
  static const register = 'register';
  static const passwordReset = 'password-reset';
  static const storefrontHome = 'storefront-home';
  static const catalog = 'catalog';
  static const product = 'product';
  static const cart = 'cart';
  static const checkout = 'checkout';
  static const orders = 'orders';
  static const account = 'account';
  static const support = 'support';
  static const adminDashboard = 'admin-dashboard';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  final authNotifier = ref.watch(authControllerProvider.notifier);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),
    routes: [
      GoRoute(
        path: '/',
        name: AppRouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: AppRouteNames.register,
        builder: (context, state) => const RegistrationScreen(),
      ),
      GoRoute(
        path: '/password-reset',
        name: AppRouteNames.passwordReset,
        builder: (context, state) => const PasswordResetScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => StorefrontShell(state: state, child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: AppRouteNames.storefrontHome,
            builder: (context, state) => const StorefrontHomeScreen(),
          ),
          GoRoute(
            path: '/catalog',
            name: AppRouteNames.catalog,
            builder: (context, state) => const CatalogScreen(),
          ),
          GoRoute(
            path: '/product/:slug',
            name: AppRouteNames.product,
            builder: (context, state) {
              final slug = state.pathParameters['slug']!;
              return ProductDetailScreen(slug: slug);
            },
          ),
          GoRoute(
            path: '/cart',
            name: AppRouteNames.cart,
            builder: (context, state) => const CartScreen(),
          ),
          GoRoute(
            path: '/checkout',
            name: AppRouteNames.checkout,
            builder: (context, state) => const CheckoutScreen(),
          ),
          GoRoute(
            path: '/orders',
            name: AppRouteNames.orders,
            builder: (context, state) => const OrdersScreen(),
          ),
          GoRoute(
            path: '/account',
            name: AppRouteNames.account,
            builder: (context, state) => const AccountScreen(),
          ),
          GoRoute(
            path: '/support',
            name: AppRouteNames.support,
            builder: (context, state) => const SupportCenterScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/admin',
        name: AppRouteNames.adminDashboard,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
    ],
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/password-reset';
      final isAuthenticated = authState.isAuthenticated;
      final isAdmin = authState.isAdmin;
      final requiresAuth = state.matchedLocation == '/account' ||
          state.matchedLocation == '/orders' ||
          state.matchedLocation == '/checkout';
      final accessingAdmin = state.matchedLocation.startsWith('/admin');

      if (!isAuthenticated && requiresAuth) {
        return '/login';
      }

      if (isAuthenticated && (state.matchedLocation == '/' || loggingIn)) {
        return '/home';
      }

      if (accessingAdmin && !isAdmin) {
        return '/home';
      }

      return null;
    },
  );
});
