import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kHasCompletedOnboardingKey = 'has_completed_onboarding';

final onboardingStateProvider =
    AsyncNotifierProvider<OnboardingStateNotifier, bool>(
  OnboardingStateNotifier.new,
);

class OnboardingStateNotifier extends AsyncNotifier<bool> {
  SharedPreferences? _preferences;

  Future<SharedPreferences> _ensurePreferences() async {
    if (_preferences != null) {
      return _preferences!;
    }

    try {
      _preferences = await SharedPreferences.getInstance();
      return _preferences!;
    } on MissingPluginException catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'preferences',
        context: ErrorDescription(
          'while obtaining shared preferences for onboarding state',
        ),
      ));

      SharedPreferences.setMockInitialValues(const <String, Object?>{});
      _preferences = await SharedPreferences.getInstance();
      return _preferences!;
    }
  }

  @override
  Future<bool> build() async {
    final prefs = await _ensurePreferences();
    return prefs.getBool(_kHasCompletedOnboardingKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      final prefs = await _ensurePreferences();
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
