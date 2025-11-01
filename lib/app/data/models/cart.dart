import 'package:equatable/equatable.dart';

import 'product.dart';

class CartItem extends Equatable {
  const CartItem({required this.product, required this.quantity});

  final Product product;
  final int quantity;

  double get lineTotal => product.price * quantity;

  CartItem copyWith({Product? product, int? quantity}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [product, quantity];
}

class Cart extends Equatable {
  const Cart({this.items = const []});

  final List<CartItem> items;

  double get subtotal => items.fold(0, (value, item) => value + item.lineTotal);
  double get taxes => subtotal * 0.1;
  double get total => subtotal + taxes;
  bool get isEmpty => items.isEmpty;

  Cart addItem(Product product, {int quantity = 1}) {
    final list = List<CartItem>.from(items);
    final index = list.indexWhere((element) => element.product.id == product.id);
    if (index >= 0) {
      final existing = list[index];
      list[index] = existing.copyWith(quantity: existing.quantity + quantity);
    } else {
      list.add(CartItem(product: product, quantity: quantity));
    }
    return Cart(items: list);
  }

  Cart updateQuantity(String productId, int quantity) {
    final list = items
        .map((item) => item.product.id == productId
            ? item.copyWith(quantity: quantity)
            : item)
        .where((item) => item.quantity > 0)
        .toList(growable: false);
    return Cart(items: list);
  }

  Cart remove(String productId) {
    final list = items
        .where((item) => item.product.id != productId)
        .toList(growable: false);
    return Cart(items: list);
  }

  Cart clear() => const Cart();

  @override
  List<Object?> get props => [items];
}
