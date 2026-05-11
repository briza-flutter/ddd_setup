import 'package:ddd_setup/features/user/data/datasource/user_api.dart';
import 'package:ddd_setup/features/user/domain/entity/user.dart';
import 'package:injectable/injectable.dart';

@singleton
class UserRepository {
  final UserApi _userApi;
  UserRepository(this._userApi);

  Future<User> getUserInfo(int userId) async {
    final r = await _userApi.getUserInfo(userId);
    return r.toDomain;
  }
}
