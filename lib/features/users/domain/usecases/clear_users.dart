import 'package:dartz/dartz.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/features.dart';

class ClearUserUseCase implements UseCase<void, void> {
  final UsersRepository _usersRepository;

  ClearUserUseCase(this._usersRepository);

  @override
  Future<Either<Failure, void>> call(void params) {
    return _usersRepository.clearUsers();
  }
}
