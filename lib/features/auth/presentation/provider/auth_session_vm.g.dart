// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_vm.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$authSessionVmHash() => r'b2028751e5d1327234defcaeb88ab2ca1a909b29';

/// 全局登录会话状态：token + 当前用户。
/// 作为路由认证态、拦截器取 token、各页面读取登录用户的唯一事实来源。
///
/// Copied from [AuthSessionVm].
@ProviderFor(AuthSessionVm)
final authSessionVmProvider =
    NotifierProvider<AuthSessionVm, AuthSessionStore>.internal(
  AuthSessionVm.new,
  name: r'authSessionVmProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authSessionVmHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AuthSessionVm = Notifier<AuthSessionStore>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
