import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'users_entity.freezed.dart';
part 'users_entity.g.dart';

@freezed
class UsersEntity with _$UsersEntity {
  const factory UsersEntity({
    MetaEntity? meta,
    List<UserLoginEntity>? data,
    PaginationEntity? pagination,
  }) = _UsersEntity;

  const UsersEntity._(); // Added constructor

  factory UsersEntity.fromJson(Map<String, dynamic> json) =>
      _$UsersEntityFromJson(json);
}
