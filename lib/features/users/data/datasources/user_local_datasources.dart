import 'package:dartz/dartz.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/features.dart';

abstract class UsersLocalDatasource extends UserBoxMixin {
  Future<Either<Failure, List<UserEntity>>> getSavedUsers();

  Future<void> addUser(UserEntity user);

  Future<void> removeUser(UserEntity user);

  Future<void> clearUsers();
}

class UsersLocalDatasourceImpl extends UsersLocalDatasource {
  final UserBoxMixin _box;

  UsersLocalDatasourceImpl(this._box);

  @override
  Future<Either<Failure, List<UserEntity>>> getSavedUsers() async {
    try {
      final data = _box.getAllData();
      return Right(data);
    } catch (e) {
      return Left(NoDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addUser(UserEntity user) async {
    try {
      return Right(_box.addData(user));
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeUser(UserEntity user) async {
    try {
      return Right(_box.removeData(user));
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearUsers() async {
    try {
      return Right(_box.clearData());
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
