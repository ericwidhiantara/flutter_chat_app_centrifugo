part of 'saved_users_cubit.dart';

@freezed
class SavedUsersState with _$SavedUsersState {
  const factory SavedUsersState.loading() = _Loading;

  const factory SavedUsersState.success(
    List<UserEntity>? data,
    String message,
  ) = _Success;

  const factory SavedUsersState.failure(String message) = _Failure;

  const factory SavedUsersState.empty() = _Empty;
}
