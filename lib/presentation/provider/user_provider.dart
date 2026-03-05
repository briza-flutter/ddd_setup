import 'package:ddd_setup/application/auth/auth_use_case.dart';
import 'package:ddd_setup/application/user/user_use_case.dart';
import 'package:ddd_setup/common/presentation/extensions/future_extensions.dart';
import 'package:ddd_setup/common/utils/app_logger.dart';
import 'package:ddd_setup/config/di.dart';
import 'package:ddd_setup/domain/auth/models/login_param.dart';
import 'package:ddd_setup/domain/auth/models/auth_result.dart';
import 'package:ddd_setup/domain/auth/value_object.dart';
import 'package:ddd_setup/domain/user/entity/user.dart';
import 'package:ddd_setup/presentation/router/router_config.dart';
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

  factory UserStore.fromJson(Map<String, dynamic> json) =>
      _$UserStoreFromJson(json);
}

@Riverpod(keepAlive: true)
class UserVm extends _$UserVm {
  late final _authUseCase = di.get<AuthUseCase>();
  late final _userUseCase = di.get<UserUseCase>();
  late final _routerProvider = di.get<RouterAuthProvider>();
  late final _logger = di.get<AppLogger>();
  @override
  UserStore build() {
    _authUseCase.getLocalAuthData();
    final localAuthData = _authUseCase.getLocalAuthData();
    _routerProvider.refreshListenable.addListener(_handleAuthChange);
    ref.onDispose(
      () {
        _routerProvider.refreshListenable.removeListener(_handleAuthChange);
      },
    );
    return UserStore(user: localAuthData?.user, token: localAuthData?.token);
  }

  /// 路由刷新变化时的回调
  _handleAuthChange() {
    _logger.d('Auth state changed, refreshing user info');
  }

  Future<AuthResult> login(
      {required PhoneNumber phoneNumber, required Password passwordObj}) async {
    final res = await _authUseCase
        .login(LoginParam(phoneNumber: phoneNumber, password: passwordObj));
    state = UserStore(user: res.user, token: res.token);
    return res;
  }

  Future updateUserInfo() async {
    final userId = state.user?.id;
    if (userId == null) return;
    await _userUseCase.getUserInfo(userId).tryCatch();
  }

  Future<void> logout() async {
    await _authUseCase.logout();
    state = UserStore(user: null, token: null);
    _routerProvider.refreshListenable.refresh();
  }
}
