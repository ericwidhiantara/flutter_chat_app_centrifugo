import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'messages_entity.freezed.dart';
part 'messages_entity.g.dart';

@freezed
class MessagesEntity with _$MessagesEntity {
  const factory MessagesEntity({
    List<MessageDataEntity>? data,
    MetaEntity? meta,
    PaginationEntity? pagination,
  }) = _MessagesEntity;

  const MessagesEntity._(); // Added constructor

  factory MessagesEntity.fromJson(Map<String, dynamic> json) =>
      _$MessagesEntityFromJson(json);
}

@freezed
class MessageDataEntity with _$MessageDataEntity {
  const factory MessageDataEntity({
    String? id,
    String? messageId,
    String? roomId,
    String? text,
    String? senderId,
    UserLoginEntity? sender,
    int? createdAt,
    int? updatedAt,
  }) = _MessageDataEntity;

  const MessageDataEntity._(); // Added constructor

  factory MessageDataEntity.fromJson(Map<String, dynamic> json) =>
      _$MessageDataEntityFromJson(json);
}
