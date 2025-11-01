import 'package:flutter/material.dart';

import '../state/accessibility/accessibility_controller.dart';

class AppTheme {
  static const _brandBlue = Color(0xFF003459);
  static const _brandTeal = Color(0xFF0F6E6E);
  static const _brandLime = Color(0xFFB6E67B);
  static const _brandNavy = Color(0xFF012A4A);

  static ThemeData buildTheme(AccessibilityPreferences prefs, {bool dark = false}) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: _brandBlue,
      brightness: dark ? Brightness.dark : Brightness.light,
    );

    final scheme = prefs.highContrast
        ? baseScheme.copyWith(
            primary: dark ? _brandLime : _brandBlue,
            secondary: dark ? _brandLime : _brandTeal,
            surface: dark ? _brandNavy : Colors.white,
            onSurface: dark ? Colors.white : _brandNavy,
            outline: prefs.focusHighlight ? Colors.amber : baseScheme.outline,
          )
        : baseScheme;

    final textTheme = Typography.material2021(platform: TargetPlatform.android)
        .black
        .apply(fontSizeFactor: prefs.textScale);
    final darkTextTheme = Typography.material2021(platform: TargetPlatform.android)
        .white
        .apply(fontSizeFactor: prefs.textScale);

    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      brightness: scheme.brightness,
      textTheme: dark ? darkTextTheme : textTheme,
      scaffoldBackgroundColor: dark ? scheme.surface : const Color(0xFFF4F6F8),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16 * prefs.textScale,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: scheme.primary, width: 1.4),
          foregroundColor: scheme.primary,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.secondaryContainer,
        selectedColor: scheme.primaryContainer,
        labelStyle: TextStyle(color: scheme.onSecondaryContainer, fontSize: 14 * prefs.textScale),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: scheme.surface,
      ),
      sliderTheme: SliderThemeData(
        thumbColor: scheme.primary,
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.primary.withOpacity(0.2),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.primary,
        tileColor: scheme.surface,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(scheme.primary),
        checkColor: WidgetStateProperty.all(scheme.onPrimary),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(scheme.primary),
        trackColor: WidgetStateProperty.all(scheme.primary.withOpacity(0.4)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: dark ? scheme.surface : Colors.white,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20 * prefs.textScale,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(fontWeight: FontWeight.w600, fontSize: 12 * prefs.textScale),
        ),
        indicatorColor: scheme.primary.withOpacity(0.2),
      ),
    );
  }

  static ThemeMode themeMode(AccessibilityPreferences prefs) {
    return prefs.darkMode ? ThemeMode.dark : ThemeMode.light;
  }
}
