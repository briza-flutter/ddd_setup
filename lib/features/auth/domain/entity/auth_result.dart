import 'package:ddd_setup/features/user/domain/entity/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_result.freezed.dart';

typedef Token = String;

@freezed
abstract class AuthResult with _$AuthResult {
  const factory AuthResult({
    required User user,
    required Token token,
  }) = _AuthResult;
}
