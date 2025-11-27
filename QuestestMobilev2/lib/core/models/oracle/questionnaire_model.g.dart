// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionnaireModelImpl _$$QuestionnaireModelImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionnaireModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      categoryId: (json['category_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      questionCount: (json['question_count'] as num?)?.toInt(),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$QuestionnaireModelImplToJson(
        _$QuestionnaireModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category_id': instance.categoryId,
      'user_id': instance.userId,
      'question_count': instance.questionCount,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
