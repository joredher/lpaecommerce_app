import 'dart:async';

import '../../models/user_profile.dart';
import '../../services/mock_data_service.dart';
import '../auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._mockDataService);

  final MockDataService _mockDataService;
  AuthSession? _cached;

  @override
  Future<AuthSession?> getCachedSession() async {
    return _cached;
  }

  @override
  Future<AuthSession> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final profile = _mockDataService.findUserByEmail(email);
    if (profile == null) {
      throw StateError('Invalid credentials');
    }
    _cached = AuthSession(token: 'mock-token-${profile.id}', profile: profile);
    return _cached!;
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    final existing = _mockDataService.findUserByEmail(email);
    if (existing != null) {
      throw StateError('Email already registered');
    }
    final profile = UserProfile(
      id: 'reg-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: displayName,
      role: UserRole.customer,
      verificationStatus: VerificationStatus.pending,
    );
    _mockDataService.upsertUser(profile);
    _cached = AuthSession(token: 'mock-token-${profile.id}', profile: profile);
    return _cached!;
  }

  @override
  Future<void> sendEmailVerification(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> verifyEmail({required String email, required String code}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final profile = _mockDataService.findUserByEmail(email);
    if (profile == null) {
      throw StateError('Account not found');
    }
    final updated = profile.copyWith(verificationStatus: VerificationStatus.verified);
    _mockDataService.upsertUser(updated);
    if (_cached != null && _cached!.profile.id == profile.id) {
      _cached = AuthSession(
        token: _cached!.token,
        profile: updated,
      );
    }
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String password,
    required String code,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _cached = null;
  }
}
