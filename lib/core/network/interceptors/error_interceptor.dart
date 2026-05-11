import 'package:dio/dio.dart';

class ErrInterceptor extends Interceptor {
  final void Function(DioException error) onErrorCallback;
  ErrInterceptor({required this.onErrorCallback});
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 在这里可以处理公共的错误逻辑，如日志、错误提示等
    onErrorCallback(err);
    super.onError(err, handler);
  }
}
