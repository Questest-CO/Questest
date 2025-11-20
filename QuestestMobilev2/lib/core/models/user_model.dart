import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

/// User model representing a user entity
@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final int? totalQuizzesTaken;
  final int? totalPoints;
  final String? bio;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.totalQuizzesTaken,
    this.totalPoints,
    this.bio,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    int? totalQuizzesTaken,
    int? totalPoints,
    String? bio,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalQuizzesTaken: totalQuizzesTaken ?? this.totalQuizzesTaken,
      totalPoints: totalPoints ?? this.totalPoints,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

