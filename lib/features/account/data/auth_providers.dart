import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lpaecomms/app/state/app_state_provider.dart';

import 'auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class SignInController extends StateNotifier<AsyncValue<void>> {
  SignInController(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncValue.loading();
    try {
      final session = await _ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
      _ref.read(appStateProvider.notifier).signIn(session);
      state = const AsyncValue.data(null);
    } on AuthException catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    } catch (error, stackTrace) {
      state = AsyncValue.error(AuthException(error.toString()), stackTrace);
    }
  }

  void clearError() {
    if (state.hasError) {
      state = const AsyncData(null);
    }
  }
}

final signInControllerProvider =
    StateNotifierProvider<SignInController, AsyncValue<void>>((ref) {
  return SignInController(ref);
});
