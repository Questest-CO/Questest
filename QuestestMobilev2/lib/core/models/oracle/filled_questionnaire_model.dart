import 'package:freezed_annotation/freezed_annotation.dart';

part 'filled_questionnaire_model.freezed.dart';
part 'filled_questionnaire_model.g.dart';

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

/// Helper function to parse nullable DateTime from API
DateTime? _parseNullableDateTime(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}

/// Filled Questionnaire DTO from Oracle DB API
/// Represents a user's filled questionnaire (history & results)
@freezed
class FilledQuestionnaireModel with _$FilledQuestionnaireModel {
  const factory FilledQuestionnaireModel({
    @JsonKey(fromJson: _parseId) required int id,
    @JsonKey(name: 'questionnaireid', fromJson: _parseId) required int questionnaireId,
    @JsonKey(name: 'date_filled', fromJson: _parseNullableDateTime) DateTime? dateFilled,
    @JsonKey(name: 'filled_by', fromJson: _parseId) required int filledBy,
    @JsonKey(name: 'result_id', fromJson: _parseNullableInt) int? resultId,
  }) = _FilledQuestionnaireModel;

  factory FilledQuestionnaireModel.fromJson(Map<String, dynamic> json) =>
      _$FilledQuestionnaireModelFromJson(json);
}

