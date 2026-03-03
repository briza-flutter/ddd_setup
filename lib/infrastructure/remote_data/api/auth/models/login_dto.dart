import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_dto.freezed.dart';
part 'login_dto.g.dart';

@freezed
abstract class LoginDto with _$LoginDto {
  factory LoginDto({
    required String username,
    required String password,
    @Default("1") String type,
  }) = _LoginDto;
  factory LoginDto.fromJson(Map<String, Object?> json) =>
      _$LoginDtoFromJson(json);
}
