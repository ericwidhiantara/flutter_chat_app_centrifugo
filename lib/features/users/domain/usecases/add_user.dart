import 'package:dartz/dartz.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/features.dart';

class AddUserUseCase implements UseCase<void, UserEntity> {
  final UsersRepository _usersRepository;

  AddUserUseCase(this._usersRepository);

  @override
  Future<Either<Failure, void>> call(UserEntity params) {
    return _usersRepository.addUser(params);
  }
}
