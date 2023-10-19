import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/features.dart';

import '../../../../helpers/test_mock.mocks.dart';

void main() {
  late MockUsersRepository mockUsersRepository;
  late GetSavedUsersUseCase getSavedUsersUseCase;
  late List<UserEntity> users;

  setUp(() async {
    users = [
      const UserEntity(
        name: "George Bluth",
        avatar: "https://reqres.in/img/faces/1-image.jpg",
        email: "george.bluth@reqres.in",
      ),
      const UserEntity(
        name: "Janet Weaver",
        avatar: "https://reqres.in/img/faces/2-image.jpg",
        email: "janet.weaver@reqres.in",
      ),
    ];

    mockUsersRepository = MockUsersRepository();
    getSavedUsersUseCase = GetSavedUsersUseCase(mockUsersRepository);
  });

  test("should get saved users in local database from the repository",
      () async {
    //arrange
    when(mockUsersRepository.getSavedUsers())
        .thenAnswer((_) async => Right(users));

    //act
    final result = await getSavedUsersUseCase.call(null);

    //assert
    result.fold(
      (l) => expect(l, null),
      (r) => expect(r, users),
    );
    verify(mockUsersRepository.getSavedUsers());
    verifyNoMoreInteractions(mockUsersRepository);
  });

  test("should return Left(NoDataFailure) on failure", () async {
    //arrange
    when(mockUsersRepository.getSavedUsers())
        .thenAnswer((_) async => Left(NoDataFailure()));

    //act
    final result = await getSavedUsersUseCase.call(null);

    //assert
    result.fold(
      (l) => expect(l, NoDataFailure()),
      (r) => expect(r, null),
    );
    verify(mockUsersRepository.getSavedUsers());
    verifyNoMoreInteractions(mockUsersRepository);
  });
}
