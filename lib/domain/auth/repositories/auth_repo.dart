import 'package:ddd_setup/domain/auth/models/auth_data.dart';
import 'package:ddd_setup/domain/auth/models/auth_result.dart';

abstract class AuthRepo {
  /// 登陆
  Future<AuthResult> login(LoginData dto);

  ///注销
  Future deleteAccount();
}
