import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  factory User({required int id, required String name, required int type}) =
      _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
