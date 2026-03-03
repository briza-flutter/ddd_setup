import 'package:ddd_setup/domain/auth/models/login_param.dart';
import 'package:ddd_setup/domain/auth/models/auth_result.dart';
import 'package:ddd_setup/domain/auth/repositories/auth_repo.dart';
import 'package:ddd_setup/domain/auth/repositories/local_auth_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthUseCase {
  final AuthRepo _authRepo;
  final LocalAuthStorage _localAuthStorage;
  AuthUseCase(this._authRepo, this._localAuthStorage);

  Future<AuthResult> login(LoginParam param) async {
    final r = await _authRepo.login(param);
    await _localAuthStorage.setToken(r.token);
    await _localAuthStorage.setUser(r.user);
    return r;
  }

  Future logout() async {
    await _localAuthStorage.clearToken();
    await _localAuthStorage.clearUser();
  }

  AuthResult? getLocalAuthData() {
    final token = _localAuthStorage.getToken();
    final user = _localAuthStorage.getUser();
    if (token == null || user == null) return null;
    return AuthResult(token: token, user: user);
  }
}
