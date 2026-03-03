import 'package:ddd_setup/domain/user/entity/user.dart';

abstract class UserRepo {
  Future<User> getUserInfo(int userId);
}
