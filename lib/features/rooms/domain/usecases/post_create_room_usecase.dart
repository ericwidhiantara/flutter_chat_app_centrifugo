import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';

part 'post_create_room_usecase.freezed.dart';
part 'post_create_room_usecase.g.dart';

class PostCreateRoomUsecase
    extends UseCase<CreateRoomEntity, PostCreateRoomParams> {
  final RoomsRepository _repo;

  PostCreateRoomUsecase(this._repo);

  @override
  Future<Either<Failure, CreateRoomEntity>> call(PostCreateRoomParams params) =>
      _repo.createRoom(params);
}

@freezed
class PostCreateRoomParams with _$PostCreateRoomParams {
  const factory PostCreateRoomParams({
    @JsonKey(name: "name") required String name,
  }) = _PostCreateRoomParams;

  factory PostCreateRoomParams.fromJson(Map<String, dynamic> json) =>
      _$PostCreateRoomParamsFromJson(json);
}
