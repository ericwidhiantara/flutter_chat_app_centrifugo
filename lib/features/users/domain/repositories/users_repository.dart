import 'package:dartz/dartz.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/users/users.dart';

abstract class UsersRepository {
  Future<Either<Failure, UserListEntity>> users(UsersParams usersParams);

  //Local Database Methods
  Future<Either<Failure, List<UserEntity>>> getSavedUsers();

  Future<Either<Failure, void>> addUser(UserEntity article);

  Future<Either<Failure, void>> removeUser(UserEntity article);

  Future<Either<Failure, void>> clearUsers();
}
