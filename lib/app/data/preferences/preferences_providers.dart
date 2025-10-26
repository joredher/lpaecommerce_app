import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kHasCompletedOnboardingKey = 'has_completed_onboarding';

final onboardingStateProvider =
    AsyncNotifierProvider<OnboardingStateNotifier, bool>(
  OnboardingStateNotifier.new,
);

class OnboardingStateNotifier extends AsyncNotifier<bool> {
  SharedPreferences? _preferences;

  @override
  Future<bool> build() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences!.getBool(_kHasCompletedOnboardingKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final prefs = _preferences ?? await SharedPreferences.getInstance();
      _preferences = prefs;
      await prefs.setBool(_kHasCompletedOnboardingKey, true);
      return true;
    });

    state = result;
    if (result.hasError) {
      final stackTrace = result.stackTrace ?? StackTrace.current;
      Error.throwWithStackTrace(result.error!, stackTrace);
    }
  }
}
