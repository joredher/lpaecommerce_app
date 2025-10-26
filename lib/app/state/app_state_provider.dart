import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the currently authenticated user session, if any.
@immutable
class AuthSession {
  const AuthSession({
    required this.userId,
    required this.email,
  });

  final String userId;
  final String email;
}

/// Lightweight representation of an item that appears in the shopper's cart.
@immutable
class CartItem {
  const CartItem({
    required this.productId,
    this.quantity = 1,
  });

  final String productId;
  final int quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// Aggregate global state for the client.
@immutable
class AppState {
  const AppState({
    this.authSession,
    this.cartItems = const <CartItem>[],
    this.favoriteProductIds = const <String>{},
  });

  final AuthSession? authSession;
  final List<CartItem> cartItems;
  final Set<String> favoriteProductIds;

  AppState copyWith({
    AuthSession? authSession,
    List<CartItem>? cartItems,
    Set<String>? favoriteProductIds,
  }) {
    return AppState(
      authSession: authSession ?? this.authSession,
      cartItems: cartItems ?? this.cartItems,
      favoriteProductIds: favoriteProductIds ?? this.favoriteProductIds,
    );
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(const AppState());

  void signIn(AuthSession session) {
    state = state.copyWith(authSession: session);
  }

  void signOut() {
    state = const AppState();
  }

  void addToCart(CartItem item) {
    final items = List<CartItem>.from(state.cartItems);
    final index = items.indexWhere((element) => element.productId == item.productId);
    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + item.quantity,
      );
    } else {
      items.add(item);
    }
    state = state.copyWith(cartItems: items);
  }

  void updateCartItemQuantity(String productId, int quantity) {
    final items = state.cartItems.map((item) {
      if (item.productId == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).where((item) => item.quantity > 0).toList(growable: false);
    state = state.copyWith(cartItems: items);
  }

  void clearCart() {
    state = state.copyWith(cartItems: const <CartItem>[]);
  }

  void toggleFavorite(String productId) {
    final favorites = Set<String>.from(state.favoriteProductIds);
    if (!favorites.add(productId)) {
      favorites.remove(productId);
    }
    state = state.copyWith(favoriteProductIds: favorites);
  }
}

final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) => AppStateNotifier());
