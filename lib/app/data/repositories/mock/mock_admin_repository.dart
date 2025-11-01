import '../../models/order.dart';
import '../../models/product.dart';
import '../../models/support_ticket.dart';
import '../../models/user_profile.dart';
import '../../services/mock_data_service.dart';
import '../admin_repository.dart';

class MockAdminRepository implements AdminRepository {
  MockAdminRepository(this._mockDataService);

  final MockDataService _mockDataService;

  @override
  Future<DashboardMetrics> loadDashboardMetrics() async {
    final revenue = _mockDataService.orders
        .map((order) => order.cart.total)
        .fold<double>(0, (previous, amount) => previous + amount);
    final customers = _mockDataService.users.where((user) => user.role == UserRole.customer).length;
    final pendingOrders = _mockDataService.orders
        .where((order) => order.status == OrderStatus.pending || order.status == OrderStatus.processing)
        .length;
    final lowStock = _mockDataService.products.where((product) => product.inventory < 10).length;
    return DashboardMetrics(
      totalRevenue: revenue,
      activeCustomers: customers,
      pendingOrders: pendingOrders,
      lowStockCount: lowStock,
    );
  }

  @override
  Future<List<Product>> searchProducts({String? query}) async {
    final needle = query?.toLowerCase() ?? '';
    if (needle.isEmpty) {
      return _mockDataService.products;
    }
    return _mockDataService.products
        .where((product) =>
            product.name.toLowerCase().contains(needle) || product.description.toLowerCase().contains(needle))
        .toList();
  }

  @override
  Future<Product> saveProduct(Product product) async {
    _mockDataService.upsertProduct(product);
    return product;
  }

  @override
  Future<void> deleteProduct(String productId) async {
    _mockDataService.deleteProduct(productId);
  }

  @override
  Future<List<OrderSummary>> fetchOrders({OrderStatus? status}) async {
    return _mockDataService.orders
        .where((order) => status == null || order.status == status)
        .map<OrderSummary>((order) => order)
        .toList();
  }

  @override
  Future<OrderDetail?> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    final existing = _mockDataService.findOrderById(orderId);
    if (existing == null) {
      return null;
    }
    final updated = OrderDetail(
      id: existing.id,
      number: existing.number,
      placedAt: existing.placedAt,
      cart: existing.cart,
      status: status,
      paymentStatus: existing.paymentStatus,
      fulfilmentStatus: existing.fulfilmentStatus,
      billingAddress: existing.billingAddress,
      shippingAddress: existing.shippingAddress,
      customer: existing.customer,
      notes: existing.notes,
    );
    _mockDataService.replaceOrder(updated);
    return updated;
  }

  @override
  Future<List<UserProfile>> searchUsers({String? query, UserRole? role}) async {
    final needle = query?.toLowerCase() ?? '';
    return _mockDataService.users
        .where((user) => (role == null || user.role == role) &&
            (needle.isEmpty || user.email.toLowerCase().contains(needle) ||
                user.displayName.toLowerCase().contains(needle)))
        .toList();
  }

  @override
  Future<UserProfile> toggleUserStatus({required String userId, required bool isActive}) async {
    final user = _mockDataService.users.firstWhere((element) => element.id == userId);
    final updated = user.copyWith(
      verificationStatus: isActive ? VerificationStatus.verified : VerificationStatus.pending,
    );
    _mockDataService.upsertUser(updated);
    return updated;
  }

  @override
  Future<List<SupportTicket>> fetchTickets({SupportTicketStatus? status}) async {
    return _mockDataService.tickets
        .where((ticket) => status == null || ticket.status == status)
        .toList();
  }
}
