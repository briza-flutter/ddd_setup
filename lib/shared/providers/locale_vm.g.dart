// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$localeVmHash() => r'2504b9c54bc4d668eac86d61e48d789cc4ebd7ad';

/// 应用语言（locale）的全局状态，跨 feature 通用。
///
/// **归属**：无业务领域归属 → `shared/providers/`（同 theme_vm）
/// **持久化**：SharedPreferences（启动期已 @preResolve 初始化，build 同步读）
///
/// Copied from [LocaleVm].
@ProviderFor(LocaleVm)
final localeVmProvider = NotifierProvider<LocaleVm, Locale>.internal(
  LocaleVm.new,
  name: r'localeVmProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$localeVmHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LocaleVm = Notifier<Locale>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
