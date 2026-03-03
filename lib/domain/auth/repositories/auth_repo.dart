import 'package:ddd_setup/domain/auth/models/login_param.dart';
import 'package:ddd_setup/domain/auth/models/auth_result.dart';

abstract class AuthRepo {
  /// 登陆
  Future<AuthResult> login(LoginParam param);

  ///注销
  Future deleteAccount();
}
