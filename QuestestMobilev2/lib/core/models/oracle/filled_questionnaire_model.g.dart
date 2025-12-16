// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filled_questionnaire_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FilledQuestionnaireModelImpl _$$FilledQuestionnaireModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FilledQuestionnaireModelImpl(
      id: (json['id'] as num).toInt(),
      questionnaireId: (json['questionnaireid'] as num).toInt(),
      dateFilled: DateTime.parse(json['date_filled'] as String),
      filledBy: (json['filled_by'] as num).toInt(),
      resultId: (json['result_id'] as num?)?.toInt(),
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
