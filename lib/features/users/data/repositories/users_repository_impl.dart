import 'package:dartz/dartz.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/users/users.dart';

class UsersRepositoryImpl implements UsersRepository {
  /// Data Source
  final UsersRemoteDatasource usersRemoteDatasource;
  final UsersLocalDatasource usersLocalDatasource;

  const UsersRepositoryImpl(
    this.usersRemoteDatasource,
    this.usersLocalDatasource,
  );

  @override
  Future<Either<Failure, UserListEntity>> users(UsersParams usersParams) async {
    final response = await usersRemoteDatasource.users(usersParams);

    return response.fold(
      (failure) => Left(failure),
      (usersResponse) {
        if (usersResponse.data?.isEmpty ?? true) {
          return Left(NoDataFailure());
        }
        return Right(usersResponse.toEntity());
      },
    );
  }

  @override
  Future<Either<Failure, List<UserEntity>>> getSavedUsers() async {
    try {
      final data = usersLocalDatasource.getAllData();

      return Right(data);
    } catch (e) {
      return Left(NoDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addUser(UserEntity user) async {
    try {
      return Right(usersLocalDatasource.addData(user));
    } catch (e) {
      return Left(NoDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> removeUser(UserEntity user) async {
    try {
      return Right(usersLocalDatasource.removeData(user));
    } catch (e) {
      return Left(NoDataFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearUsers() async {
    try {
      return Right(usersLocalDatasource.clearUsers());
    } catch (e) {
      return Left(NoDataFailure());
    }
  }
}
