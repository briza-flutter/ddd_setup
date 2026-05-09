import 'package:ddd_setup/domain/user/entity/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  factory UserModel({
    required String name,
    required int id,
    @Default(1) int type,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromDomain(User user) =>
      UserModel(id: user.id, name: user.name, type: user.type);

  UserModel._();

  User get toDomain => User(id: id, name: name, type: type);
}
