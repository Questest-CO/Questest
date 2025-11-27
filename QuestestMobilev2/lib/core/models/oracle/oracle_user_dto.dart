import 'package:freezed_annotation/freezed_annotation.dart';

part 'oracle_user_dto.freezed.dart';
part 'oracle_user_dto.g.dart';

/// User DTO from Oracle DB API
/// Separate from main UserModel to avoid conflicts
@freezed
class OracleUserDto with _$OracleUserDto {
  const factory OracleUserDto({
    required int id,
    String? email,
    String? name,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    String? bio,
    @JsonKey(name: 'is_active') bool? isActive,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _OracleUserDto;

  factory OracleUserDto.fromJson(Map<String, dynamic> json) =>
      _$OracleUserDtoFromJson(json);
}

