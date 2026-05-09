import 'package:ddd_setup/common/event/dio_interceptor_handler.dart';
import 'package:ddd_setup/config/env_config.dart';
import 'package:ddd_setup/infrastructure/remote_data/http_client/dio_client.dart';
import 'package:ddd_setup/infrastructure/remote_data/http_client/interceptors/auth_interceptor.dart';
import 'package:ddd_setup/infrastructure/remote_data/http_client/interceptors/error_interceptor.dart';
import 'package:ddd_setup/infrastructure/remote_data/http_client/interceptors/response_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'di.config.dart';

GetIt get di => GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  /// 手动注册模块
  await GetIt.instance.init();
}

@module
abstract class RegisterModule {
  @preResolve
  @singleton
  Future<SharedPreferences> get sp => SharedPreferences.getInstance();

  @singleton
  DioClient baseDio(DioInterceptorHandler errHandler) {
    return DioClient(baseUrl: EnvConfig.baseUrl, interceptors: [
      AuthInterceptor(getToken: errHandler.getToken),
      ResponseInterceptor(),
      ErrInterceptor(onErrorCallback: errHandler.handleErr),
    ]);
  }
}
