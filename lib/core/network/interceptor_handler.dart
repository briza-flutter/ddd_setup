import 'package:ddd_setup/features/auth/presentation/provider/auth_session_vm.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';

@singleton
class DioInterceptorHandler {
  final ProviderContainer _container;
  DioInterceptorHandler(this._container);

  void handleErr(DioException err) {
    final httpCode = err.response?.statusCode;
    final data = err.response?.data;

    /// 业务 code 401 / HTTP 401 代表 token 无效或过期
    final bizCode = data is Map ? data['code'] : null;
    if (bizCode == 401 || httpCode == 401) {
      /// 清空 AuthSessionVm 状态，路由通过 AuthRouterListenable 自动跳到 /login
      _container.read(authSessionVmProvider.notifier).logout();
    }
  }

  /// 请求拦截器读取当前 token —— 统一从 AuthSessionVm 取，
  /// 不再直接读 AuthLocalStorage，保持单一事实来源。
  String? getToken() => _container.read(authSessionVmProvider).token;
}
