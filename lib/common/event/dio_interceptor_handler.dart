import 'package:ddd_setup/domain/auth/repositories/local_auth_storage.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@singleton
class DioInterceptorHandler {
  final LocalAuthStorage _localAuthStorage;
  DioInterceptorHandler(this._localAuthStorage);
  handleErr(DioException err) {}

  String? getToken() {
    return _localAuthStorage.getToken();
  }
}
