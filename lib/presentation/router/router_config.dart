import 'package:bot_toast/bot_toast.dart';
import 'package:ddd_setup/common/utils/app_logger.dart';
import 'package:ddd_setup/presentation/provider/user_provider.dart';
import 'package:ddd_setup/presentation/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

final GlobalKey<NavigatorState> rootRouterKey = GlobalKey<NavigatorState>();

/// 路由层认证态适配器：把 UserVm 的状态变化转换为 ChangeNotifier 通知。
/// 让 GoRouter 可以订阅 Riverpod 状态作为唯一事实来源。
///
/// 使用 `@lazySingleton`：构造函数里会 `container.listen(userVmProvider)` 触发
/// UserVm.build，进而 `di.get<AuthUseCase>()`。如果用 `@singleton` 在 DI init
/// 阶段急切构造，这时 AuthUseCase 等下游依赖还没注册，会抛 StateError。
/// 改成 lazy，等 `MyApp.build` 时通过 `di.get<AppRouterConfig>()` 才触发构造。
@lazySingleton
class AuthRouterListenable extends ChangeNotifier {
  final ProviderContainer _container;
  late final ProviderSubscription<UserStore> _sub;
  bool _isAuthed = false;

  AuthRouterListenable(this._container) {
    _sub = _container.listen<UserStore>(
      userVmProvider,
      (prev, next) => _update(next.token != null),
      fireImmediately: true,
    );
  }

  bool get isAuthed => _isAuthed;

  void _update(bool authed) {
    if (authed == _isAuthed) return;
    _isAuthed = authed;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

@lazySingleton
class AppRouterConfig {
  final AppLogger _logger;
  final AuthRouterListenable _auth;
  AppRouterConfig(this._logger, this._auth);

  /// 不需要登陆可访问的路由列表
  static final List<String> noAuthRoutes = [Routes.login];

  late final _router = GoRouter(
    refreshListenable: _auth,
    navigatorKey: rootRouterKey,
    initialLocation: Routes.login,
    observers: [BotToastNavigatorObserver()],
    routes: Routes.appRoutes,
    redirect: (context, state) {
      _logger.d(
        'Router redirect: ${state.uri.path}, authed=${_auth.isAuthed}',
      );

      /// 白名单 直接放行
      if (noAuthRoutes.contains(state.uri.path)) return null;

      /// 没权限访问的路由，重定向到登录页
      if (!_auth.isAuthed) return Routes.login;

      return null;
    },
  );

  GoRouter get router => _router;
}
