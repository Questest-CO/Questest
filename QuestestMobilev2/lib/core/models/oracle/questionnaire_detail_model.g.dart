// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'questionnaire_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$QuestionnaireOptionImpl _$$QuestionnaireOptionImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionnaireOptionImpl(
      id: (json['id'] as num).toInt(),
      content: json['content'] as String,
      isCorrect: json['is_correct'] as bool?,
    );

Map<String, dynamic> _$$QuestionnaireOptionImplToJson(
        _$QuestionnaireOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'is_correct': instance.isCorrect,
    };

_$QuestionnaireQuestionImpl _$$QuestionnaireQuestionImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionnaireQuestionImpl(
      id: (json['id'] as num).toInt(),
      content: json['content'] as String,
      options: (json['options'] as List<dynamic>)
          .map((e) => QuestionnaireOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuestionnaireQuestionImplToJson(
        _$QuestionnaireQuestionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'options': instance.options,
    };

_$QuestionnaireDetailModelImpl _$$QuestionnaireDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$QuestionnaireDetailModelImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      questions: (json['questions'] as List<dynamic>)
          .map((e) => QuestionnaireQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$QuestionnaireDetailModelImplToJson(
        _$QuestionnaireDetailModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'questions': instance.questions,
    };
