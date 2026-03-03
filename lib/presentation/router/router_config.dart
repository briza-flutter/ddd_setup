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
    navigatorKey: rootRouterKey,
    initialLocation: Routes.login,
    observers: [BotToastNavigatorObserver()],
    routes: Routes.appRoutes,
    redirect: (context, state) {
      if (noAuthRoutes.contains(state.uri.path)) {
        return null;
      }
      final r = _authProvider.getAuth();
      _logger.d("Redirecting to ${state.uri} : $r");
      if (r) return null;
      return Routes.login;
    },
  );

  GoRouter get router => _router;
}

@singleton
class RouterAuthProvider {
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
