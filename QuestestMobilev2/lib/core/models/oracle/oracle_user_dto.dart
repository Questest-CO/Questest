import 'package:freezed_annotation/freezed_annotation.dart';

part 'oracle_user_dto.freezed.dart';
part 'oracle_user_dto.g.dart';

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

/// User DTO from Oracle DB API
/// Matches the actual Oracle ORDS response structure
@freezed
class OracleUserDto with _$OracleUserDto {
  const factory OracleUserDto({
    @JsonKey(fromJson: _parseId) required int id,
    String? username,
    @JsonKey(name: 'hashed_password') String? hashedPassword,
    @JsonKey(name: 'date_created') DateTime? dateCreated,
    String? visible,
    // Legacy fields for compatibility (not returned by current API)
    String? email,
    String? name,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _OracleUserDto;

  factory OracleUserDto.fromJson(Map<String, dynamic> json) =>
      _$OracleUserDtoFromJson(json);
}

