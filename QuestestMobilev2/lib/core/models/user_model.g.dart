// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      totalQuizzesTaken: (json['totalQuizzesTaken'] as num?)?.toInt(),
      totalPoints: (json['totalPoints'] as num?)?.toInt(),
      bio: json['bio'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'totalQuizzesTaken': instance.totalQuizzesTaken,
      'totalPoints': instance.totalPoints,
      'bio': instance.bio,
      'createdAt': instance.createdAt.toIso8601String(),
    };
