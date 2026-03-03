// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../application/auth/auth_use_case.dart' as _i520;
import '../application/user/user_use_case.dart' as _i401;
import '../common/event/dio_interceptor_handler.dart' as _i431;
import '../common/utils/app_logger.dart' as _i114;
import '../domain/auth/repositories/auth_repo.dart' as _i64;
import '../domain/auth/repositories/local_auth_storage.dart' as _i308;
import '../domain/user/repositories/user_repo.dart' as _i270;
import '../infrastructure/local_data/impl/local_auth_storage_impl.dart'
    as _i790;
import '../infrastructure/remote_data/api/auth/auth.dart' as _i451;
import '../infrastructure/remote_data/api/user/user.dart' as _i640;
import '../infrastructure/remote_data/http_client/dio_client.dart' as _i118;
import '../infrastructure/remote_data/impl/auth_repo_impl.dart' as _i739;
import '../infrastructure/remote_data/impl/user_repo_impl.dart' as _i921;
import '../presentation/router/router_config.dart' as _i952;
import 'di.dart' as _i913;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.sp,
      preResolve: true,
    );
    gh.singleton<_i114.AppLogger>(() => _i114.AppLogger());
    gh.factory<_i308.LocalAuthStorage>(
        () => _i790.LocalAuthStorageImpl(gh<_i460.SharedPreferences>()));
    gh.singleton<_i952.RouterAuthProvider>(
        () => _i952.RouterAuthProvider(gh<_i308.LocalAuthStorage>()));
    gh.singleton<_i431.DioInterceptorHandler>(
        () => _i431.DioInterceptorHandler(gh<_i308.LocalAuthStorage>()));
    gh.singleton<_i952.AppRouterConfig>(() => _i952.AppRouterConfig(
          gh<_i114.AppLogger>(),
          gh<_i952.RouterAuthProvider>(),
        ));
    gh.singleton<_i118.DioClient>(
        () => registerModule.baseDio(gh<_i431.DioInterceptorHandler>()));
    gh.singleton<_i451.AuthApi>(() => _i451.AuthApi(gh<_i118.DioClient>()));
    gh.singleton<_i640.UserApi>(() => _i640.UserApi(gh<_i118.DioClient>()));
    gh.factory<_i270.UserRepo>(() => _i921.UserRepoImpl(gh<_i640.UserApi>()));
    gh.factory<_i401.UserUseCase>(
        () => _i401.UserUseCase(gh<_i270.UserRepo>()));
    gh.factory<_i64.AuthRepo>(() => _i739.AuthRepoImpl(gh<_i451.AuthApi>()));
    gh.factory<_i520.AuthUseCase>(() => _i520.AuthUseCase(
          gh<_i64.AuthRepo>(),
          gh<_i308.LocalAuthStorage>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i913.RegisterModule {}
