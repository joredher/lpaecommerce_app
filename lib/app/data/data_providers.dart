import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'models/user_profile.dart';
import 'repositories/admin_repository.dart';
import 'repositories/auth_repository.dart';
import 'repositories/catalog_repository.dart';
import 'repositories/order_repository.dart';
import 'repositories/support_repository.dart';
import 'repositories/mock/mock_admin_repository.dart';
import 'repositories/mock/mock_auth_repository.dart';
import 'repositories/mock/mock_catalog_repository.dart';
import 'repositories/mock/mock_order_repository.dart';
import 'repositories/mock/mock_support_repository.dart';
import 'services/mock_data_service.dart';

final mockDataServiceProvider = Provider<MockDataService>((ref) {
  return MockDataService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataService = ref.watch(mockDataServiceProvider);
  return MockAuthRepository(dataService);
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final dataService = ref.watch(mockDataServiceProvider);
  return MockCatalogRepository(dataService);
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dataService = ref.watch(mockDataServiceProvider);
  return MockOrderRepository(dataService);
});

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  final dataService = ref.watch(mockDataServiceProvider);
  return MockSupportRepository(dataService);
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final dataService = ref.watch(mockDataServiceProvider);
  return MockAdminRepository(dataService);
});

final guestProfileProvider = Provider<UserProfile>((ref) {
  return UserProfile(
    id: 'guest',
    email: 'guest@lpaecomms.test',
    displayName: 'Guest',
    role: UserRole.guest,
    verificationStatus: VerificationStatus.unverified,
  );
});
