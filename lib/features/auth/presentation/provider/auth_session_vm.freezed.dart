// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_session_vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthSessionStore {
  User? get user;
  Token? get token;

  /// Create a copy of AuthSessionStore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AuthSessionStoreCopyWith<AuthSessionStore> get copyWith =>
      _$AuthSessionStoreCopyWithImpl<AuthSessionStore>(
          this as AuthSessionStore, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AuthSessionStore &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, token);

  @override
  String toString() {
    return 'AuthSessionStore(user: $user, token: $token)';
  }
}

/// @nodoc
abstract mixin class $AuthSessionStoreCopyWith<$Res> {
  factory $AuthSessionStoreCopyWith(
          AuthSessionStore value, $Res Function(AuthSessionStore) _then) =
      _$AuthSessionStoreCopyWithImpl;
  @useResult
  $Res call({User? user, Token? token});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$AuthSessionStoreCopyWithImpl<$Res>
    implements $AuthSessionStoreCopyWith<$Res> {
  _$AuthSessionStoreCopyWithImpl(this._self, this._then);

  final AuthSessionStore _self;
  final $Res Function(AuthSessionStore) _then;

  /// Create a copy of AuthSessionStore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? token = freezed,
  }) {
    return _then(_self.copyWith(
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as Token?,
    ));
  }

  /// Create a copy of AuthSessionStore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

/// @nodoc

class _AuthSessionStore implements AuthSessionStore {
  _AuthSessionStore({required this.user, required this.token});

  @override
  final User? user;
  @override
  final Token? token;

  /// Create a copy of AuthSessionStore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AuthSessionStoreCopyWith<_AuthSessionStore> get copyWith =>
      __$AuthSessionStoreCopyWithImpl<_AuthSessionStore>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AuthSessionStore &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user, token);

  @override
  String toString() {
    return 'AuthSessionStore(user: $user, token: $token)';
  }
}

/// @nodoc
abstract mixin class _$AuthSessionStoreCopyWith<$Res>
    implements $AuthSessionStoreCopyWith<$Res> {
  factory _$AuthSessionStoreCopyWith(
          _AuthSessionStore value, $Res Function(_AuthSessionStore) _then) =
      __$AuthSessionStoreCopyWithImpl;
  @override
  @useResult
  $Res call({User? user, Token? token});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$AuthSessionStoreCopyWithImpl<$Res>
    implements _$AuthSessionStoreCopyWith<$Res> {
  __$AuthSessionStoreCopyWithImpl(this._self, this._then);

  final _AuthSessionStore _self;
  final $Res Function(_AuthSessionStore) _then;

  /// Create a copy of AuthSessionStore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = freezed,
    Object? token = freezed,
  }) {
    return _then(_AuthSessionStore(
      user: freezed == user
          ? _self.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      token: freezed == token
          ? _self.token
          : token // ignore: cast_nullable_to_non_nullable
              as Token?,
    ));
  }

  /// Create a copy of AuthSessionStore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_self.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_self.user!, (value) {
      return _then(_self.copyWith(user: value));
    });
  }
}

// dart format on
