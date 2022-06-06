// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserID {
  UniqueId get id => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserIDCopyWith<UserID> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserIDCopyWith<$Res> {
  factory $UserIDCopyWith(UserID value, $Res Function(UserID) then) =
      _$UserIDCopyWithImpl<$Res>;
  $Res call({UniqueId id});
}

/// @nodoc
class _$UserIDCopyWithImpl<$Res> implements $UserIDCopyWith<$Res> {
  _$UserIDCopyWithImpl(this._value, this._then);

  final UserID _value;
  // ignore: unused_field
  final $Res Function(UserID) _then;

  @override
  $Res call({
    Object? id = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as UniqueId,
    ));
  }
}

/// @nodoc
abstract class _$$_UserIDCopyWith<$Res> implements $UserIDCopyWith<$Res> {
  factory _$$_UserIDCopyWith(_$_UserID value, $Res Function(_$_UserID) then) =
      __$$_UserIDCopyWithImpl<$Res>;
  @override
  $Res call({UniqueId id});
}

/// @nodoc
class __$$_UserIDCopyWithImpl<$Res> extends _$UserIDCopyWithImpl<$Res>
    implements _$$_UserIDCopyWith<$Res> {
  __$$_UserIDCopyWithImpl(_$_UserID _value, $Res Function(_$_UserID) _then)
      : super(_value, (v) => _then(v as _$_UserID));

  @override
  _$_UserID get _value => super._value as _$_UserID;

  @override
  $Res call({
    Object? id = freezed,
  }) {
    return _then(_$_UserID(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as UniqueId,
    ));
  }
}

/// @nodoc

class _$_UserID implements _UserID {
  const _$_UserID({required this.id});

  @override
  final UniqueId id;

  @override
  String toString() {
    return 'UserID(id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserID &&
            const DeepCollectionEquality().equals(other.id, id));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(id));

  @JsonKey(ignore: true)
  @override
  _$$_UserIDCopyWith<_$_UserID> get copyWith =>
      __$$_UserIDCopyWithImpl<_$_UserID>(this, _$identity);
}

abstract class _UserID implements UserID {
  const factory _UserID({required final UniqueId id}) = _$_UserID;

  @override
  UniqueId get id => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$$_UserIDCopyWith<_$_UserID> get copyWith =>
      throw _privateConstructorUsedError;
}
