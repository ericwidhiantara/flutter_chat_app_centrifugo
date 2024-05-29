part of 'create_room_cubit.dart';

@freezed
class CreateRoomState with _$CreateRoomState {
  const factory CreateRoomState.loading() = _Loading;

  const factory CreateRoomState.success(MetaEntity data) = _Success;

  const factory CreateRoomState.failure(Failure type, String message) =
      _Failure;

  const factory CreateRoomState.empty() = _Empty;
}
