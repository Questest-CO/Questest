// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quiz_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuizModel _$QuizModelFromJson(Map<String, dynamic> json) => QuizModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String,
      questionCount: (json['questionCount'] as num).toInt(),
      participantsCount: (json['participantsCount'] as num).toInt(),
      description: json['description'] as String?,
      timeLimit: (json['timeLimit'] as num?)?.toInt(),
      difficulty: json['difficulty'] as String?,
    );

Map<String, dynamic> _$QuizModelToJson(QuizModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'thumbnailUrl': instance.thumbnailUrl,
      'questionCount': instance.questionCount,
      'participantsCount': instance.participantsCount,
      'description': instance.description,
      'timeLimit': instance.timeLimit,
      'difficulty': instance.difficulty,
    };
