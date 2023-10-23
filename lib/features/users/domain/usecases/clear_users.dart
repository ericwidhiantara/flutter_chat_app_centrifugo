import 'package:dartz/dartz.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';

class ClearUsersUseCase implements UseCase<void, void> {
  final UsersRepository _usersRepository;

  ClearUsersUseCase(this._usersRepository);

  @override
  Future<Either<Failure, void>> call(void params) {
    return _usersRepository.clearUsers();
  }
}
