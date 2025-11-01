import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_providers.dart';
import '../../data/models/order.dart';
import '../../data/models/product.dart';
import '../../data/models/support_ticket.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/admin_repository.dart';

class AdminDashboardState {
  const AdminDashboardState({
    this.metrics,
    this.products = const [],
    this.orders = const [],
    this.users = const [],
    this.tickets = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final DashboardMetrics? metrics;
  final List<Product> products;
  final List<OrderSummary> orders;
  final List<UserProfile> users;
  final List<SupportTicket> tickets;
  final bool isLoading;
  final String? errorMessage;

  AdminDashboardState copyWith({
    DashboardMetrics? metrics,
    List<Product>? products,
    List<OrderSummary>? orders,
    List<UserProfile>? users,
    List<SupportTicket>? tickets,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AdminDashboardState(
      metrics: metrics ?? this.metrics,
      products: products ?? this.products,
      orders: orders ?? this.orders,
      users: users ?? this.users,
      tickets: tickets ?? this.tickets,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AdminDashboardController extends StateNotifier<AdminDashboardState> {
  AdminDashboardController(this._repository) : super(const AdminDashboardState());

  final AdminRepository _repository;

  Future<void> hydrate() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final metrics = await _repository.loadDashboardMetrics();
      final orders = await _repository.fetchOrders();
      final products = await _repository.searchProducts();
      final tickets = await _repository.fetchTickets();
      final users = await _repository.searchUsers();
      state = state.copyWith(
        metrics: metrics,
        orders: orders,
        products: products,
        tickets: tickets,
        users: users,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }
}

final adminDashboardControllerProvider =
    StateNotifierProvider<AdminDashboardController, AdminDashboardState>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  final controller = AdminDashboardController(repository);
  controller.hydrate();
  return controller;
});
