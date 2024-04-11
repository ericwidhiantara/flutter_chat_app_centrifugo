import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user_login_entity.freezed.dart';
part 'user_login_entity.g.dart';

@freezed
@HiveType(typeId: 1)
class UserLoginEntity with _$UserLoginEntity {
  const factory UserLoginEntity({
    @HiveField(10) String? id,
    @HiveField(11) String? email,
    @HiveField(12) String? fullname,
    @HiveField(13) String? username,
    @HiveField(14) bool? isActive,
    @HiveField(21) int? createdAt,
    @HiveField(22) int? updatedAt,
  }) = _UserLoginEntity;

  const UserLoginEntity._();

  factory UserLoginEntity.fromJson(Map<String, dynamic> json) =>
      _$UserLoginEntityFromJson(json);
}
