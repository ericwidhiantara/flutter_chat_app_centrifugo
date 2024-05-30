import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/helper/entities/entities.dart';

part 'post_add_participant_usecase.freezed.dart';
part 'post_add_participant_usecase.g.dart';

class PostAddParticipantUsecase
    extends UseCase<MetaEntity, PostAddParticipantParams> {
  final RoomsRepository _repo;

  PostAddParticipantUsecase(this._repo);

  @override
  Future<Either<Failure, MetaEntity>> call(PostAddParticipantParams params) =>
      _repo.addParticipant(params);
}

@freezed
class PostAddParticipantParams with _$PostAddParticipantParams {
  const factory PostAddParticipantParams({
    @JsonKey(name: "user_id") required String userId,
    @JsonKey(name: "room_id") required String roomId,
  }) = _PostAddParticipantParams;

  factory PostAddParticipantParams.fromJson(Map<String, dynamic> json) =>
      _$PostAddParticipantParamsFromJson(json);
}
