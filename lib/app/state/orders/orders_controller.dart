import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_providers.dart';
import '../../data/models/order.dart';
import '../../data/repositories/order_repository.dart';
import '../auth/auth_controller.dart';

class OrdersState {
  const OrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<OrderSummary> orders;
  final bool isLoading;
  final String? errorMessage;

  OrdersState copyWith({List<OrderSummary>? orders, bool? isLoading, String? errorMessage}) {
    return OrdersState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class OrdersController extends StateNotifier<OrdersState> {
  OrdersController(this._repository, this._read) : super(const OrdersState());

  final OrderRepository _repository;
  final Reader _read;

  Future<void> refresh() async {
    final session = _read(authControllerProvider).session;
    if (session == null) {
      state = const OrdersState();
      return;
    }
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final orders = await _repository.fetchOrders(customerId: session.profile.id);
      state = state.copyWith(orders: orders, isLoading: false);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }
}

final ordersControllerProvider = StateNotifierProvider<OrdersController, OrdersState>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  final controller = OrdersController(repository, ref.read);
  ref.listen<AuthState>(authControllerProvider, (_, next) {
    if (next.session != null) {
      controller.refresh();
    } else {
      controller.state = const OrdersState();
    }
  });
  final authState = ref.read(authControllerProvider);
  if (authState.session != null) {
    controller.refresh();
  }
  return controller;
});
