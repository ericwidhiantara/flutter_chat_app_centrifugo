import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';

part 'get_messages_usecase.freezed.dart';
part 'get_messages_usecase.g.dart';

class GetMessagesUsecase extends UseCase<MessagesEntity, GetMessagesParams> {
  final ChatsRepository _repo;

  GetMessagesUsecase(this._repo);

  @override
  Future<Either<Failure, MessagesEntity>> call(GetMessagesParams params) =>
      _repo.getMessages(params);
}

@freezed
class GetMessagesParams with _$GetMessagesParams {
  const factory GetMessagesParams({
    @Default(1) int page,
    @Default("") String roomId,
  }) = _GetMessagesParams;

  factory GetMessagesParams.fromJson(Map<String, dynamic> json) =>
      _$GetMessagesParamsFromJson(json);
}
