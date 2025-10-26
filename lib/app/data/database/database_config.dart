import 'package:flutter/foundation.dart';

/// Immutable configuration object used to create MySQL connections.
@immutable
class DatabaseConfig {
  const DatabaseConfig({
    required this.host,
    required this.port,
    required this.user,
    required this.password,
    required this.databaseName,
    this.directConnectionEnabled = false,
  });

  final String host;
  final int port;
  final String user;
  final String password;
  final String databaseName;

  /// When `true`, the application will attempt to connect directly to the
  /// database using the local credentials defined above. When `false`, the
  /// connection code is effectively disabled so builds without a database
  /// backend still run.
  final bool directConnectionEnabled;

  DatabaseConfig copyWith({
    String? host,
    int? port,
    String? user,
    String? password,
    String? databaseName,
    bool? directConnectionEnabled,
  }) {
    return DatabaseConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      user: user ?? this.user,
      password: password ?? this.password,
      databaseName: databaseName ?? this.databaseName,
      directConnectionEnabled:
          directConnectionEnabled ?? this.directConnectionEnabled,
    );
  }
}

/// Default configuration used during local development.
///
/// Replace the placeholder credentials with real values that match your
/// environment before shipping the application. Toggle
/// [directConnectionEnabled] to `true` only on trusted machines where a direct
/// database connection is acceptable.
const DatabaseConfig defaultDatabaseConfig = DatabaseConfig(
  host: '127.0.0.1',
  port: 3306,
  user: 'root',
  password: 'ingenieroDEV14',
  databaseName: 'lpaecommerce',
  directConnectionEnabled: false,
);
