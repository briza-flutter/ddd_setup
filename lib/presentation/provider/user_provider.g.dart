// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStore _$UserStoreFromJson(Map<String, dynamic> json) => _UserStore(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$UserStoreToJson(_UserStore instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userVmHash() => r'c3e0614b8056b5b31cfc81c9c0a182630c9939d3';

/// See also [UserVm].
@ProviderFor(UserVm)
final userVmProvider = NotifierProvider<UserVm, UserStore>.internal(
  UserVm.new,
  name: r'userVmProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userVmHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$UserVm = Notifier<UserStore>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
