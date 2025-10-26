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
  bool _useFallback = false;
  bool _fallbackValue = false;

  Future<void> _ensurePreferencesLoaded() async {
    if (_preferences != null || _useFallback) {
      return;
    }

    try {
      _preferences = await SharedPreferences.getInstance();
    } on MissingPluginException catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'preferences',
        context: ErrorDescription(
          'while obtaining shared preferences for onboarding state',
        ),
      ));

      _useFallback = true;
      _fallbackValue = false;
    }
  }

  @override
  Future<bool> build() async {
    await _ensurePreferencesLoaded();

    if (_useFallback) {
      return _fallbackValue;
    }

    final prefs = _preferences!;
    return prefs.getBool(_kHasCompletedOnboardingKey) ?? false;
  }

  Future<void> completeOnboarding() async {
    state = const AsyncLoading();
    final result = await AsyncValue.guard(() async {
      await _ensurePreferencesLoaded();

      if (_useFallback) {
        _fallbackValue = true;
        return true;
      }

      final prefs = _preferences!;
      final didPersist = await prefs.setBool(_kHasCompletedOnboardingKey, true);
      if (!didPersist) {
        throw StateError('Failed to persist onboarding completion flag');
      }
      return true;
    });

    state = result;
    if (result.hasError) {
      final stackTrace = result.stackTrace ?? StackTrace.current;
      Error.throwWithStackTrace(result.error!, stackTrace);
    }
  }
}
