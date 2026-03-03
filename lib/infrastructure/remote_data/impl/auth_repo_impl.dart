import 'package:ddd_setup/domain/auth/models/auth_data.dart';
import 'package:ddd_setup/domain/auth/models/auth_result.dart';
import 'package:ddd_setup/domain/auth/repositories/auth_repo.dart';
import 'package:ddd_setup/infrastructure/remote_data/api/auth/auth.dart';
import 'package:ddd_setup/infrastructure/remote_data/api/auth/models/dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthApi _authApi;
  AuthRepoImpl(this._authApi);
  @override
  Future deleteAccount() {
    throw UnimplementedError();
  }

  @override
  Future<AuthResult> login(LoginData dto) async {
    final r = await _authApi.login(LoginDto(
        username: dto.phoneNumber.value, password: dto.password.value));
    return AuthResult(user: r.$1, token: r.$2);
  }
}
