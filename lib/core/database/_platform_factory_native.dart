import 'dart:io' show Platform;

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// 移动端 / 桌面端 的 sqlite factory 初始化。
/// - Android / iOS：sqflite 默认 factory 自动可用，无需配置
/// - Windows / Linux / macOS：用 ffi 加载 sqlite3 动态库
Future<void> initSqliteFactory() async {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
