import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

part 'post_read_all_message_usecase.freezed.dart';
part 'post_read_all_message_usecase.g.dart';

class PostReadAllMessageUsecase
    extends UseCase<MetaEntity, PostReadAllMessageParams> {
  final ChatsRepository _repo;

  PostReadAllMessageUsecase(this._repo);

  @override
  Future<Either<Failure, MetaEntity>> call(
    PostReadAllMessageParams params,
  ) =>
      _repo.readAllMessage(params);
}

@freezed
class PostReadAllMessageParams with _$PostReadAllMessageParams {
  const factory PostReadAllMessageParams({
    @JsonKey(name: "room_id") required String roomId,
  }) = _PostReadAllMessageParams;

  factory PostReadAllMessageParams.fromJson(Map<String, dynamic> json) =>
      _$PostReadAllMessageParamsFromJson(json);
}
