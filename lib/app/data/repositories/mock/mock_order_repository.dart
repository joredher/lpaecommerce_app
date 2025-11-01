import '../../models/order.dart';
import '../../services/mock_data_service.dart';
import '../order_repository.dart';

class MockOrderRepository implements OrderRepository {
  MockOrderRepository(this._mockDataService);

  final MockDataService _mockDataService;

  @override
  Future<List<OrderSummary>> fetchOrders({required String customerId}) async {
    return _mockDataService.orders
        .where((order) => order.customer.id == customerId)
        .map<OrderSummary>((order) => order)
        .toList();
  }

  @override
  Future<OrderDetail?> fetchOrderDetail({
    required String orderId,
    required String customerId,
  }) async {
    try {
      final order = _mockDataService.orders.firstWhere(
        (item) => item.id == orderId && item.customer.id == customerId,
      );
      return order;
    } catch (_) {
      return null;
    }
  }
}
