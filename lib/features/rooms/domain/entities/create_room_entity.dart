import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'create_room_entity.freezed.dart';
part 'create_room_entity.g.dart';

@freezed
class CreateRoomEntity with _$CreateRoomEntity {
  const factory CreateRoomEntity({
    MetaEntity? meta,
    RoomDataEntity? data,
  }) = _CreateRoomEntity;

  const CreateRoomEntity._(); // Added constructor

  factory CreateRoomEntity.fromJson(Map<String, dynamic> json) =>
      _$CreateRoomEntityFromJson(json);
}
