import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'create_room_response.freezed.dart';
part 'create_room_response.g.dart';

@freezed
class CreateRoomResponse with _$CreateRoomResponse {
  const factory CreateRoomResponse({
    @JsonKey(name: 'meta') MetaModel? meta,
    @JsonKey(name: 'data') RoomDataResponse? data,
  }) = _CreateRoomResponse;

  const CreateRoomResponse._(); // Added constructor

  factory CreateRoomResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateRoomResponseFromJson(json);

  CreateRoomEntity toEntity() {
    return CreateRoomEntity(
      data: data?.toEntity(),
      meta: meta?.toEntity(),
    );
  }
}
