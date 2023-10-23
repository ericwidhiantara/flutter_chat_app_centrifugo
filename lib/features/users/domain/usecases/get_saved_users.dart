import 'package:dartz/dartz.dart';
import 'package:tddboilerplate/core/error/failure.dart';
import 'package:tddboilerplate/core/usecase/usecase.dart';
import 'package:tddboilerplate/features/features.dart';

class GetSavedUsersUseCase implements UseCase<List<UserEntity>, void> {
  final UsersRepository _usersRepository;

  GetSavedUsersUseCase(this._usersRepository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(void params) {
    return _usersRepository.getSavedUsers();
  }
}
