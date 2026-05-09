// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_resp_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginRespModel {
  String get token;
  @JsonKey(name: 'appUser')
  UserModel get user;

  /// Create a copy of LoginRespModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoginRespModelCopyWith<LoginRespModel> get copyWith =>
      _$LoginRespModelCopyWithImpl<LoginRespModel>(
          this as LoginRespModel, _$identity);

  /// Serializes this LoginRespModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoginRespModel &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, user);

  @override
  String toString() {
    return 'LoginRespModel(token: $token, user: $user)';
  }
}

/// @nodoc
abstract mixin class $LoginRespModelCopyWith<$Res> {
  factory $LoginRespModelCopyWith(
          LoginRespModel value, $Res Function(LoginRespModel) _then) =
      _$LoginRespModelCopyWithImpl;
  @useResult
  $Res call({String token, @JsonKey(name: 'appUser') UserModel user});

  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class _$LoginRespModelCopyWithImpl<$Res>
    implements $LoginRespModelCopyWith<$Res> {
  _$LoginRespModelCopyWithImpl(this._self, this._then);

  final LoginRespModel _self;
  final $Res Function(LoginRespModel) _then;

  /// Create a copy of LoginRespModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? token = null,
    Object? user = null,
  }) {
    return _then(_self.copyWith(
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
    ));
  }

  /// Create a copy of LoginRespModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _LoginRespModel extends LoginRespModel {
  _LoginRespModel(
      {required this.token, @JsonKey(name: 'appUser') required this.user})
      : super._();
  factory _LoginRespModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRespModelFromJson(json);

  @override
  final String token;
  @override
  @JsonKey(name: 'appUser')
  final UserModel user;

  /// Create a copy of LoginRespModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoginRespModelCopyWith<_LoginRespModel> get copyWith =>
      __$LoginRespModelCopyWithImpl<_LoginRespModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LoginRespModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoginRespModel &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, token, user);

  @override
  String toString() {
    return 'LoginRespModel(token: $token, user: $user)';
  }
}

/// @nodoc
abstract mixin class _$LoginRespModelCopyWith<$Res>
    implements $LoginRespModelCopyWith<$Res> {
  factory _$LoginRespModelCopyWith(
          _LoginRespModel value, $Res Function(_LoginRespModel) _then) =
      __$LoginRespModelCopyWithImpl;
  @override
  @useResult
  $Res call({String token, @JsonKey(name: 'appUser') UserModel user});

  @override
  $UserModelCopyWith<$Res> get user;
}

/// @nodoc
class __$LoginRespModelCopyWithImpl<$Res>
    implements _$LoginRespModelCopyWith<$Res> {
  __$LoginRespModelCopyWithImpl(this._self, this._then);

  final _LoginRespModel _self;
  final $Res Function(_LoginRespModel) _then;

  /// Create a copy of LoginRespModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? token = null,
    Object? user = null,
  }) {
    return _then(_LoginRespModel(
      token: null == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as String,
      user: null == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as UserModel,
    ));
  }

  /// Create a copy of LoginRespModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserModelCopyWith<$Res> get user {
    return $UserModelCopyWith<$Res>(_self.user, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

// dart format on
