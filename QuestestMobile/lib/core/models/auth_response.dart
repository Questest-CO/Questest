import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'auth_response.g.dart';

/// Authentication response model
@JsonSerializable()
class AuthResponse {
  final String token;
  final UserModel user;
  final String tokenType;
  final int expiresIn; // in seconds

  const AuthResponse({
    required this.token,
    required this.user,
    this.tokenType = 'Bearer',
    this.expiresIn = 86400, // 24 hours default
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

