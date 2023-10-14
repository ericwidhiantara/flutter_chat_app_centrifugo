import 'package:dartz/dartz.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/features.dart';

class RemoveUserUseCase implements UseCase<void, UserEntity> {
  final UsersRepository _usersRepository;

  RemoveUserUseCase(this._usersRepository);

  @override
  Future<Either<Failure, void>> call(UserEntity params) {
    return _usersRepository.removeUser(params);
  }
}
