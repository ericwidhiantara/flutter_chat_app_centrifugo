import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/features.dart';

import '../../../../helpers/test_mock.mocks.dart';

void main() {
  late MockUsersRepository mockUsersRepository;
  late ClearUsersUseCase clearUsersUseCase;
  setUp(() async {
    mockUsersRepository = MockUsersRepository();
    clearUsersUseCase = ClearUsersUseCase(mockUsersRepository);
  });

  test("should clear all data user from local database from the repository",
      () async {
    //arrange
    when(mockUsersRepository.clearUsers())
        .thenAnswer((_) async => const Right(null));

    //act
    final result = await clearUsersUseCase.call(null);

    //assert
    result.fold(
      (l) => expect(l, null),
      (r) => expect(null, null),
    );
    verify(mockUsersRepository.clearUsers());
    verifyNoMoreInteractions(mockUsersRepository);
  });

  test("should return Left(CacheFailure) on failure", () async {
    //arrange
    when(mockUsersRepository.clearUsers())
        .thenAnswer((_) async => Left(CacheFailure()));

    //act
    final result = await clearUsersUseCase.call(null);

    //assert
    result.fold(
      (l) => expect(l, CacheFailure()),
      (r) => expect(null, null),
    );
    verify(mockUsersRepository.clearUsers());
    verifyNoMoreInteractions(mockUsersRepository);
  });
}
