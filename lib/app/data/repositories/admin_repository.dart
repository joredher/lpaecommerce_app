import '../models/order.dart';
import '../models/product.dart';
import '../models/support_ticket.dart';
import '../models/user_profile.dart';

class DashboardMetrics {
  const DashboardMetrics({
    required this.totalRevenue,
    required this.activeCustomers,
    required this.pendingOrders,
    required this.lowStockCount,
  });

  final double totalRevenue;
  final int activeCustomers;
  final int pendingOrders;
  final int lowStockCount;
}

abstract class AdminRepository {
  Future<DashboardMetrics> loadDashboardMetrics();

  Future<List<Product>> searchProducts({String? query});

  Future<Product> saveProduct(Product product);

  Future<void> deleteProduct(String productId);

  Future<List<OrderSummary>> fetchOrders({OrderStatus? status});

  Future<OrderDetail?> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  });

  Future<List<UserProfile>> searchUsers({String? query, UserRole? role});

  Future<UserProfile> toggleUserStatus({
    required String userId,
    required bool isActive,
  });

  Future<List<SupportTicket>> fetchTickets({SupportTicketStatus? status});
}
