import 'dart:convert';

import 'package:ddd_setup/features/user/data/model/user_model.dart';
import 'package:ddd_setup/features/user/domain/entity/user.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 认证本地存储：token + user
@singleton
class AuthLocalStorage {
  final SharedPreferences _sp;
  AuthLocalStorage(this._sp);

  static const String _tokenKey = "token";
  static const String _userKey = "user";

  String? getToken() => _sp.getString(_tokenKey);
  Future<bool> setToken(String token) => _sp.setString(_tokenKey, token);
  Future<bool> clearToken() => _sp.remove(_tokenKey);

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
