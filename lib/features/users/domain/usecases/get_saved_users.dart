import 'package:dartz/dartz.dart';
import 'package:tdd_boilerplate/core/error/failure.dart';
import 'package:tdd_boilerplate/core/usecase/usecase.dart';
import 'package:tdd_boilerplate/features/features.dart';

class GetSavedUsers implements UseCase<List<UserEntity>, void> {
  final UsersRepository _usersRepository;

  GetSavedUsers(this._usersRepository);

  @override
  Future<Either<Failure, List<UserEntity>>> call(void params) {
    return _usersRepository.getSavedUsers();
  }
}
