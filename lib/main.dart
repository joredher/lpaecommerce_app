import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app_root.dart';
import 'app/data/database/database_providers.dart';
import 'app/state/app_state_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  // Touch the app state notifier to ensure eager initialization before runApp.
  container.read(appStateProvider.notifier);

  // Warm up the database connection before rendering the UI. This allows us to
  // surface connection issues early in the startup sequence.
  // ignore: unused_result
  container.listen(
    databaseConnectionProvider,
    (_, __) {},
  );

  try {
    await container.read(databaseConnectionProvider.future);
  } catch (error, stackTrace) {
    FlutterError.reportError(FlutterErrorDetails(
      exception: error,
      stack: stackTrace,
      library: 'database',
      context: ErrorDescription('while establishing the initial database connection'),
    ));
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const AppRoot(),
    ),
  );

}
