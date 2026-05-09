// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_resp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginRespModel _$LoginRespModelFromJson(Map<String, dynamic> json) =>
    _LoginRespModel(
      token: json['token'] as String,
      user: UserModel.fromJson(json['appUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginRespModelToJson(_LoginRespModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'appUser': instance.user,
    };
