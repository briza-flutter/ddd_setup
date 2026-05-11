// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_riverpod/flutter_riverpod.dart' as _i729;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../core/network/dio_client.dart' as _i393;
import '../core/network/interceptor_handler.dart' as _i1059;
import '../core/utils/app_logger.dart' as _i769;
import '../features/auth/data/datasource/auth_api.dart' as _i479;
import '../features/auth/data/datasource/auth_local_storage.dart' as _i301;
import '../features/auth/data/repository/auth_repository.dart' as _i570;
import '../features/user/data/datasource/user_api.dart' as _i588;
import '../features/user/data/repository/user_repository.dart' as _i380;
import 'di.dart' as _i913;
import 'router/app_router.dart' as _i722;

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
    gh.singleton<_i769.AppLogger>(() => _i769.AppLogger());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.sp,
      preResolve: true,
    );
    gh.singleton<_i1059.DioInterceptorHandler>(
        () => _i1059.DioInterceptorHandler(gh<_i729.ProviderContainer>()));
    gh.lazySingleton<_i722.AuthRouterListenable>(
        () => _i722.AuthRouterListenable(gh<_i729.ProviderContainer>()));
    gh.singleton<_i393.DioClient>(
        () => registerModule.baseDio(gh<_i1059.DioInterceptorHandler>()));
    gh.lazySingleton<_i722.AppRouterConfig>(() => _i722.AppRouterConfig(
          gh<_i769.AppLogger>(),
          gh<_i722.AuthRouterListenable>(),
        ));
    gh.singleton<_i301.AuthLocalStorage>(
        () => _i301.AuthLocalStorage(gh<_i460.SharedPreferences>()));
    gh.singleton<_i479.AuthApi>(() => _i479.AuthApi(gh<_i393.DioClient>()));
    gh.singleton<_i588.UserApi>(() => _i588.UserApi(gh<_i393.DioClient>()));
    gh.singleton<_i570.AuthRepository>(() => _i570.AuthRepository(
          gh<_i479.AuthApi>(),
          gh<_i301.AuthLocalStorage>(),
        ));
    gh.singleton<_i380.UserRepository>(
        () => _i380.UserRepository(gh<_i588.UserApi>()));
    return this;
  }
}

class _$RegisterModule extends _i913.RegisterModule {}
