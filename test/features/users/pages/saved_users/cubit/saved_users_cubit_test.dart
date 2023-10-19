import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

//ignore_for_file: depend_on_referenced_packages
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/dependencies_injection.dart';
import 'package:tdd_boilerplate/features/features.dart';

import '../../../../../helpers/fake_path_provider_platform.dart';
import 'saved_users_cubit_test.mocks.dart';

@GenerateMocks([
  GetSavedUsersUseCase,
  AddUserUseCase,
  RemoveUserUseCase,
  ClearUsersUseCase,
])
void main() {
  late SavedUsersCubit savedUsersCubit;
  late MockGetSavedUsersUseCase mockGetSavedUsersUseCase;
  late MockAddUserUseCase mockAddUserUseCase;
  late MockRemoveUserUseCase mockRemoveUserUseCase;
  late MockClearUsersUseCase mockClearUsersUseCase;
  late List<UserEntity> users;

  const errorMessage = "";

  /// Initialize data
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(isUnitTest: true, prefixBox: 'users_cubit_test_');

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

    mockGetSavedUsersUseCase = MockGetSavedUsersUseCase();
    mockAddUserUseCase = MockAddUserUseCase();
    mockRemoveUserUseCase = MockRemoveUserUseCase();
    mockClearUsersUseCase = MockClearUsersUseCase();
    savedUsersCubit = SavedUsersCubit(
      mockGetSavedUsersUseCase,
      mockAddUserUseCase,
      mockRemoveUserUseCase,
      mockClearUsersUseCase,
    );
  });

  /// Dispose bloc
  tearDown(() {
    savedUsersCubit.close();
  });

  group("get saved users", () {
    ///  Initial data should be loading
    test("Initial data should be UsersStatus.loading", () {
      expect(savedUsersCubit.state, const SavedUsersState.loading());
    });

    blocTest<SavedUsersCubit, SavedUsersState>(
      "should return SavedUsersState.loading at first and then return SavedUsersState.success when success get data from local db",
      build: () {
        when(mockGetSavedUsersUseCase.call(null))
            .thenAnswer((_) async => Right(users));

        return savedUsersCubit;
      },
      act: (SavedUsersCubit savedUsersCubit) => savedUsersCubit.fetchUsers(),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const SavedUsersState.loading(),
        SavedUsersState.success(users, ""),
      ],
    );

    blocTest<SavedUsersCubit, SavedUsersState>(
      "Should return SavedUsersState.failure(CacheFailure) when failure get data from local db",
      build: () {
        when(
          mockGetSavedUsersUseCase.call(null),
        ).thenAnswer((_) async => const Left(CacheFailure("")));

        return savedUsersCubit;
      },
      act: (SavedUsersCubit savedUsersCubit) => savedUsersCubit.fetchUsers(),
      wait: const Duration(milliseconds: 100),
      expect: () => const [
        SavedUsersState.loading(),
        SavedUsersState.failure(errorMessage),
      ],
    );

    blocTest<SavedUsersCubit, SavedUsersState>(
      "When no data from server",
      build: () {
        when(mockGetSavedUsersUseCase.call(null))
            .thenAnswer((_) async => Left(NoDataFailure()));

        return savedUsersCubit;
      },
      act: (SavedUsersCubit savedUsersCubit) => savedUsersCubit.fetchUsers(),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const SavedUsersState.loading(),
        const SavedUsersState.empty(),
      ],
    );

    blocTest<SavedUsersCubit, SavedUsersState>(
      "When request refreshUsers",
      build: () {
        when(mockGetSavedUsersUseCase.call(null))
            .thenAnswer((_) async => Right(users));

        return savedUsersCubit;
      },
      act: (SavedUsersCubit savedUsersCubit) => savedUsersCubit.refreshUsers(),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        const SavedUsersState.loading(),
        SavedUsersState.success(users, ""),
      ],
    );
  });
}
