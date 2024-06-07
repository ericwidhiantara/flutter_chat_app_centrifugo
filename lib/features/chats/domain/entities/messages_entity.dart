import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'messages_entity.freezed.dart';
part 'messages_entity.g.dart';

@freezed
class MessagesEntity with _$MessagesEntity {
  const factory MessagesEntity({
    MetaEntity? meta,
    List<MessageDataEntity>? data,
    PaginationEntity? pagination,
  }) = _MessagesEntity;

  const MessagesEntity._(); // Added constructor

  factory MessagesEntity.fromJson(Map<String, dynamic> json) =>
      _$MessagesEntityFromJson(json);
}

@freezed
class MessageDataEntity with _$MessageDataEntity {
  const factory MessageDataEntity({
    @JsonKey(name: "message_id") String? messageId,
    @JsonKey(name: "room_id") String? roomId,
    @JsonKey(name: "sender_id") String? senderId,
    @JsonKey(name: "text") String? text,
    @JsonKey(name: "message_status") String? messageStatus,
    @JsonKey(name: "sender") UserLoginEntity? sender,
    @JsonKey(name: "created_at") int? createdAt,
    @JsonKey(name: "updated-at") int? updatedAt,
  }) = _MessageDataEntity;

  const MessageDataEntity._(); // Added constructor

  factory MessageDataEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageDataEntityFromJson(json);
}
