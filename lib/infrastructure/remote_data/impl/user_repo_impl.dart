import 'package:ddd_setup/domain/user/entity/user.dart';
import 'package:ddd_setup/domain/user/repositories/user_repo.dart';
import 'package:ddd_setup/infrastructure/remote_data/api/user/user.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: UserRepo)
class UserRepoImpl implements UserRepo {
  final UserApi _userApi;
  UserRepoImpl(this._userApi);
  @override
  Future<User> getUserInfo(int userId) async {
    final r = await _userApi.getUserInfo(userId);
    return r.toDomain;
  }
}
