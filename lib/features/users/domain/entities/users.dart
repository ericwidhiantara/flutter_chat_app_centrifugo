import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'users.freezed.dart';

part 'users.g.dart';

@freezed
class UserListEntity with _$UserListEntity {
  const factory UserListEntity({
    List<UserEntity>? users,
    int? currentPage,
    int? lastPage,
  }) = _UserListEntity;
}

@freezed
@HiveType(typeId: 0)
class UserEntity with _$UserEntity {
  const factory UserEntity({
    @HiveField(0) String? name,
    @HiveField(1) String? avatar,
    @HiveField(2) String? email,
  }) = _UserEntity;
}
