import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final String? Function() getToken;
  AuthInterceptor({required this.getToken});
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
