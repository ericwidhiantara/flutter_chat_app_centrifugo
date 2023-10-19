import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

//ignore_for_file: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/dependencies_injection.dart';
import 'package:tdd_boilerplate/features/features.dart';

import '../../../../../helpers/fake_path_provider_platform.dart';
import '../../../../../helpers/test_mock.mocks.dart';

void main() {
  late UsersLocalDatasourceImpl datasource;
  late MockUserBoxMixin mockUserBox;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    mockUserBox = MockUserBoxMixin();
    await serviceLocator(
      isUnitTest: true,
      prefixBox: 'users_local_datasource_test_',
    );
    datasource = UsersLocalDatasourceImpl(mockUserBox);
  });
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

      when(mockUserBox.getAllData()).thenAnswer((_) => testData);

      // Act
      final result = await datasource.getSavedUsers();

      // Assert
      expect(result, Right(testData));
      verify(mockUserBox.getAllData());
      verifyNoMoreInteractions(mockUserBox);
    });

    test('should return a Left(NoDataFailure) on failure', () async {
      // Arrange
      when(mockUserBox.getAllData()).thenThrow(Exception());

      // Act
      final result = await datasource.getSavedUsers();

      // Assert
      expect(result, Left(NoDataFailure()));
      verify(mockUserBox.getAllData());
      verifyNoMoreInteractions(mockUserBox);
    });
  });

  group('addUser', () {
    test('should add a user to the UserBox', () async {
      // Arrange
      when(mockUserBox.addData(testUser))
          .thenAnswer((_) async => const Right<Failure, void>(null));

      // Act
      final result = await datasource.addUser(testUser);

      // Assert
      expect(result, const Right<Failure, void>(null));
      // Verify that the method was called
      verify(datasource.addUser(testUser));
      verifyNoMoreInteractions(mockUserBox);
    });

    test('should return a Left(CacheFailure) on failure', () async {
      when(mockUserBox.addData(testUser)).thenThrow(Exception());

      // Act
      final result = await datasource.addUser(testUser);

      // Assert
      expect(result, const Left(CacheFailure("")));
      verify(mockUserBox.addData(testUser));
      verifyNoMoreInteractions(mockUserBox);
    });
  });

  group('removeUser', () {
    test('should remove a user from the UserBox', () async {
      // Act
      final result = await datasource.removeUser(testUser);

      // Assert
      verify(mockUserBox.removeData(testUser));
      expect(result, const Right(null));
      verifyNoMoreInteractions(mockUserBox);
    });

    test('should return a Left(CacheFailure) on failure', () async {
      when(mockUserBox.removeData(testUser)).thenThrow(Exception());

      // Act
      final result = await datasource.removeUser(testUser);

      // Assert
      expect(result, const Left(CacheFailure("")));
      verify(mockUserBox.removeData(testUser));
      verifyNoMoreInteractions(mockUserBox);
    });
  });

  group('clearUsers', () {
    test('should clear all users from the UserBox', () async {
      // Act
      final result = await datasource.clearUsers();

      // Assert
      expect(result, const Right(null));
      verify(mockUserBox.clearData());
      verifyNoMoreInteractions(mockUserBox);
    });

    test('should return a Left(CacheFailure) on failure', () async {
      // Arrange
      when(mockUserBox.clearData()).thenThrow(Exception());

      // Act
      final result = await datasource.clearUsers();

      // Assert
      expect(result, const Left(CacheFailure("")));
      verify(mockUserBox.clearData());
      verifyNoMoreInteractions(mockUserBox);
    });
  });
}
