// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'oracle_user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OracleUserDto _$OracleUserDtoFromJson(Map<String, dynamic> json) {
  return _OracleUserDto.fromJson(json);
}

/// @nodoc
mixin _$OracleUserDto {
  @JsonKey(fromJson: _parseId)
  int get id => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  @JsonKey(name: 'hashed_password')
  String? get hashedPassword => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_created')
  DateTime? get dateCreated => throw _privateConstructorUsedError;
  String? get visible =>
      throw _privateConstructorUsedError; // Legacy fields for compatibility (not returned by current API)
  String? get email => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OracleUserDtoCopyWith<OracleUserDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OracleUserDtoCopyWith<$Res> {
  factory $OracleUserDtoCopyWith(
          OracleUserDto value, $Res Function(OracleUserDto) then) =
      _$OracleUserDtoCopyWithImpl<$Res, OracleUserDto>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseId) int id,
      String? username,
      @JsonKey(name: 'hashed_password') String? hashedPassword,
      @JsonKey(name: 'date_created') DateTime? dateCreated,
      String? visible,
      String? email,
      String? name,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'avatar_url') String? avatarUrl});
}

/// @nodoc
class _$OracleUserDtoCopyWithImpl<$Res, $Val extends OracleUserDto>
    implements $OracleUserDtoCopyWith<$Res> {
  _$OracleUserDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = freezed,
    Object? hashedPassword = freezed,
    Object? dateCreated = freezed,
    Object? visible = freezed,
    Object? email = freezed,
    Object? name = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      hashedPassword: freezed == hashedPassword
          ? _value.hashedPassword
          : hashedPassword // ignore: cast_nullable_to_non_nullable
              as String?,
      dateCreated: freezed == dateCreated
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      visible: freezed == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OracleUserDtoImplCopyWith<$Res>
    implements $OracleUserDtoCopyWith<$Res> {
  factory _$$OracleUserDtoImplCopyWith(
          _$OracleUserDtoImpl value, $Res Function(_$OracleUserDtoImpl) then) =
      __$$OracleUserDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: _parseId) int id,
      String? username,
      @JsonKey(name: 'hashed_password') String? hashedPassword,
      @JsonKey(name: 'date_created') DateTime? dateCreated,
      String? visible,
      String? email,
      String? name,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'avatar_url') String? avatarUrl});
}

/// @nodoc
class __$$OracleUserDtoImplCopyWithImpl<$Res>
    extends _$OracleUserDtoCopyWithImpl<$Res, _$OracleUserDtoImpl>
    implements _$$OracleUserDtoImplCopyWith<$Res> {
  __$$OracleUserDtoImplCopyWithImpl(
      _$OracleUserDtoImpl _value, $Res Function(_$OracleUserDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = freezed,
    Object? hashedPassword = freezed,
    Object? dateCreated = freezed,
    Object? visible = freezed,
    Object? email = freezed,
    Object? name = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? avatarUrl = freezed,
  }) {
    return _then(_$OracleUserDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      hashedPassword: freezed == hashedPassword
          ? _value.hashedPassword
          : hashedPassword // ignore: cast_nullable_to_non_nullable
              as String?,
      dateCreated: freezed == dateCreated
          ? _value.dateCreated
          : dateCreated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      visible: freezed == visible
          ? _value.visible
          : visible // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OracleUserDtoImpl implements _OracleUserDto {
  const _$OracleUserDtoImpl(
      {@JsonKey(fromJson: _parseId) required this.id,
      this.username,
      @JsonKey(name: 'hashed_password') this.hashedPassword,
      @JsonKey(name: 'date_created') this.dateCreated,
      this.visible,
      this.email,
      this.name,
      @JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      @JsonKey(name: 'avatar_url') this.avatarUrl});

  factory _$OracleUserDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$OracleUserDtoImplFromJson(json);

  @override
  @JsonKey(fromJson: _parseId)
  final int id;
  @override
  final String? username;
  @override
  @JsonKey(name: 'hashed_password')
  final String? hashedPassword;
  @override
  @JsonKey(name: 'date_created')
  final DateTime? dateCreated;
  @override
  final String? visible;
// Legacy fields for compatibility (not returned by current API)
  @override
  final String? email;
  @override
  final String? name;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;

  @override
  String toString() {
    return 'OracleUserDto(id: $id, username: $username, hashedPassword: $hashedPassword, dateCreated: $dateCreated, visible: $visible, email: $email, name: $name, firstName: $firstName, lastName: $lastName, avatarUrl: $avatarUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OracleUserDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.hashedPassword, hashedPassword) ||
                other.hashedPassword == hashedPassword) &&
            (identical(other.dateCreated, dateCreated) ||
                other.dateCreated == dateCreated) &&
            (identical(other.visible, visible) || other.visible == visible) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, username, hashedPassword,
      dateCreated, visible, email, name, firstName, lastName, avatarUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OracleUserDtoImplCopyWith<_$OracleUserDtoImpl> get copyWith =>
      __$$OracleUserDtoImplCopyWithImpl<_$OracleUserDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OracleUserDtoImplToJson(
      this,
    );
  }
}

abstract class _OracleUserDto implements OracleUserDto {
  const factory _OracleUserDto(
          {@JsonKey(fromJson: _parseId) required final int id,
          final String? username,
          @JsonKey(name: 'hashed_password') final String? hashedPassword,
          @JsonKey(name: 'date_created') final DateTime? dateCreated,
          final String? visible,
          final String? email,
          final String? name,
          @JsonKey(name: 'first_name') final String? firstName,
          @JsonKey(name: 'last_name') final String? lastName,
          @JsonKey(name: 'avatar_url') final String? avatarUrl}) =
      _$OracleUserDtoImpl;

  factory _OracleUserDto.fromJson(Map<String, dynamic> json) =
      _$OracleUserDtoImpl.fromJson;

  @override
  @JsonKey(fromJson: _parseId)
  int get id;
  @override
  String? get username;
  @override
  @JsonKey(name: 'hashed_password')
  String? get hashedPassword;
  @override
  @JsonKey(name: 'date_created')
  DateTime? get dateCreated;
  @override
  String? get visible;
  @override // Legacy fields for compatibility (not returned by current API)
  String? get email;
  @override
  String? get name;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(ignore: true)
  _$$OracleUserDtoImplCopyWith<_$OracleUserDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
