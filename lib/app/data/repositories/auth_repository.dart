import '../models/user_profile.dart';

class AuthSession {
  const AuthSession({required this.token, required this.profile});

  final String token;
  final UserProfile profile;
}

abstract class AuthRepository {
  Future<AuthSession?> getCachedSession();

  Future<AuthSession> login({required String email, required String password});

  Future<AuthSession> register({
    required String email,
    required String password,
    required String displayName,
  });

  Future<void> sendEmailVerification(String email);

  Future<void> verifyEmail({required String email, required String code});

  Future<void> sendPasswordReset(String email);

  Future<void> resetPassword({
    required String email,
    required String password,
    required String code,
  });

  Future<void> logout();
}
