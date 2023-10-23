import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

//ignore_for_file: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/dependencies_injection.dart';
import 'package:tddboilerplate/features/features.dart';

import '../../../../helpers/fake_path_provider_platform.dart';
import '../../../../helpers/json_reader.dart';
import '../../../../helpers/paths.dart';
import '../../../../helpers/test_mock.mocks.dart';

void main() {
  late MockUsersRemoteDatasource mockUsersRemoteDatasource;
  late MockUsersLocalDatasource mockUsersLocalDatasource;
  late UsersRepositoryImpl authRepositoryImpl;
  late UserListEntity users;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(
      isUnitTest: true,
      prefixBox: 'users_repository_impl_test_',
    );
    mockUsersRemoteDatasource = MockUsersRemoteDatasource();
    mockUsersLocalDatasource = MockUsersLocalDatasource();
    authRepositoryImpl = UsersRepositoryImpl(
      mockUsersRemoteDatasource,
      mockUsersLocalDatasource,
    );
    users = UsersResponse.fromJson(
      json.decode(jsonReader(successUserPath)) as Map<String, dynamic>,
    ).toEntity();
  });

  group("user", () {
    const userParams = UsersParams();
    const userParamsEmpty = UsersParams(page: 3);

    test('should return list user when call data is successful', () async {
      // arrange
      when(mockUsersRemoteDatasource.users(userParams)).thenAnswer(
        (_) async => Right(
          UsersResponse.fromJson(
            json.decode(jsonReader(successUserPath)) as Map<String, dynamic>,
          ),
        ),
      );

      // act
      final result = await authRepositoryImpl.users(userParams);

      // assert
      verify(mockUsersRemoteDatasource.users(userParams));
      expect(result, equals(Right(users)));
    });

    test(
      'should return empty list user when call data is successful',
      () async {
        // arrange
        when(mockUsersRemoteDatasource.users(userParamsEmpty)).thenAnswer(
          (_) async => Left(NoDataFailure()),
        );

        // act
        final result = await authRepositoryImpl.users(userParamsEmpty);

        // assert
        verify(mockUsersRemoteDatasource.users(userParamsEmpty));
        expect(result, equals(Left(NoDataFailure())));
      },
    );

    test(
      'should return server failure when call data is unsuccessful',
      () async {
        // arrange
        when(mockUsersRemoteDatasource.users(userParams))
            .thenAnswer((_) async => const Left(ServerFailure('')));

        // act
        final result = await authRepositoryImpl.users(userParams);

        // assert
        verify(mockUsersRemoteDatasource.users(userParams));
        expect(result, equals(const Left(ServerFailure(''))));
      },
    );
  });

  group("local users", () {
    const testUser = UserEntity(
      name: "George Bluth",
      avatar: "https://reqres.in/img/faces/1-image.jpg",
      email: "george.bluth@reqres.in",
    );
    group('getSavedUsers', () {
      test('should return a list of UserEntity from the UserBox', () async {
        // Arrange
        final testData = [
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

        when(mockUsersLocalDatasource.getAllData()).thenAnswer((_) => testData);

        // Act
        final result = await authRepositoryImpl.getSavedUsers();

        // Assert
        expect(result, Right(testData));
        verify(mockUsersLocalDatasource.getAllData());
        verifyNoMoreInteractions(mockUsersLocalDatasource);
      });

      test('should return a Left(NoDataFailure) on failure', () async {
        // Arrange
        when(mockUsersLocalDatasource.getSavedUsers()).thenAnswer(
          (_) async => Left(NoDataFailure()),
        );

        // Act
        final result =
            await mockUsersLocalDatasource.getSavedUsers(); // Await the Future

        // Assert
        expect(result, Left(NoDataFailure()));
        verify(mockUsersLocalDatasource.getSavedUsers());
        verifyNoMoreInteractions(mockUsersLocalDatasource);
      });
    });

    group('addUser', () {
      test('should add a user to the UserBox', () async {
        // Arrange
        when(mockUsersLocalDatasource.addData(testUser))
            .thenAnswer((_) async => const Right<Failure, void>(null));

        // Act
        await mockUsersLocalDatasource.addUser(testUser);

        // Assert
        // Verify that the method was called
        verify(mockUsersLocalDatasource.addUser(testUser));
        verifyNoMoreInteractions(mockUsersLocalDatasource);
      });

      test('should return a Left(CacheFailure) on failure', () async {
        when(mockUsersLocalDatasource.addUser(testUser))
            .thenAnswer((_) async => Left(CacheFailure()));

        // Act
        await mockUsersLocalDatasource.addUser(testUser);

        // Assert
        verify(mockUsersLocalDatasource.addUser(testUser));
        verifyNoMoreInteractions(mockUsersLocalDatasource);
      });
    });

    group('removeUser', () {
      test('should remove a user from the UserBox', () async {
        // Act
        await mockUsersLocalDatasource.removeUser(testUser);

        // Assert
        verify(mockUsersLocalDatasource.removeUser(testUser));
        verifyNoMoreInteractions(mockUsersLocalDatasource);
      });

      test('should return a Left(CacheFailure) on failure', () async {
        when(mockUsersLocalDatasource.removeUser(testUser))
            .thenAnswer((_) async => Left(CacheFailure()));

        // Act
        await mockUsersLocalDatasource.removeUser(testUser);

        // Assert
        verify(mockUsersLocalDatasource.removeUser(testUser));
        verifyNoMoreInteractions(mockUsersLocalDatasource);
      });
    });

    group('clearUsers', () {
      test('should clear all users from the UserBox', () async {
        // Act
        await mockUsersLocalDatasource.clearUsers();

        // Assert
        verify(mockUsersLocalDatasource.clearUsers());
        verifyNoMoreInteractions(mockUsersLocalDatasource);
      });

      test('should return a Left(CacheFailure) on failure', () async {
        // Arrange
        when(mockUsersLocalDatasource.clearUsers())
            .thenAnswer((_) async => Left(CacheFailure()));

        // Act
        await mockUsersLocalDatasource.clearUsers();

        // Assert
        verify(mockUsersLocalDatasource.clearUsers());
        verifyNoMoreInteractions(mockUsersLocalDatasource);
      });
    });
  });
}
