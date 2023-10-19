import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/features.dart';

import '../../../../helpers/test_mock.mocks.dart';

void main() {
  late MockUsersRepository mockUsersRepository;
  late RemoveUserUseCase removeUserUseCase;
  late UserEntity userTest;
  setUp(() async {
    userTest = const UserEntity(
      name: "George Bluth",
      avatar: "https://reqres.in/img/faces/1-image.jpg",
      email: "george.bluth@reqres.in",
    );
    mockUsersRepository = MockUsersRepository();
    removeUserUseCase = RemoveUserUseCase(mockUsersRepository);
  });

  test("should remove user from local database from the repository", () async {
    //arrange
    when(mockUsersRepository.removeUser(userTest))
        .thenAnswer((_) async => const Right(null));

    //act
    final result = await removeUserUseCase.call(userTest);

    //assert
    result.fold(
      (l) => expect(l, null),
      (r) => expect(null, null),
    );
    verify(mockUsersRepository.removeUser(userTest));
    verifyNoMoreInteractions(mockUsersRepository);
  });

  test("should return Left(CacheFailure) on failure", () async {
    //arrange
    when(mockUsersRepository.removeUser(userTest))
        .thenAnswer((_) async => Left(CacheFailure()));

    //act
    final result = await removeUserUseCase.call(userTest);

    //assert
    result.fold(
      (l) => expect(l, CacheFailure()),
      (r) => expect(null, null),
    );
    verify(mockUsersRepository.removeUser(userTest));
    verifyNoMoreInteractions(mockUsersRepository);
  });
}
