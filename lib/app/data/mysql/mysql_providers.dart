import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mysql_config.dart';
import 'mysql_database.dart';

final mySqlConfigProvider = Provider<MySqlConfig>((ref) {
  return MySqlConfig.fromEnvironment();
});

final mySqlDatabaseProvider = Provider<MySqlDatabase>((ref) {
  final config = ref.watch(mySqlConfigProvider);
  final database = MySqlDatabase(config: config);
  ref.onDispose(database.dispose);
  return database;
});
