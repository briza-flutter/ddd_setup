// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_param.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginParam {
  PhoneNumber get phoneNumber;
  Password get password;

  /// Create a copy of LoginParam
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LoginParamCopyWith<LoginParam> get copyWith =>
      _$LoginParamCopyWithImpl<LoginParam>(this as LoginParam, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LoginParam &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber, password);

  @override
  String toString() {
    return 'LoginParam(phoneNumber: $phoneNumber, password: $password)';
  }
}

/// @nodoc
abstract mixin class $LoginParamCopyWith<$Res> {
  factory $LoginParamCopyWith(
          LoginParam value, $Res Function(LoginParam) _then) =
      _$LoginParamCopyWithImpl;
  @useResult
  $Res call({PhoneNumber phoneNumber, Password password});
}

/// @nodoc
class _$LoginParamCopyWithImpl<$Res> implements $LoginParamCopyWith<$Res> {
  _$LoginParamCopyWithImpl(this._self, this._then);

  final LoginParam _self;
  final $Res Function(LoginParam) _then;

  /// Create a copy of LoginParam
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneNumber = null,
    Object? password = null,
  }) {
    return _then(_self.copyWith(
      phoneNumber: null == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as PhoneNumber,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as Password,
    ));
  }
}

/// @nodoc

class _LoginParam implements LoginParam {
  _LoginParam({required this.phoneNumber, required this.password});

  @override
  final PhoneNumber phoneNumber;
  @override
  final Password password;

  /// Create a copy of LoginParam
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LoginParamCopyWith<_LoginParam> get copyWith =>
      __$LoginParamCopyWithImpl<_LoginParam>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LoginParam &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.password, password) ||
                other.password == password));
  }

  @override
  int get hashCode => Object.hash(runtimeType, phoneNumber, password);

  @override
  String toString() {
    return 'LoginParam(phoneNumber: $phoneNumber, password: $password)';
  }
}

/// @nodoc
abstract mixin class _$LoginParamCopyWith<$Res>
    implements $LoginParamCopyWith<$Res> {
  factory _$LoginParamCopyWith(
          _LoginParam value, $Res Function(_LoginParam) _then) =
      __$LoginParamCopyWithImpl;
  @override
  @useResult
  $Res call({PhoneNumber phoneNumber, Password password});
}

/// @nodoc
class __$LoginParamCopyWithImpl<$Res> implements _$LoginParamCopyWith<$Res> {
  __$LoginParamCopyWithImpl(this._self, this._then);

  final _LoginParam _self;
  final $Res Function(_LoginParam) _then;

  /// Create a copy of LoginParam
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? phoneNumber = null,
    Object? password = null,
  }) {
    return _then(_LoginParam(
      phoneNumber: null == phoneNumber
          ? _self.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as PhoneNumber,
      password: null == password
          ? _self.password
          : password // ignore: cast_nullable_to_non_nullable
              as Password,
    ));
  }
}

// dart format on
