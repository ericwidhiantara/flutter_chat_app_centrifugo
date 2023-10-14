import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/users/users.dart';

part 'get_users.freezed.dart';

part 'get_users.g.dart';

class GetUsers extends UseCase<UserListEntity, UsersParams> {
  final UsersRepository _repo;

  GetUsers(this._repo);

  @override
  Future<Either<Failure, UserListEntity>> call(UsersParams params) =>
      _repo.users(params);
}

@freezed
class UsersParams with _$UsersParams {
  const factory UsersParams({@Default(1) int page}) = _UsersParams;

  factory UsersParams.fromJson(Map<String, dynamic> json) =>
      _$UsersParamsFromJson(json);
}
