// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oracle_user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OracleUserDtoImpl _$$OracleUserDtoImplFromJson(Map<String, dynamic> json) =>
    _$OracleUserDtoImpl(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String?,
      name: json['name'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$OracleUserDtoImplToJson(_$OracleUserDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar_url': instance.avatarUrl,
      'bio': instance.bio,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
