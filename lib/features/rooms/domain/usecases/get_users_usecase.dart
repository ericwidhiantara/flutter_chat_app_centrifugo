import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';

part 'get_users_usecase.freezed.dart';
part 'get_users_usecase.g.dart';

class GetUsersUsecase extends UseCase<UsersEntity, GetUsersParams> {
  final RoomsRepository _repo;

  GetUsersUsecase(this._repo);

  @override
  Future<Either<Failure, UsersEntity>> call(GetUsersParams params) =>
      _repo.getUsers(params);
}

@freezed
class GetUsersParams with _$GetUsersParams {
  const factory GetUsersParams({
    @Default(1) int page,
  }) = _GetUsersParams;

  factory GetUsersParams.fromJson(Map<String, dynamic> json) =>
      _$GetUsersParamsFromJson(json);
}
