import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'messages_response.freezed.dart';
part 'messages_response.g.dart';

@freezed
class MessagesResponse with _$MessagesResponse {
  const factory MessagesResponse({
    @JsonKey(name: 'meta') MetaModel? meta,
    @JsonKey(name: 'data') List<MessageDataResponse>? data,
    @JsonKey(name: 'pagination') PaginationModel? pagination,
  }) = _MessagesResponse;

  const MessagesResponse._(); // Added constructor

  factory MessagesResponse.fromJson(Map<String, dynamic> json) =>
      _$MessagesResponseFromJson(json);

  MessagesEntity toEntity() {
    return MessagesEntity(
      data: data?.map((message) => message.toEntity()).toList(),
      meta: meta?.toEntity(),
      pagination: pagination?.toEntity(),
    );
  }
}

@freezed
class MessageDataResponse with _$MessageDataResponse {
  const factory MessageDataResponse({
    @JsonKey(name: 'message_id') String? messageId,
    @JsonKey(name: 'room_id') String? roomId,
    @JsonKey(name: 'sender_id') String? senderId,
    @JsonKey(name: 'text') String? text,
    @JsonKey(name: 'message_status') String? messageStatus,
    @JsonKey(name: 'sender') UserLoginModel? sender,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'updated_at') int? updatedAt,
  }) = _MessageDataResponse;

  const MessageDataResponse._(); // Added constructor

  factory MessageDataResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageDataResponseFromJson(json);

  MessageDataEntity toEntity() {
    return MessageDataEntity(
      messageId: messageId,
      roomId: roomId,
      senderId: senderId,
      text: text,
      messageStatus: messageStatus,
      sender: sender?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
