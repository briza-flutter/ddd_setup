import 'package:dio/dio.dart';

/// 处理不是 200 的响应，统一抛出异常
class ResponseInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['X-Custom-Header'] = 'CustomValue';
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    DioException? error;
    try {
      final code = response.data['code'] as int?;
      final message = response.data['message'] as String?;
      if (code == 200) {
        handler.next(response);
      } else {
        error = DioException(
          requestOptions: response.requestOptions,
          response: response,
          error: 'API Error: ${message ?? 'Unknown error'}',
        );
      }
    } catch (e) {
      error = DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: e,
      );
    }
    if (error != null) {
      handler.reject(error);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 在这里可以处理公共的错误逻辑，如日志、错误提示等
    super.onError(err, handler);
  }
}
