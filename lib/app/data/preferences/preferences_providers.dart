import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kHasCompletedOnboardingKey = 'has_completed_onboarding';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden');
});

final onboardingStateProvider =
    StateNotifierProvider<OnboardingStateNotifier, bool>((ref) {
  final preferences = ref.watch(sharedPreferencesProvider);
  final hasCompleted =
      preferences.getBool(_kHasCompletedOnboardingKey) ?? false;
  return OnboardingStateNotifier(preferences, hasCompleted);
});

class OnboardingStateNotifier extends StateNotifier<bool> {
  OnboardingStateNotifier(this._preferences, bool hasCompleted)
      : super(hasCompleted);

  final SharedPreferences _preferences;

  Future<void> completeOnboarding() async {
    state = true;
    await _preferences.setBool(_kHasCompletedOnboardingKey, true);
  }
}

