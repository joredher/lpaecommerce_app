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
  });

  final String host;
  final int port;
  final String user;
  final String password;
  final String databaseName;

  const DatabaseConfig copyWith({
    String? host,
    int? port,
    String? user,
    String? password,
    String? databaseName,
  }) {
    return DatabaseConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      user: user ?? this.user,
      password: password ?? this.password,
      databaseName: databaseName ?? this.databaseName,
    );
  }
}

/// Default configuration used during local development.
///
/// Replace the placeholder credentials with real values that match your
/// environment before shipping the application.
const DatabaseConfig defaultDatabaseConfig = DatabaseConfig(
  host: '127.0.0.1',
  port: 3306,
  user: 'lpa_user',
  password: 'change_me',
  databaseName: 'lpaecommerce',
);
