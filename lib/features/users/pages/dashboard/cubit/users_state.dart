part of 'users_cubit.dart';

@freezed
class UsersState with _$UsersState {
  const factory UsersState.loading() = _Loading;

  const factory UsersState.success(UserListEntity data) = _Success;

  const factory UsersState.failure(String message) = _Failure;

  const factory UsersState.empty() = _Empty;
}
