// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserVo {
  String get name;
  int get id;

  /// Create a copy of UserVo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserVoCopyWith<UserVo> get copyWith =>
      _$UserVoCopyWithImpl<UserVo>(this as UserVo, _$identity);

  /// Serializes this UserVo to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserVo &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, id);

  @override
  String toString() {
    return 'UserVo(name: $name, id: $id)';
  }
}

/// @nodoc
abstract mixin class $UserVoCopyWith<$Res> {
  factory $UserVoCopyWith(UserVo value, $Res Function(UserVo) _then) =
      _$UserVoCopyWithImpl;
  @useResult
  $Res call({String name, int id});
}

/// @nodoc
class _$UserVoCopyWithImpl<$Res> implements $UserVoCopyWith<$Res> {
  _$UserVoCopyWithImpl(this._self, this._then);

  final UserVo _self;
  final $Res Function(UserVo) _then;

  /// Create a copy of UserVo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? id = null,
  }) {
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserVo extends UserVo {
  _UserVo({required this.name, required this.id}) : super._();
  factory _UserVo.fromJson(Map<String, dynamic> json) => _$UserVoFromJson(json);

  @override
  final String name;
  @override
  final int id;

  /// Create a copy of UserVo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserVoCopyWith<_UserVo> get copyWith =>
      __$UserVoCopyWithImpl<_UserVo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserVoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserVo &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, id);

  @override
  String toString() {
    return 'UserVo(name: $name, id: $id)';
  }
}

/// @nodoc
abstract mixin class _$UserVoCopyWith<$Res> implements $UserVoCopyWith<$Res> {
  factory _$UserVoCopyWith(_UserVo value, $Res Function(_UserVo) _then) =
      __$UserVoCopyWithImpl;
  @override
  @useResult
  $Res call({String name, int id});
}

/// @nodoc
class __$UserVoCopyWithImpl<$Res> implements _$UserVoCopyWith<$Res> {
  __$UserVoCopyWithImpl(this._self, this._then);

  final _UserVo _self;
  final $Res Function(_UserVo) _then;

  /// Create a copy of UserVo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? id = null,
  }) {
    return _then(_UserVo(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
