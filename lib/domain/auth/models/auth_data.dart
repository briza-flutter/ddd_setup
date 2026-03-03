import 'package:ddd_setup/domain/auth/value_object.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'auth_data.freezed.dart';

@freezed
abstract class LoginData with _$LoginData {
  factory LoginData({
    required PhoneNumber phoneNumber,
    required Password password,
  }) = _LoginData;
}
