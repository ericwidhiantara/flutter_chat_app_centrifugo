import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'post_send_message_usecase.freezed.dart';
part 'post_send_message_usecase.g.dart';

class PostSendMessageUsecase
    extends UseCase<MetaEntity, PostSendMessageParams> {
  final ChatsRepository _repo;

  PostSendMessageUsecase(this._repo);

  @override
  Future<Either<Failure, MetaEntity>> call(PostSendMessageParams params) =>
      _repo.sendMessage(params);
}

@freezed
class PostSendMessageParams with _$PostSendMessageParams {
  const factory PostSendMessageParams({
    @JsonKey(name: "text") required String text,
    @JsonKey(name: "room_id") required String roomId,
  }) = _PostSendMessageParams;

  factory PostSendMessageParams.fromJson(Map<String, dynamic> json) =>
      _$PostSendMessageParamsFromJson(json);
}
