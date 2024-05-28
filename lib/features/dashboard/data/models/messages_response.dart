import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'messages_response.freezed.dart';
part 'messages_response.g.dart';

@freezed
class MessagesResponse with _$MessagesResponse {
  const factory MessagesResponse({
    @JsonKey(name: 'data') List<MessageDataResponse>? data,
    @JsonKey(name: 'meta') MetaModel? meta,
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
    @JsonKey(name: '_id') String? id,
    @JsonKey(name: 'message_id') String? messageId,
    @JsonKey(name: 'room_id') String? roomId,
    @JsonKey(name: 'text') String? text,
    @JsonKey(name: 'sender_id') String? senderId,
    @JsonKey(name: 'sender') UserLoginModel? sender,
    @JsonKey(name: 'created_at') int? createdAt,
    @JsonKey(name: 'updated_at') int? updatedAt,
  }) = _MessageDataResponse;

  const MessageDataResponse._(); // Added constructor

  factory MessageDataResponse.fromJson(Map<String, dynamic> json) =>
      _$MessageDataResponseFromJson(json);

  MessageDataEntity toEntity() {
    return MessageDataEntity(
      id: id,
      messageId: messageId,
      roomId: roomId,
      text: text,
      senderId: senderId,
      sender: sender?.toEntity(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
