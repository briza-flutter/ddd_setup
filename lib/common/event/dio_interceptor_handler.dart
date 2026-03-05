import 'package:ddd_setup/domain/auth/repositories/local_auth_storage.dart';
import 'package:ddd_setup/presentation/router/router_config.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class DioInterceptorHandler {
  final LocalAuthStorage _localAuthStorage;
  final RouterAuthProvider _routerAuthProvider;
  DioInterceptorHandler(this._localAuthStorage, this._routerAuthProvider);
  handleErr(DioException err) {
    final httpCode = err.response?.statusCode;

    /// 业务code 401 代表 token 无效或过期
    final bizCode = err.response?.data['code'];
    if (bizCode == 200 || httpCode == 401) {
      _routerAuthProvider.refreshListenable.refresh();
    }
  }

  String? getToken() {
    return _localAuthStorage.getToken();
  }
}
