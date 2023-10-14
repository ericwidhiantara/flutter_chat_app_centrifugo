import 'package:freezed_annotation/freezed_annotation.dart';

part 'users.freezed.dart';

@freezed
class UserListEntity with _$UserListEntity {
  const factory UserListEntity({
    List<UserEntity>? users,
    int? currentPage,
    int? lastPage,
  }) = _UserListEntity;
}

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    String? name,
    String? avatar,
    String? email,
  }) = _UserEntity;
}
