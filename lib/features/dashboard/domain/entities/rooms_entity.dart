import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'rooms_entity.freezed.dart';
part 'rooms_entity.g.dart';

@freezed
class RoomsEntity with _$RoomsEntity {
  const factory RoomsEntity({
    MetaEntity? meta,
    PaginationEntity? pagination,
    List<RoomDataEntity>? data,
  }) = _RoomsEntity;

  const RoomsEntity._(); // Added constructor

  factory RoomsEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomsEntityFromJson(json);
}

@freezed
class RoomDataEntity with _$RoomDataEntity {
  const factory RoomDataEntity({
    String? id,
    String? roomId,
    String? userId,
    String? name,
    List<ParticipantDataEntity>? participants,
    int? createdAt,
    int? updatedAt,
  }) = _RoomDataEntity;

  const RoomDataEntity._(); // Added constructor

  factory RoomDataEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomDataEntityFromJson(json);
}

@freezed
class ParticipantDataEntity with _$ParticipantDataEntity {
  const factory ParticipantDataEntity({
    String? id,
    String? userId,
    String? email,
    String? name,
    String? phone,
    String? password,
    int? createdAt,
    int? updatedAt,
  }) = _ParticipantDataEntity;

  const ParticipantDataEntity._(); // Added constructor

  factory ParticipantDataEntity.fromJson(Map<String, dynamic> json) =>
      _$ParticipantDataEntityFromJson(json);
}
