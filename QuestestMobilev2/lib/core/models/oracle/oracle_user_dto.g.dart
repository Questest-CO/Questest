// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oracle_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OracleUserDtoImpl _$$OracleUserDtoImplFromJson(Map<String, dynamic> json) =>
    _$OracleUserDtoImpl(
      id: _parseId(json['id']),
      username: json['username'] as String?,
      hashedPassword: json['hashed_password'] as String?,
      dateCreated: json['date_created'] == null
          ? null
          : DateTime.parse(json['date_created'] as String),
      visible: json['visible'] as String?,
      email: json['email'] as String?,
      name: json['name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );

Map<String, dynamic> _$$OracleUserDtoImplToJson(_$OracleUserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'hashed_password': instance.hashedPassword,
      'date_created': instance.dateCreated?.toIso8601String(),
      'visible': instance.visible,
      'email': instance.email,
      'name': instance.name,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar_url': instance.avatarUrl,
    };
