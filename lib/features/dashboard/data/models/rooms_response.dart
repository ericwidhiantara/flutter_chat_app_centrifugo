import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'rooms_response.freezed.dart';
part 'rooms_response.g.dart';

@freezed
class RoomsResponse with _$RoomsResponse {
  const factory RoomsResponse({
    @JsonKey(name: 'meta') MetaModel? meta,
    @JsonKey(name: 'pagination') PaginationModel? pagination,
    @JsonKey(name: 'data') List<RoomDataResponse>? data,
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
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'room_id') String? roomId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'participants') List<ParticipantDataResponse>? participants,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'updated_at') int? updatedAt,
  }) = _RoomDataResponse;

  const RoomDataResponse._(); // Added constructor

  factory RoomDataResponse.fromJson(Map<String, dynamic> json) =>
      _$RoomDataResponseFromJson(json);

  RoomDataEntity toEntity() {
    return RoomDataEntity(
      id: id,
      roomId: roomId,
      userId: userId,
      name: name,
      participants:
          participants?.map((participant) => participant.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

@freezed
class ParticipantDataResponse with _$ParticipantDataResponse {
  const factory ParticipantDataResponse({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'password') String? password,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'updated_at') int? updatedAt,
  }) = _ParticipantDataResponse;

  const ParticipantDataResponse._(); // Added constructor

  factory ParticipantDataResponse.fromJson(Map<String, dynamic> json) =>
      _$ParticipantDataResponseFromJson(json);

  ParticipantDataEntity toEntity() {
    return ParticipantDataEntity(
      id: id,
      userId: userId,
      email: email,
      name: name,
      phone: phone,
      password: password,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
