import 'package:flutter/foundation.dart';

@immutable
class MySqlConfig {
  const MySqlConfig({
    required this.host,
    required this.port,
    required this.database,
    required this.username,
    required this.password,
    this.useSSL = false,
    this.timeout = const Duration(seconds: 8),
  });

  factory MySqlConfig.fromEnvironment() {
    final host = const String.fromEnvironment('LPA_DB_HOST', defaultValue: '127.0.0.1');
    final portString = const String.fromEnvironment('LPA_DB_PORT', defaultValue: '3306');
    final database = const String.fromEnvironment('LPA_DB_NAME', defaultValue: 'lpaecommerce');
    final username = const String.fromEnvironment('LPA_DB_USER', defaultValue: 'root');
    final password = const String.fromEnvironment('LPA_DB_PASS', defaultValue: '');
    final useSSLString = const String.fromEnvironment('LPA_DB_USE_SSL', defaultValue: 'false');
    final timeoutMsString = const String.fromEnvironment('LPA_DB_TIMEOUT_MS', defaultValue: '8000');

    final parsedPort = int.tryParse(portString) ?? 3306;
    final parsedUseSSL = useSSLString.toLowerCase() == 'true';
    final parsedTimeoutMs = int.tryParse(timeoutMsString);

    return MySqlConfig(
      host: host,
      port: parsedPort,
      database: database,
      username: username,
      password: password,
      useSSL: parsedUseSSL,
      timeout: parsedTimeoutMs != null ? Duration(milliseconds: parsedTimeoutMs) : const Duration(seconds: 8),
    );
  }

  final String host;
  final int port;
  final String database;
  final String username;
  final String password;
  final bool useSSL;
  final Duration timeout;

  MySqlConfig copyWith({
    String? host,
    int? port,
    String? database,
    String? username,
    String? password,
    bool? useSSL,
    Duration? timeout,
  }) {
    return MySqlConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      database: database ?? this.database,
      username: username ?? this.username,
      password: password ?? this.password,
      useSSL: useSSL ?? this.useSSL,
      timeout: timeout ?? this.timeout,
    );
  }
}
