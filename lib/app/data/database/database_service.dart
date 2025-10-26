import 'package:flutter/foundation.dart';
import 'package:mysql1/mysql1.dart';

import 'database_config.dart';

/// Simple wrapper around the MySQL driver that lazily opens a single
/// connection and reuses it for subsequent queries.
class DatabaseService {
  DatabaseService(this._config);

  final DatabaseConfig _config;
  MySqlConnection? _connection;

  /// Opens the database connection if necessary and returns it.
  Future<MySqlConnection> openConnection() async {
    if (_connection != null) {
      return _connection!;
    }

    final settings = ConnectionSettings(
      host: _config.host,
      port: _config.port,
      user: _config.user,
      password: _config.password,
      db: _config.databaseName,
      timeout: const Duration(seconds: 10),
    );

    try {
      _connection = await MySqlConnection.connect(settings);
      debugPrint(
        'Connected to MySQL at ${_config.host}:${_config.port}/${_config.databaseName}',
      );
    } on Object catch (error, stackTrace) {
      debugPrint('Failed to connect to MySQL: $error');
      Error.throwWithStackTrace(error, stackTrace);
    }

    return _connection!;
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
