import 'package:freezed_annotation/freezed_annotation.dart';

part 'filled_questionnaire_model.freezed.dart';
part 'filled_questionnaire_model.g.dart';

/// Filled Questionnaire DTO from Oracle DB API
/// Represents a user's filled questionnaire (history & results)
@freezed
class FilledQuestionnaireModel with _$FilledQuestionnaireModel {
  const factory FilledQuestionnaireModel({
    required int id,
    @JsonKey(name: 'questionnaireid') required int questionnaireId,
    @JsonKey(name: 'date_filled') required DateTime dateFilled,
    @JsonKey(name: 'filled_by') required int filledBy,
    @JsonKey(name: 'result_id') int? resultId,
  }) = _FilledQuestionnaireModel;

  factory FilledQuestionnaireModel.fromJson(Map<String, dynamic> json) =>
      _$FilledQuestionnaireModelFromJson(json);
}

