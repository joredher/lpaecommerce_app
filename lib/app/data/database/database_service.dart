import 'package:flutter/foundation.dart';
import 'package:mysql_client/mysql_client.dart';

import 'database_config.dart';

/// Simple wrapper around the MySQL driver that lazily opens a single
/// connection and reuses it for subsequent queries.
class DatabaseService {
  DatabaseService(this._config);

  final DatabaseConfig _config;
  MySQLConnection? _connection;

  /// Opens the database connection if necessary and returns it.
  Future<MySQLConnection> openConnection() async {
    if (!_config.directConnectionEnabled) {
      throw StateError(
        'Direct database connections are disabled. Enable them by setting '
        '`directConnectionEnabled` to true in the database configuration.',
      );
    }

    final existingConnection = _connection;
    if (existingConnection != null && existingConnection.connected) {
      return existingConnection;
    }

    final connection = await MySQLConnection.createConnection(
      host: _config.host,
      port: _config.port,
      userName: _config.user,
      password: _config.password,
      databaseName: _config.databaseName,
      secure: false,
    );

    try {
      await connection.connect(timeoutMs: 10000);
      debugPrint(
        'Connected to MySQL at ${_config.host}:${_config.port}/${_config.databaseName}',
      );
    } on Object catch (error, stackTrace) {
      debugPrint('Failed to connect to MySQL: $error');
      await connection.close();
      Error.throwWithStackTrace(error, stackTrace);
    }

    _connection = connection;
    return connection;
  }

  /// Closes the underlying connection if it has been opened.
  Future<void> closeConnection() async {
    final connection = _connection;
    if (connection == null) {
      return;
    }

    try {
      await connection.close();
    } catch (error) {
      debugPrint('Error closing MySQL connection: $error');
    } finally {
      _connection = null;
    }
  }
}
