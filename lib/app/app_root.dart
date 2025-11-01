import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'routing/app_router.dart';
import 'state/accessibility/accessibility_controller.dart';
import 'state/auth/auth_controller.dart';
import 'theme/app_theme.dart';

class AppRoot extends ConsumerStatefulWidget {
  const AppRoot({super.key});

  @override
  ConsumerState<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      final messenger = _scaffoldMessengerKey.currentState;
      if (messenger == null) {
        return;
      }
      if (next.errorMessage != null && next.errorMessage != previous?.errorMessage) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red.shade700,
          ),
        );
      } else if (next.infoMessage != null && next.infoMessage != previous?.infoMessage) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(next.infoMessage!),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final prefs = ref.watch(accessibilityControllerProvider);

    return prefs.when(
      data: (preferences) {
        final theme = AppTheme.buildTheme(preferences);
        final darkTheme = AppTheme.buildTheme(preferences, dark: true);
        return MaterialApp.router(
          scaffoldMessengerKey: _scaffoldMessengerKey,
          debugShowCheckedModeBanner: false,
          title: 'LPA eComms',
          theme: theme,
          darkTheme: darkTheme,
          themeMode: AppTheme.themeMode(preferences),
          routerConfig: router,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
        );
      },
      loading: () => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Text('Failed to load preferences: $error'),
          ),
        ),
      ),
    );
  }
}
