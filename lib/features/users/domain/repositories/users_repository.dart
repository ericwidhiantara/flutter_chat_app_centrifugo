import 'package:dartz/dartz.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/users/users.dart';

abstract class UsersRepository {
  Future<Either<Failure, UserListEntity>> users(UsersParams usersParams);
}
