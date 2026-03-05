import 'package:ddd_setup/domain/auth/models/login_param.dart';
import 'package:ddd_setup/domain/auth/models/auth_result.dart';
import 'package:ddd_setup/domain/auth/repositories/auth_repo.dart';
import 'package:ddd_setup/infrastructure/remote_data/api/auth/auth.dart';
import 'package:ddd_setup/infrastructure/remote_data/api/auth/models/login_dto.dart';
import 'package:injectable/injectable.dart';

@Singleton(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthApi _authApi;
  AuthRepoImpl(this._authApi);
  @override
  Future deleteAccount() {
    throw UnimplementedError();
  }

  @override
  Future<AuthResult> login(LoginParam param) async {
    final r = await _authApi.login(LoginDto(
        username: param.phoneNumber.value, password: param.password.value));
    return AuthResult(user: r.$1, token: r.$2);
  }
}
