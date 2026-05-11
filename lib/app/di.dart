import 'package:ddd_setup/app/env_config.dart';
import 'package:ddd_setup/core/network/dio_client.dart';
import 'package:ddd_setup/app/network/interceptor_handler.dart';
import 'package:ddd_setup/core/network/interceptors/auth_interceptor.dart';
import 'package:ddd_setup/core/network/interceptors/error_interceptor.dart';
import 'package:ddd_setup/core/network/interceptors/response_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'di.config.dart';

GetIt get di => GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
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
