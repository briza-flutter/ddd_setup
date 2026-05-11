import 'package:ddd_setup/features/auth/domain/entity/auth_result.dart';
import 'package:ddd_setup/features/user/data/model/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_resp_model.freezed.dart';
part 'login_resp_model.g.dart';

/// 登录接口响应体（data 层 DTO）
@freezed
abstract class LoginRespModel with _$LoginRespModel {
  factory LoginRespModel({
    required String token,
    @JsonKey(name: 'appUser') required UserModel user,
  }) = _LoginRespModel;

  factory LoginRespModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRespModelFromJson(json);

  LoginRespModel._();

  AuthResult get toDomain => AuthResult(token: token, user: user.toDomain);
}
