import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire_model.freezed.dart';
part 'questionnaire_model.g.dart';

/// Questionnaire DTO from Oracle DB API
/// Represents a questionnaire/survey entity
@freezed
class QuestionnaireModel with _$QuestionnaireModel {
  const factory QuestionnaireModel({
    required int id,
    String? title,
    String? description,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'question_count') int? questionCount,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _QuestionnaireModel;

  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireModelFromJson(json);
}

