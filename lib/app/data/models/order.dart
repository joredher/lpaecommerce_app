import 'package:equatable/equatable.dart';

import 'cart.dart';
import 'user_profile.dart';

enum OrderStatus { pending, processing, completed, cancelled }

enum PaymentStatus { awaiting, paid, refunded }

enum FulfilmentStatus { notStarted, picking, shipped, delivered }

class OrderAddress extends Equatable {
  const OrderAddress({
    required this.fullName,
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.postcode,
    required this.country,
    this.phone,
  });

  final String fullName;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String postcode;
  final String country;
  final String? phone;

  @override
  List<Object?> get props => [
        fullName,
        line1,
        line2,
        city,
        state,
        postcode,
        country,
        phone,
      ];
}

class OrderSummary extends Equatable {
  const OrderSummary({
    required this.id,
    required this.number,
    required this.placedAt,
    required this.cart,
    required this.status,
    required this.paymentStatus,
    required this.fulfilmentStatus,
    required this.billingAddress,
    required this.shippingAddress,
  });

  final String id;
  final String number;
  final DateTime placedAt;
  final Cart cart;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final FulfilmentStatus fulfilmentStatus;
  final OrderAddress billingAddress;
  final OrderAddress shippingAddress;

  @override
  List<Object?> get props => [
        id,
        number,
        placedAt,
        cart,
        status,
        paymentStatus,
        fulfilmentStatus,
        billingAddress,
        shippingAddress,
      ];
}

class OrderDetail extends OrderSummary {
  const OrderDetail({
    required super.id,
    required super.number,
    required super.placedAt,
    required super.cart,
    required super.status,
    required super.paymentStatus,
    required super.fulfilmentStatus,
    required super.billingAddress,
    required super.shippingAddress,
    required this.customer,
    this.notes,
  });

  final UserProfile customer;
  final String? notes;

  @override
  List<Object?> get props => super.props..addAll([customer, notes]);
}
