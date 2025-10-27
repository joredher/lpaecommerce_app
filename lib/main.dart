import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql_client/mysql_client.dart';

import 'app/app_root.dart';
import 'app/data/database/database_providers.dart';
import 'app/state/app_state_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const ProviderScope(
      child: _AppBootstrap(
        child: AppRoot(),
      ),
    ),
  );
}

class _AppBootstrap extends ConsumerStatefulWidget {
  const _AppBootstrap({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends ConsumerState<_AppBootstrap> {
  ProviderSubscription<AsyncValue<MySQLConnection>>?
      _databaseConnectionSubscription;

  @override
  void initState() {
    super.initState();
    unawaited(_initialize());
  }

  @override
  void dispose() {
    final subscription = _databaseConnectionSubscription;
    if (subscription != null) {
      unawaited(subscription.close());
    }
    super.dispose();
  }

  Future<void> _initialize() async {
    ref.read(appStateProvider.notifier);

    final databaseConfig = ref.read(databaseConfigProvider);
    if (!databaseConfig.directConnectionEnabled) {
      return;
    }

    _databaseConnectionSubscription = ref.listen<AsyncValue<MySQLConnection>>(
      databaseConnectionProvider,
      (_, __) {},
    );

    try {
      await ref.read(databaseConnectionProvider.future);
    } catch (error, stackTrace) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: error,
        stack: stackTrace,
        library: 'database',
        context: ErrorDescription(
          'while establishing the initial database connection',
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
