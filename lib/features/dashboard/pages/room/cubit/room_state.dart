part of 'room_cubit.dart';

@freezed
class RoomState with _$RoomState {
  const factory RoomState.loading() = _Loading;

  const factory RoomState.success(RoomsEntity data) = _Success;

  const factory RoomState.failure(Failure type, String message) = _Failure;

  const factory RoomState.empty() = _Empty;
}
