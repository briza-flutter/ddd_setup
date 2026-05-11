import 'package:ddd_setup/app/di.dart';
import 'package:ddd_setup/core/presentation/extensions/future_extensions.dart';
import 'package:ddd_setup/features/auth/data/repository/auth_repository.dart';
import 'package:ddd_setup/features/auth/domain/entity/auth_result.dart';
import 'package:ddd_setup/features/auth/domain/entity/login_param.dart';
import 'package:ddd_setup/features/user/data/repository/user_repository.dart';
import 'package:ddd_setup/features/user/domain/entity/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_session_vm.freezed.dart';
part 'auth_session_vm.g.dart';

@freezed
abstract class AuthSessionStore with _$AuthSessionStore {
  factory AuthSessionStore({
    required User? user,
    required Token? token,
  }) = _AuthSessionStore;
}

/// 全局登录会话状态：token + 当前用户。
/// 作为路由认证态、拦截器取 token、各页面读取登录用户的唯一事实来源。
@Riverpod(keepAlive: true)
class AuthSessionVm extends _$AuthSessionVm {
  late final _authRepo = di.get<AuthRepository>();
  late final _userRepo = di.get<UserRepository>();

  @override
  AuthSessionStore build() {
    final local = _authRepo.getLocalAuth();
    return AuthSessionStore(user: local?.user, token: local?.token);
  }

  Future<AuthResult> login(LoginParam param) async {
    final res = await _authRepo.login(param);
    state = AuthSessionStore(user: res.user, token: res.token);
    return res;
  }

  Future<void> refreshUser() async {
    final userId = state.user?.id;
    if (userId == null) return;
    await _userRepo.getUserInfo(userId).tryCatch();
  }

  /// 登出 / 401 时统一调用：清空本地 + 内存态。
  /// 路由通过 [AuthRouterListenable] 监听到 token=null 后自动跳转。
  Future<void> logout() async {
    await _authRepo.logout();
    state = AuthSessionStore(user: null, token: null);
  }
}
