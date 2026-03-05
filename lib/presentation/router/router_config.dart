import 'package:bot_toast/bot_toast.dart';
import 'package:ddd_setup/common/utils/app_logger.dart';
import 'package:ddd_setup/domain/auth/repositories/local_auth_storage.dart';
import 'package:ddd_setup/presentation/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';

final GlobalKey<NavigatorState> rootRouterKey = GlobalKey<NavigatorState>();

@singleton
class AppRouterConfig {
  final AppLogger _logger;
  final RouterAuthProvider _authProvider;
  AppRouterConfig(this._logger, this._authProvider);

  /// 不需要登陆可访问的路由列表
  static final List<String> noAuthRoutes = [Routes.login];

  late final _router = GoRouter(
    refreshListenable: _authProvider.refreshListenable,
    navigatorKey: rootRouterKey,
    initialLocation: Routes.login,
    observers: [BotToastNavigatorObserver()],
    routes: Routes.appRoutes,
    redirect: (context, state) {
      _logger.d('Router redirect called with path: ${state.uri.path}');

      /// 白名单 直接放行
      if (noAuthRoutes.contains(state.uri.path)) {
        return null;
      }

      /// 没权限访问的路由，重定向到登录页
      final r = _authProvider.getAuth();
      if (!r) return Routes.login;

      return null;
    },
  );

  GoRouter get router => _router;
}

@singleton
class RouterAuthProvider {
  final RouterAuthRefresh refreshListenable = RouterAuthRefresh();
  final LocalAuthStorage _spUtils;
  RouterAuthProvider(this._spUtils);
  bool getAuth() {
    final hasToken = _spUtils.getToken();
    if (hasToken != null) {
      return true;
    }
    return false;
  }
}

class RouterAuthRefresh extends ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}
