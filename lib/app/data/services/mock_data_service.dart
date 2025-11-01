import 'dart:math';

import 'package:uuid/uuid.dart';

import '../models/cart.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../models/support_ticket.dart';
import '../models/user_profile.dart';

class MockDataService {
  MockDataService() {
    _seedProducts();
    _seedUsers();
    _seedOrders();
    _seedSupportTickets();
  }

  final _uuid = const Uuid();
  final _random = Random(42);

  final List<Product> _products = [];
  final List<UserProfile> _users = [];
  final List<OrderDetail> _orders = [];
  final List<SupportTicket> _tickets = [];

  List<Product> get products => List.unmodifiable(_products);
  List<UserProfile> get users => List.unmodifiable(_users);
  List<OrderDetail> get orders => List.unmodifiable(_orders);
  List<SupportTicket> get tickets => List.unmodifiable(_tickets);

  UserProfile? findUserByEmail(String email) {
    final lowered = email.toLowerCase();
    try {
      return _users.firstWhere(
        (user) => user.email.toLowerCase() == lowered,
      );
    } catch (_) {
      return null;
    }
  }

  void upsertUser(UserProfile profile) {
    final index = _users.indexWhere((user) => user.id == profile.id);
    if (index >= 0) {
      _users[index] = profile;
    } else {
      _users.add(profile);
    }
  }

  Product? findProductById(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (_) {
      return null;
    }
  }

  Product? findProductBySlug(String slug) {
    try {
      return _products.firstWhere((product) => product.slug == slug);
    } catch (_) {
      return null;
    }
  }

  void upsertProduct(Product product) {
    final index = _products.indexWhere((element) => element.id == product.id);
    if (index >= 0) {
      _products[index] = product;
    } else {
      _products.add(product);
    }
  }

  void deleteProduct(String productId) {
    _products.removeWhere((product) => product.id == productId);
  }

  OrderDetail? findOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (_) {
      return null;
    }
  }

  void replaceOrder(OrderDetail order) {
    final index = _orders.indexWhere((element) => element.id == order.id);
    if (index >= 0) {
      _orders[index] = order;
    } else {
      _orders.add(order);
    }
  }

  SupportTicket? findTicketById(String ticketId) {
    try {
      return _tickets.firstWhere((ticket) => ticket.id == ticketId);
    } catch (_) {
      return null;
    }
  }

  void upsertTicket(SupportTicket ticket) {
    final index = _tickets.indexWhere((element) => element.id == ticket.id);
    if (index >= 0) {
      _tickets[index] = ticket;
    } else {
      _tickets.add(ticket);
    }
  }

  void _seedProducts() {
    final sampleImages = [
      const ProductImage(url: 'https://picsum.photos/seed/lpa-01/600/600', alt: 'Product hero image'),
      const ProductImage(url: 'https://picsum.photos/seed/lpa-02/600/600', alt: 'Product gallery image'),
      const ProductImage(url: 'https://picsum.photos/seed/lpa-03/600/600', alt: 'Angle view image'),
    ];

    final categories = ['Office', 'Technology', 'Accessories'];

    for (var index = 0; index < 24; index++) {
      final category = categories[index % categories.length];
      final price = 49.99 + _random.nextInt(400);
      final product = Product(
        id: _uuid.v4(),
        slug: 'product-$index',
        name: 'Sample Product ${index + 1}',
        description:
            'A carefully crafted item from the LPA range, engineered to match the PHP storefront experience.',
        price: double.parse(price.toStringAsFixed(2)),
        currency: 'AUD',
        inventory: 20 + _random.nextInt(50),
        category: category,
        images: sampleImages,
        features: const [
          ProductFeature(label: 'Warranty', value: '24 months'),
          ProductFeature(label: 'Fulfilment', value: 'Ships in 2-3 business days'),
        ],
        badges: [if (index.isEven) 'Popular', if (price < 120) 'Value pick'],
      );
      _products.add(product);
    }
  }

  void _seedUsers() {
    _users.addAll([
      UserProfile(
        id: _uuid.v4(),
        email: 'guest@lpa.test',
        displayName: 'Guest user',
        role: UserRole.guest,
        verificationStatus: VerificationStatus.unverified,
      ),
      UserProfile(
        id: _uuid.v4(),
        email: 'customer@lpa.test',
        displayName: 'LPA Customer',
        role: UserRole.customer,
        verificationStatus: VerificationStatus.verified,
      ),
      UserProfile(
        id: _uuid.v4(),
        email: 'admin@lpa.test',
        displayName: 'LPA Admin',
        role: UserRole.admin,
        verificationStatus: VerificationStatus.verified,
      ),
    ]);
  }

  void _seedOrders() {
    if (_users.length < 2 || _products.isEmpty) {
      return;
    }

    final customer = _users.firstWhere((user) => user.role == UserRole.customer);
    final cart = Cart(
      items: _products.take(3).map((product) => CartItem(product: product, quantity: 1 + _random.nextInt(3))).toList(),
    );

    _orders.add(
      OrderDetail(
        id: _uuid.v4(),
        number: '#100045',
        placedAt: DateTime.now().subtract(const Duration(days: 3)),
        cart: cart,
        status: OrderStatus.processing,
        paymentStatus: PaymentStatus.paid,
        fulfilmentStatus: FulfilmentStatus.picking,
        billingAddress: const OrderAddress(
          fullName: 'LPA Customer',
          line1: '123 Main Street',
          city: 'Sydney',
          state: 'NSW',
          postcode: '2000',
          country: 'Australia',
        ),
        shippingAddress: const OrderAddress(
          fullName: 'LPA Customer',
          line1: '123 Main Street',
          city: 'Sydney',
          state: 'NSW',
          postcode: '2000',
          country: 'Australia',
        ),
        customer: customer,
        notes: 'Leave at reception if unattended.',
      ),
    );
  }

  void _seedSupportTickets() {
    if (_users.isEmpty) {
      return;
    }

    final user = _users.firstWhere((u) => u.role == UserRole.customer);
    _tickets.add(
      SupportTicket(
        id: _uuid.v4(),
        reference: 'SUP-9021',
        subject: 'Delivery ETA',
        message: 'Can I adjust the delivery window for order #100045?',
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
        status: SupportTicketStatus.awaitingCustomer,
        channel: SupportChannel.email,
        assignee: 'LPA Logistics',
      ),
    );
  }
}
