import 'package:dartz/dartz.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/features.dart';

class ClearUsersUseCase implements UseCase<void, void> {
  final UsersRepository _usersRepository;

  ClearUsersUseCase(this._usersRepository);

  @override
  Future<Either<Failure, void>> call(void params) {
    return _usersRepository.clearUsers();
  }
}
