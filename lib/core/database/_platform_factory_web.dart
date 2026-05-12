import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Web 端 sqlite factory 初始化（sqlite3 wasm + IndexedDB）。
///
/// 首次使用前需要把支持文件复制到 `web/` 目录，执行一次：
/// ```
/// dart run sqflite_common_ffi_web:setup
/// ```
Future<void> initSqliteFactory() async {
  databaseFactory = databaseFactoryFfiWeb;
}
