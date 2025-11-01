import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cart.dart';
import '../../data/models/product.dart';

class CartState {
  const CartState({
    this.cart = const Cart(),
    this.appliedCoupon,
    this.errorMessage,
  });

  final Cart cart;
  final String? appliedCoupon;
  final String? errorMessage;

  CartState copyWith({Cart? cart, String? appliedCoupon, String? errorMessage}) {
    return CartState(
      cart: cart ?? this.cart,
      appliedCoupon: appliedCoupon ?? this.appliedCoupon,
      errorMessage: errorMessage,
    );
  }
}

class CartController extends StateNotifier<CartState> {
  CartController() : super(const CartState());

  void addProduct(Product product, {int quantity = 1}) {
    if (quantity <= 0) {
      return;
    }
    final updated = state.cart.addItem(product, quantity: quantity);
    state = state.copyWith(cart: updated, errorMessage: null);
  }

  void updateQuantity(String productId, int quantity) {
    if (quantity < 0) {
      state = state.copyWith(errorMessage: 'Quantity cannot be negative');
      return;
    }
    state = state.copyWith(cart: state.cart.updateQuantity(productId, quantity), errorMessage: null);
  }

  void removeProduct(String productId) {
    state = state.copyWith(cart: state.cart.remove(productId), errorMessage: null);
  }

  void clearCart() {
    state = const CartState();
  }

  void applyCoupon(String? code) {
    state = state.copyWith(appliedCoupon: code?.trim().isEmpty ?? true ? null : code?.trim());
  }
}

final cartControllerProvider = StateNotifierProvider<CartController, CartState>((ref) {
  return CartController();
});
