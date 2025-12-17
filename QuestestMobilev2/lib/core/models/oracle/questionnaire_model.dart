import 'package:freezed_annotation/freezed_annotation.dart';

part 'questionnaire_model.freezed.dart';
part 'questionnaire_model.g.dart';

/// Helper function to parse id that can be either int, String, or null from API
/// Returns -1 for null/invalid values (to be filtered out later)
int _parseId(dynamic value) {
  if (value == null) return -1; // Handle null gracefully
  if (value is int) return value;
  if (value is String) {
    final parsed = int.tryParse(value);
    return parsed ?? -1;
  }
  if (value is num) return value.toInt();
  return -1; // Return -1 for any unparseable value
}

/// Helper function to parse nullable int that can be either int or String from API
int? _parseNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is num) return value.toInt();
  return null;
}

/// Questionnaire DTO from Oracle DB API
/// Represents a questionnaire/survey entity
@freezed
class QuestionnaireModel with _$QuestionnaireModel {
  const factory QuestionnaireModel({
    @JsonKey(fromJson: _parseId) required int id,
    String? title,
    String? description,
    @JsonKey(name: 'category_id', fromJson: _parseNullableInt) int? categoryId,
    @JsonKey(name: 'user_id', fromJson: _parseNullableInt) int? userId,
    @JsonKey(name: 'question_count', fromJson: _parseNullableInt) int? questionCount,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _QuestionnaireModel;

  factory QuestionnaireModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionnaireModelFromJson(json);
}

