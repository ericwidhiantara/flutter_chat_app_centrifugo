import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_login_entity.freezed.dart';
part 'user_login_entity.g.dart';

@HiveType(typeId: 1)
@freezed
class UserLoginEntity with _$UserLoginEntity {
  const factory UserLoginEntity({
    @HiveField(10) @JsonKey(name: "user_id") String? userId,
    @HiveField(11) @JsonKey(name: "email") String? email,
    @HiveField(12) @JsonKey(name: "name") String? name,
    @HiveField(13) @JsonKey(name: "username") String? username,
    @HiveField(14) @JsonKey(name: "phone") String? phone,
    @HiveField(15) @JsonKey(name: "picture") String? picture,
    @HiveField(16) @JsonKey(name: "is_active") bool? isActive,
    @HiveField(17) @JsonKey(name: "created_at") int? createdAt,
    @HiveField(18) @JsonKey(name: "updated_at") int? updatedAt,
  }) = _UserLoginEntity;

  const UserLoginEntity._(); // Added constructor

  factory UserLoginEntity.fromJson(Map<String, dynamic> json) =>
      _$UserLoginEntityFromJson(json);
}
