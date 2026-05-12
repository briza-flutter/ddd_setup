import 'dart:convert';

import 'package:ddd_setup/core/storage/secure_storage.dart';
import 'package:ddd_setup/features/user/data/model/user_model.dart';
import 'package:ddd_setup/features/user/domain/entity/user.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 认证本地存储：
/// - token 存 [SecureStorage]（加密、走 Keychain / EncryptedSharedPreferences）
/// - user 存 [SharedPreferences]（非敏感，明文 OK）
@singleton
class AuthLocalStorage {
  final SharedPreferences _sp;
  final SecureStorage _secure;
  AuthLocalStorage(this._sp, this._secure);

  static const String _tokenKey = "auth_token";
  static const String _userKey = "user";

  String? getToken() => _secure.read(_tokenKey);
  Future<void> setToken(String token) => _secure.write(_tokenKey, token);
  Future<void> clearToken() => _secure.delete(_tokenKey);

  User? getUser() {
    final json = _sp.getString(_userKey);
    if (json == null) return null;
    return UserModel.fromJson(jsonDecode(json)).toDomain;
  }

  Future<bool> setUser(User user) => _sp.setString(
        _userKey,
        jsonEncode(UserModel.fromDomain(user).toJson()),
      );

  Future<bool> clearUser() => _sp.remove(_userKey);
}
