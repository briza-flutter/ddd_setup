import 'package:ddd_setup/application/auth/auth_use_case.dart';
import 'package:ddd_setup/application/user/user_use_case.dart';
import 'package:ddd_setup/common/presentation/extensions/future_extensions.dart';
import 'package:ddd_setup/config/di.dart';
import 'package:ddd_setup/domain/auth/models/login_param.dart';
import 'package:ddd_setup/domain/auth/models/auth_result.dart';
import 'package:ddd_setup/domain/user/entity/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.freezed.dart';
part 'user_provider.g.dart';

@freezed
abstract class UserStore with _$UserStore {
  factory UserStore({
    required User? user,
    required Token? token,
  }) = _UserStore;
}

@Riverpod(keepAlive: true)
class UserVm extends _$UserVm {
  late final _authUseCase = di.get<AuthUseCase>();
  late final _userUseCase = di.get<UserUseCase>();

  @override
  UserStore build() {
    final localAuthData = _authUseCase.getLocalAuthData();
    return UserStore(user: localAuthData?.user, token: localAuthData?.token);
  }

  Future<AuthResult> login(LoginParam param) async {
    final res = await _authUseCase.login(param);
    state = UserStore(user: res.user, token: res.token);
    return res;
  }

  Future<void> updateUserInfo() async {
    final userId = state.user?.id;
    if (userId == null) return;
    await _userUseCase.getUserInfo(userId).tryCatch();
  }

  /// 登出 / 401 时统一调用：清空本地 + 内存态。
  /// 路由通过 [AuthRouterListenable] 监听到 token=null 后自动跳转。
  Future<void> logout() async {
    await _authUseCase.logout();
    state = UserStore(user: null, token: null);
  }
}
