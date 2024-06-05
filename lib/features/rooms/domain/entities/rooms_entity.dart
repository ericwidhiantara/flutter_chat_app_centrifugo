import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'rooms_entity.freezed.dart';
part 'rooms_entity.g.dart';

@freezed
class RoomsEntity with _$RoomsEntity {
  const factory RoomsEntity({
    MetaEntity? meta,
    List<RoomDataEntity>? data,
    PaginationEntity? pagination,
  }) = _RoomsEntity;

  const RoomsEntity._(); // Added constructor

  factory RoomsEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomsEntityFromJson(json);
}

@freezed
class RoomDataEntity with _$RoomDataEntity {
  const factory RoomDataEntity({
    String? roomId,
    String? userId,
    String? name,
    String? roomType,
    List<UserLoginEntity>? participants,
    int? createdAt,
    int? updatedAt,
  }) = _RoomDataEntity;

  const RoomDataEntity._(); // Added constructor

  factory RoomDataEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomDataEntityFromJson(json);
}
