import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire_detail_model.freezed.dart';
part 'questionnaire_detail_model.g.dart';

/// Option model for questionnaire questions
@freezed
class QuestionnaireOption with _$QuestionnaireOption {
  const factory QuestionnaireOption({
    required int id,
    required String content,
    @JsonKey(name: 'is_correct')
    bool? isCorrect,
  }) = _QuestionnaireOption;

  factory QuestionnaireOption.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireOptionFromJson(json);
}

/// Question model for questionnaire details
@freezed
class QuestionnaireQuestion with _$QuestionnaireQuestion {
  const factory QuestionnaireQuestion({
    required int id,
    required String content,
    required List<QuestionnaireOption> options,
  }) = _QuestionnaireQuestion;

  factory QuestionnaireQuestion.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireQuestionFromJson(json);
}

/// Questionnaire detail model parsed from questionnaire_json string
/// This represents the full questionnaire structure with questions and options
@freezed
class QuestionnaireDetailModel with _$QuestionnaireDetailModel {
  const factory QuestionnaireDetailModel({
    required int id,
    required String title,
    required List<QuestionnaireQuestion> questions,
  }) = _QuestionnaireDetailModel;

  factory QuestionnaireDetailModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireDetailModelFromJson(json);

  /// Factory method to parse from questionnaire_json string
  /// This handles the double-encoded JSON from Oracle ORDS
  factory QuestionnaireDetailModel.fromJsonString(String jsonString) {
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    return QuestionnaireDetailModel.fromJson(decoded);
  }
}

