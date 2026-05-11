import 'package:ddd_setup/features/auth/data/datasource/auth_api.dart';
import 'package:ddd_setup/features/auth/data/datasource/auth_local_storage.dart';
import 'package:ddd_setup/features/auth/data/model/login_dto.dart';
import 'package:ddd_setup/features/auth/domain/entity/auth_result.dart';
import 'package:ddd_setup/features/auth/domain/entity/login_param.dart';
import 'package:injectable/injectable.dart';

/// 合并 AuthRepoImpl + AuthUseCase：单人项目不抽接口、不抽 use case，
/// 直接由 Repository 编排 API + 本地存储。
@singleton
class AuthRepository {
  final AuthApi _authApi;
  final AuthLocalStorage _localStorage;

  AuthRepository(this._authApi, this._localStorage);

  Future<AuthResult> login(LoginParam param) async {
    final model = await _authApi.login(LoginDto(
      username: param.phoneNumber.value,
      password: param.password.value,
    ));
    final result = model.toDomain;
    await _localStorage.setToken(result.token);
    await _localStorage.setUser(result.user);
    return result;
  }

  Future<void> logout() async {
    await _localStorage.clearToken();
    await _localStorage.clearUser();
  }

  AuthResult? getLocalAuth() {
    final token = _localStorage.getToken();
    final user = _localStorage.getUser();
    if (token == null || user == null) return null;
    return AuthResult(token: token, user: user);
  }
}
