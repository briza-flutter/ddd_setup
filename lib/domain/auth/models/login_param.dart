import 'package:ddd_setup/domain/auth/value_object.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'login_param.freezed.dart';

@freezed
abstract class LoginParam with _$LoginParam {
  factory LoginParam({
    required PhoneNumber phoneNumber,
    required Password password,
  }) = _LoginParam;
}
