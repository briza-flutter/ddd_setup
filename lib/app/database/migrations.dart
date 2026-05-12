import 'package:ddd_setup/core/database/sqlite_client.dart';

/// 项目所有 sqlite 迁移集中放这里。
///
/// 新增 schema 时往下追加一条 Migration，version +1。
/// **不要修改历史迁移**——已发布版本里数据库已按旧 SQL 建好，改了不会重跑。
class AppMigrations {
  static final List<Migration> all = [
    Migration(
      version: 1,
      sql: '''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          type INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''',
    ),
    // 后续示例：
    // Migration(version: 2, sql: 'ALTER TABLE users ADD COLUMN avatar TEXT'),
    // Migration(version: 3, sql: 'CREATE INDEX idx_users_type ON users(type)'),
  ];
}
