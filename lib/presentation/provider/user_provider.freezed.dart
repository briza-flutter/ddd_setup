// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserStore {
  User? get user;
  Token? get token;

  /// Create a copy of UserStore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserStoreCopyWith<UserStore> get copyWith =>
      _$UserStoreCopyWithImpl<UserStore>(this as UserStore, _$identity);

  /// Serializes this UserStore to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserStore &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, user, token);

  @override
  String toString() {
    return 'UserStore(user: $user, token: $token)';
  }
}

/// @nodoc
abstract mixin class $UserStoreCopyWith<$Res> {
  factory $UserStoreCopyWith(UserStore value, $Res Function(UserStore) _then) =
      _$UserStoreCopyWithImpl;
  @useResult
  $Res call({User? user, Token? token});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$UserStoreCopyWithImpl<$Res> implements $UserStoreCopyWith<$Res> {
  _$UserStoreCopyWithImpl(this._self, this._then);

  final UserStore _self;
  final $Res Function(UserStore) _then;

  /// Create a copy of UserStore
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

  /// Create a copy of UserStore
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
@JsonSerializable()
class _UserStore implements UserStore {
  _UserStore({required this.user, required this.token});
  factory _UserStore.fromJson(Map<String, dynamic> json) =>
      _$UserStoreFromJson(json);

  @override
  final User? user;
  @override
  final Token? token;

  /// Create a copy of UserStore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserStoreCopyWith<_UserStore> get copyWith =>
      __$UserStoreCopyWithImpl<_UserStore>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserStoreToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserStore &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.token, token) || other.token == token));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, user, token);

  @override
  String toString() {
    return 'UserStore(user: $user, token: $token)';
  }
}

/// @nodoc
abstract mixin class _$UserStoreCopyWith<$Res>
    implements $UserStoreCopyWith<$Res> {
  factory _$UserStoreCopyWith(
          _UserStore value, $Res Function(_UserStore) _then) =
      __$UserStoreCopyWithImpl;
  @override
  @useResult
  $Res call({User? user, Token? token});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$UserStoreCopyWithImpl<$Res> implements _$UserStoreCopyWith<$Res> {
  __$UserStoreCopyWithImpl(this._self, this._then);

  final _UserStore _self;
  final $Res Function(_UserStore) _then;

  /// Create a copy of UserStore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? user = freezed,
    Object? token = freezed,
  }) {
    return _then(_UserStore(
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

  /// Create a copy of UserStore
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
