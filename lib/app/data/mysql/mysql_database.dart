import 'dart:async';

import 'package:mysql_client/mysql_client.dart';

import 'mysql_config.dart';

class MySqlDatabase {
  MySqlDatabase({required this.config});

  final MySqlConfig config;

  MySQLConnection? _connection;
  Completer<MySQLConnection>? _connectCompleter;

  Future<MySQLConnection> _openConnection() async {
    final existing = _connection;
    if (existing != null && existing.connected) {
      return existing;
    }

    final completer = _connectCompleter;
    if (completer != null) {
      return completer.future;
    }

    final newCompleter = Completer<MySQLConnection>();
    _connectCompleter = newCompleter;
    try {
      final connection = await MySQLConnection.createConnection(
        host: config.host,
        port: config.port,
        userName: config.username,
        password: config.password,
        databaseName: config.database,
        secure: config.useSSL,
      );
      await connection.connect(timeoutMs: config.timeout.inMilliseconds);
      _connection = connection;
      newCompleter.complete(connection);
      return connection;
    } catch (error, stackTrace) {
      newCompleter.completeError(error, stackTrace);
      rethrow;
    } finally {
      _connectCompleter = null;
    }
  }

  Future<IResultSet> execute(
    String query, {
    Map<String, dynamic>? params,
  }) async {
    final connection = await _openConnection();
    return connection.execute(query, params ?? const <String, dynamic>{});
  }

  Future<void> invalidate() async {
    final existing = _connection;
    _connection = null;
    if (existing != null && existing.connected) {
      await existing.close();
    }
  }

  Future<void> dispose() async {
    await invalidate();
  }
}
