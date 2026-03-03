import 'package:ddd_setup/domain/user/entity/user.dart';

/// 本地认证数据存储抽象
abstract class LocalAuthStorage {
  String? getToken();
  Future<bool> setToken(String token);
  Future<bool> clearToken();

  User? getUser();
  Future<bool> setUser(User user);
  Future<bool> clearUser();
}
