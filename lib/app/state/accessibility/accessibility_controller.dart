import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences_with_cache.dart';

const _prefsKey = 'lpa_accessibility_prefs_v1';

class AccessibilityPreferences {
  const AccessibilityPreferences({
    this.darkMode = false,
    this.highContrast = false,
    this.textScale = 1.0,
    this.reduceMotion = false,
    this.underlineLinks = false,
    this.focusHighlight = true,
  });

  final bool darkMode;
  final bool highContrast;
  final double textScale;
  final bool reduceMotion;
  final bool underlineLinks;
  final bool focusHighlight;

  AccessibilityPreferences copyWith({
    bool? darkMode,
    bool? highContrast,
    double? textScale,
    bool? reduceMotion,
    bool? underlineLinks,
    bool? focusHighlight,
  }) {
    return AccessibilityPreferences(
      darkMode: darkMode ?? this.darkMode,
      highContrast: highContrast ?? this.highContrast,
      textScale: textScale ?? this.textScale,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      underlineLinks: underlineLinks ?? this.underlineLinks,
      focusHighlight: focusHighlight ?? this.focusHighlight,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'darkMode': darkMode,
      'highContrast': highContrast,
      'textScale': textScale,
      'reduceMotion': reduceMotion,
      'underlineLinks': underlineLinks,
      'focusHighlight': focusHighlight,
    };
  }

  static AccessibilityPreferences fromJson(Map<String, dynamic> json) {
    return AccessibilityPreferences(
      darkMode: json['darkMode'] as bool? ?? false,
      highContrast: json['highContrast'] as bool? ?? false,
      textScale: (json['textScale'] as num?)?.toDouble() ?? 1.0,
      reduceMotion: json['reduceMotion'] as bool? ?? false,
      underlineLinks: json['underlineLinks'] as bool? ?? false,
      focusHighlight: json['focusHighlight'] as bool? ?? true,
    );
  }
}

class AccessibilityController extends AsyncNotifier<AccessibilityPreferences> {
  SharedPreferences? _preferences;

  @override
  Future<AccessibilityPreferences> build() async {
    _preferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        sharedPreferencesPrefix: 'lpaecomms.',
      ),
    );
    final raw = _preferences!.getString(_prefsKey);
    if (raw == null) {
      return const AccessibilityPreferences();
    }
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return AccessibilityPreferences.fromJson(json);
    } catch (_) {
      return const AccessibilityPreferences();
    }
  }

  Future<void> _persist(AccessibilityPreferences prefs) async {
    state = AsyncData(prefs);
    await _preferences?.setString(_prefsKey, jsonEncode(prefs.toJson()));
  }

  Future<void> toggleDarkMode() async {
    final prefs = (state.value ?? const AccessibilityPreferences()).copyWith(
      darkMode: !(state.value?.darkMode ?? false),
    );
    await _persist(prefs);
  }

  Future<void> toggleHighContrast() async {
    final prefs = (state.value ?? const AccessibilityPreferences()).copyWith(
      highContrast: !(state.value?.highContrast ?? false),
    );
    await _persist(prefs);
  }

  Future<void> toggleReduceMotion() async {
    final prefs = (state.value ?? const AccessibilityPreferences()).copyWith(
      reduceMotion: !(state.value?.reduceMotion ?? false),
    );
    await _persist(prefs);
  }

  Future<void> toggleUnderlineLinks() async {
    final prefs = (state.value ?? const AccessibilityPreferences()).copyWith(
      underlineLinks: !(state.value?.underlineLinks ?? false),
    );
    await _persist(prefs);
  }

  Future<void> toggleFocusHighlight() async {
    final prefs = (state.value ?? const AccessibilityPreferences()).copyWith(
      focusHighlight: !(state.value?.focusHighlight ?? true),
    );
    await _persist(prefs);
  }

  Future<void> updateTextScale(double scale) async {
    final clamped = scale.clamp(0.8, 1.6);
    final prefs = (state.value ?? const AccessibilityPreferences()).copyWith(textScale: clamped);
    await _persist(prefs);
  }
}

final accessibilityControllerProvider =
    AsyncNotifierProvider<AccessibilityController, AccessibilityPreferences>(AccessibilityController.new);
