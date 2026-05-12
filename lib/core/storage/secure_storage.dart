import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// 加密本地存储：用于 token 等敏感数据。
///
/// 模仿 [SharedPreferences.getInstance]：通过 [SecureStorage.getInstance]
/// 在启动期一次性读入内存，DI 用 `@preResolve` 完成预热；之后业务代码可以
/// 同步 [read]，写入异步刷盘并同步更新缓存。
///
/// **Android** 默认启用 `encryptedSharedPreferences`，避免 IV 方案被回收。
/// **iOS / macOS** 走 Keychain。
class SecureStorage {
  final FlutterSecureStorage _backend;
  final Map<String, String> _cache;

  SecureStorage._(this._backend, this._cache);

  static Future<SecureStorage> getInstance() async {
    const backend = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    final all = await backend.readAll();
    return SecureStorage._(backend, {...all});
  }

  String? read(String key) => _cache[key];

  Future<void> write(String key, String value) async {
    await _backend.write(key: key, value: value);
    _cache[key] = value;
  }

  Future<void> delete(String key) async {
    await _backend.delete(key: key);
    _cache.remove(key);
  }

  Future<void> deleteAll() async {
    await _backend.deleteAll();
    _cache.clear();
  }
}
