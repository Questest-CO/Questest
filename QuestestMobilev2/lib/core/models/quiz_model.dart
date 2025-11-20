import 'package:json_annotation/json_annotation.dart';

part 'quiz_model.g.dart';

/// Quiz model representing a quiz entity
@JsonSerializable()
class QuizModel {
  final String id;
  final String title;
  final String subtitle;
  final String thumbnailUrl;
  final int questionCount;
  final int participantsCount;
  final String? description;
  final int? timeLimit; // in seconds
  final String? difficulty; // easy, medium, hard

  const QuizModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.thumbnailUrl,
    required this.questionCount,
    required this.participantsCount,
    this.description,
    this.timeLimit,
    this.difficulty,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) =>
      _$QuizModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuizModelToJson(this);

  QuizModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? thumbnailUrl,
    int? questionCount,
    int? participantsCount,
    String? description,
    int? timeLimit,
    String? difficulty,
  }) {
    return QuizModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      questionCount: questionCount ?? this.questionCount,
      participantsCount: participantsCount ?? this.participantsCount,
      description: description ?? this.description,
      timeLimit: timeLimit ?? this.timeLimit,
      difficulty: difficulty ?? this.difficulty,
    );
  }
}

