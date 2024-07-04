import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'post_read_single_message_usecase.freezed.dart';
part 'post_read_single_message_usecase.g.dart';

class PostReadSingleMessageUsecase
    extends UseCase<MetaEntity, PostReadSingleMessageParams> {
  final ChatsRepository _repo;

  PostReadSingleMessageUsecase(this._repo);

  @override
  Future<Either<Failure, MetaEntity>> call(
    PostReadSingleMessageParams params,
  ) =>
      _repo.readSingleMessage(params);
}

@freezed
class PostReadSingleMessageParams with _$PostReadSingleMessageParams {
  const factory PostReadSingleMessageParams({
    @JsonKey(name: "message_id") required String messageId,
    @JsonKey(name: "message_status") required String messageStatus,
  }) = _PostReadSingleMessageParams;

  factory PostReadSingleMessageParams.fromJson(Map<String, dynamic> json) =>
      _$PostReadSingleMessageParamsFromJson(json);
}
