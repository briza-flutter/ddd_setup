import 'package:ddd_setup/domain/user/entity/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'vo.freezed.dart';
part 'vo.g.dart';

@freezed
abstract class UserVo with _$UserVo {
  factory UserVo({required String name, required int id}) = _UserVo;

  factory UserVo.fromJson(Map<String, dynamic> json) => _$UserVoFromJson(json);
  UserVo._();

  User get toDomain => User(id: id, name: name, type: 1);
}
