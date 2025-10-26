import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app_root.dart';
import 'app/state/app_state_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  // Touch the app state notifier to ensure eager initialization before runApp.
  container.read(appStateProvider.notifier);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AppRoot(),
    ),
  );
}
