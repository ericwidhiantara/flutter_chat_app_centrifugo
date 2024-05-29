import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';

part 'get_rooms_usecase.freezed.dart';
part 'get_rooms_usecase.g.dart';

class GetRoomsUsecase extends UseCase<RoomsEntity, GetRoomsParams> {
  final RoomsRepository _repo;

  GetRoomsUsecase(this._repo);

  @override
  Future<Either<Failure, RoomsEntity>> call(GetRoomsParams params) =>
      _repo.getRooms(params);
}

@freezed
class GetRoomsParams with _$GetRoomsParams {
  const factory GetRoomsParams({
    @Default(1) int page,
  }) = _GetRoomsParams;

  factory GetRoomsParams.fromJson(Map<String, dynamic> json) =>
      _$GetRoomsParamsFromJson(json);
}
