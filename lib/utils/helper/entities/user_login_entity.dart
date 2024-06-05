import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_login_entity.freezed.dart';
part 'user_login_entity.g.dart';

@HiveType(typeId: 1)
@freezed
class UserLoginEntity with _$UserLoginEntity {
  const factory UserLoginEntity({
    @HiveField(10) String? userId,
    @HiveField(11) String? email,
    @HiveField(12) String? name,
    @HiveField(13) String? username,
    @HiveField(14) String? phone,
    @HiveField(15) String? picture,
    @HiveField(16) bool? isActive,
    @HiveField(17) int? createdAt,
    @HiveField(18) int? updatedAt,
  }) = _UserLoginEntity;

  const UserLoginEntity._(); // Added constructor

  factory UserLoginEntity.fromJson(Map<String, dynamic> json) =>
      _$UserLoginEntityFromJson(json);
}
