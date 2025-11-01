import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_providers.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/auth_repository.dart';

class AuthState {
  const AuthState({
    this.session,
    this.isLoading = false,
    this.errorMessage,
    this.infoMessage,
    this.verificationEmailSent = false,
  });

  final AuthSession? session;
  final bool isLoading;
  final String? errorMessage;
  final String? infoMessage;
  final bool verificationEmailSent;

  UserRole get effectiveRole => session?.profile.role ?? UserRole.guest;
  bool get isAuthenticated => session != null;
  bool get isAdmin => session?.profile.role == UserRole.admin;

  AuthState copyWith({
    AuthSession? session,
    bool? isLoading,
    String? errorMessage,
    String? infoMessage,
    bool? verificationEmailSent,
    bool clearError = false,
    bool clearInfo = false,
  }) {
    return AuthState(
      session: session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      infoMessage: clearInfo ? null : infoMessage ?? this.infoMessage,
      verificationEmailSent: verificationEmailSent ?? this.verificationEmailSent,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository, this._guestProfile) : super(const AuthState());

  final AuthRepository _repository;
  final UserProfile _guestProfile;

  Future<void> initialize() async {
    try {
      final session = await _repository.getCachedSession();
      if (session != null) {
        state = state.copyWith(session: session);
      }
    } catch (_) {
      // ignore cached session failures for now
    }
  }

  Future<void> useGuestProfile() async {
    state = state.copyWith(
      session: AuthSession(token: 'guest', profile: _guestProfile),
      infoMessage: 'Browsing as guest',
      clearError: true,
    );
  }

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true, clearInfo: true);
    try {
      final session = await _repository.login(email: email, password: password);
      state = state.copyWith(
        session: session,
        isLoading: false,
        infoMessage: 'Welcome back ${session.profile.displayName}',
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true, clearInfo: true);
    try {
      final session = await _repository.register(
        email: email,
        password: password,
        displayName: displayName,
      );
      state = state.copyWith(
        session: session,
        isLoading: false,
        infoMessage: 'Check your inbox to verify the account',
        verificationEmailSent: true,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> sendVerificationEmail() async {
    final email = state.session?.profile.email;
    if (email == null) {
      return;
    }
    try {
      await _repository.sendEmailVerification(email);
      state = state.copyWith(verificationEmailSent: true, infoMessage: 'Verification email sent');
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
    }
  }

  Future<void> verifyEmail({required String code}) async {
    final email = state.session?.profile.email;
    if (email == null) {
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.verifyEmail(email: email, code: code);
      final session = state.session;
      if (session != null) {
        state = state.copyWith(
          session: AuthSession(
            token: session.token,
            profile: session.profile.copyWith(
              verificationStatus: VerificationStatus.verified,
            ),
          ),
          isLoading: false,
          infoMessage: 'Email verified successfully',
          verificationEmailSent: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> sendPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.sendPasswordReset(email);
      state = state.copyWith(isLoading: false, infoMessage: 'Password reset email sent');
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> resetPassword({
    required String email,
    required String password,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.resetPassword(email: email, password: password, code: code);
      state = state.copyWith(isLoading: false, infoMessage: 'Password updated, please sign in');
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.logout();
    } finally {
      state = const AuthState();
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final guestProfile = ref.watch(guestProfileProvider);
  final controller = AuthController(repository, guestProfile);
  controller.initialize();
  return controller;
});
