import '../models/order.dart';

abstract class OrderRepository {
  Future<List<OrderSummary>> fetchOrders({required String customerId});

  Future<OrderDetail?> fetchOrderDetail({
    required String orderId,
    required String customerId,
  });
}
