// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filled_questionnaire_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FilledQuestionnaireModelImpl _$$FilledQuestionnaireModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FilledQuestionnaireModelImpl(
      id: _parseId(json['id']),
      questionnaireId: _parseId(json['questionnaireid']),
      dateFilled: DateTime.parse(json['date_filled'] as String),
      filledBy: _parseId(json['filled_by']),
      resultId: _parseNullableInt(json['result_id']),
    );

Map<String, dynamic> _$$FilledQuestionnaireModelImplToJson(
        _$FilledQuestionnaireModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'questionnaireid': instance.questionnaireId,
      'date_filled': instance.dateFilled.toIso8601String(),
      'filled_by': instance.filledBy,
      'result_id': instance.resultId,
    };
