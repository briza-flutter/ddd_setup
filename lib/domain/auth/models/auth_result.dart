import 'package:ddd_setup/domain/user/entity/user.dart';

typedef Token = String;

class AuthResult {
  final User user;
  final Token token;

  const AuthResult({required this.user, required this.token});
}
