// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$themeVmHash() => r'adf5b3784e0a8ec819afcd7a5edd6d03794fca09';

/// 主题模式（system/light/dark）的全局状态，跨 feature 通用。
///
/// **归属**：主题没有业务领域归属 → 放 `shared/providers/`（不放 features，也不放 core，因为 core 不能依赖 SharedPreferences 这种"启动期单例"）。
///
/// **持久化**：写 SharedPreferences，下次启动自动恢复。
/// `build()` 同步读 SP（已通过 DI `@preResolve` 在启动期初始化），无需等待。
///
/// Copied from [ThemeVm].
@ProviderFor(ThemeVm)
final themeVmProvider = NotifierProvider<ThemeVm, ThemeMode>.internal(
  ThemeVm.new,
  name: r'themeVmProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$themeVmHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ThemeVm = Notifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
