import 'package:ddd_setup/domain/user/entity/user.dart';
import 'package:ddd_setup/domain/user/repositories/user_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UserUseCase {
  final UserRepo _userRepo;
  UserUseCase(this._userRepo);
  Future<User> getUserInfo(int userId) {
    return _userRepo.getUserInfo(userId);
  }
}
