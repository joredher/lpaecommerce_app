import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mysql1/mysql1.dart';

import 'database_config.dart';
import 'database_service.dart';

/// Provides the configuration used to initialize the database connection.
final databaseConfigProvider = Provider<DatabaseConfig>((ref) {
  return defaultDatabaseConfig;
});

/// Provides a lazily instantiated [DatabaseService] that can be reused across
/// the widget tree.
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  final config = ref.watch(databaseConfigProvider);
  final service = DatabaseService(config);

  ref.onDispose(() {
    unawaited(service.closeConnection());
  });

  return service;
});

/// Exposes the underlying [MySqlConnection] to Riverpod consumers. The
/// provider delegates the heavy lifting to [DatabaseService], which ensures
/// the connection is created once and torn down correctly.
final databaseConnectionProvider = FutureProvider<MySqlConnection>((ref) async {
  final service = ref.watch(databaseServiceProvider);
  final connection = await service.openConnection();

  return connection;
});
