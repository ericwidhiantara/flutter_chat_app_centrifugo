import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'rooms_response.freezed.dart';
part 'rooms_response.g.dart';

@freezed
class RoomsResponse with _$RoomsResponse {
  const factory RoomsResponse({
    @JsonKey(name: 'meta') MetaModel? meta,
    @JsonKey(name: 'data') List<RoomDataResponse>? data,
    @JsonKey(name: 'pagination') PaginationModel? pagination,
  }) = _RoomsResponse;

  const RoomsResponse._(); // Added constructor

  factory RoomsResponse.fromJson(Map<String, dynamic> json) =>
      _$RoomsResponseFromJson(json);

  RoomsEntity toEntity() {
    return RoomsEntity(
      data: data?.map((room) => room.toEntity()).toList(),
      meta: meta?.toEntity(),
      pagination: pagination?.toEntity(),
    );
  }
}

@freezed
class RoomDataResponse with _$RoomDataResponse {
  const factory RoomDataResponse({
    @JsonKey(name: 'room_id') String? roomId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'room_type') String? roomType,
    @JsonKey(name: 'participants') List<UserLoginModel>? participants,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'updated_at') int? updatedAt,
  }) = _RoomDataResponse;

  const RoomDataResponse._(); // Added constructor

  factory RoomDataResponse.fromJson(Map<String, dynamic> json) =>
      _$RoomDataResponseFromJson(json);

  RoomDataEntity toEntity() {
    return RoomDataEntity(
      roomId: roomId,
      userId: userId,
      name: name,
      roomType: roomType,
      participants:
          participants?.map((participant) => participant.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
