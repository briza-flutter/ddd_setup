import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '_platform_factory_native.dart'
    if (dart.library.html) '_platform_factory_web.dart';

/// 一条数据库迁移：版本号 + 要执行的 SQL（可以是建表、ALTER、新建索引）。
class Migration {
  final int version;
  final String sql;
  const Migration({required this.version, required this.sql});
}

/// 通用 sqlite 封装：开库 + 迁移调度 + CRUD 直通。
/// 不感知任何业务表，可独立成 package。
///
/// **跨平台**：通过条件 import 选择合适的 factory：
/// - Android / iOS：默认 sqflite
/// - Windows / Linux / macOS：sqflite_common_ffi
/// - Web：sqflite_common_ffi_web（需要先 `dart run sqflite_common_ffi_web:setup`）
class SqliteClient {
  final String dbName;
  final List<Migration> migrations;
  late final Database _db;

  static bool _factoryReady = false;

  SqliteClient({required this.dbName, required this.migrations});

  Future<void> open() async {
    if (!_factoryReady) {
      await initSqliteFactory();
      _factoryReady = true;
    }

    final dir = await getDatabasesPath();
    final path = p.join(dir, dbName);
    final latestVersion = migrations.isEmpty
        ? 1
        : migrations.map((m) => m.version).reduce((a, b) => a > b ? a : b);

    _db = await openDatabase(
      path,
      version: latestVersion,
      onCreate: (db, version) async {
        final sorted = [...migrations]
          ..sort((a, b) => a.version.compareTo(b.version));
        for (final m in sorted) {
          await db.execute(m.sql);
        }
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        final pending = migrations
            .where((m) => m.version > oldVersion && m.version <= newVersion)
            .toList()
          ..sort((a, b) => a.version.compareTo(b.version));
        for (final m in pending) {
          await db.execute(m.sql);
        }
      },
    );
  }

  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) =>
      _db.query(
        table,
        distinct: distinct,
        columns: columns,
        where: where,
        whereArgs: whereArgs,
        groupBy: groupBy,
        having: having,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );

  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Object?>? args,
  ]) =>
      _db.rawQuery(sql, args);

  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    ConflictAlgorithm? conflictAlgorithm,
  }) =>
      _db.insert(table, values, conflictAlgorithm: conflictAlgorithm);

  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
  }) =>
      _db.update(table, values, where: where, whereArgs: whereArgs);

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) =>
      _db.delete(table, where: where, whereArgs: whereArgs);

  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) =>
      _db.transaction(action);

  Future<void> close() => _db.close();
}
