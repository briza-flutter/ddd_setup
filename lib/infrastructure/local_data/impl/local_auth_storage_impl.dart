import 'dart:convert';

import 'package:ddd_setup/domain/auth/repositories/local_auth_storage.dart';
import 'package:ddd_setup/domain/user/entity/user.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton(as: LocalAuthStorage)
class LocalAuthStorageImpl implements LocalAuthStorage {
  final SharedPreferences _sp;
  LocalAuthStorageImpl(this._sp);

  static const String _tokenKey = "token";
  static const String _userKey = "user";

  @override
  String? getToken() => _sp.getString(_tokenKey);

  @override
  Future<bool> setToken(String token) => _sp.setString(_tokenKey, token);

  @override
  Future<bool> clearToken() => _sp.remove(_tokenKey);

  @override
  User? getUser() {
    final json = _sp.getString(_userKey);
    if (json == null) return null;
    return User.fromJson(jsonDecode(json));
  }

  @override
  Future<bool> setUser(User user) =>
      _sp.setString(_userKey, jsonEncode(user.toJson()));

  @override
  Future<bool> clearUser() => _sp.remove(_userKey);
}
