import 'package:get_it/get_it.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/features/features.dart';
import 'package:tdd_boilerplate/utils/utils.dart';

GetIt sl = GetIt.instance;

Future<void> serviceLocator({
  bool isUnitTest = false,
  bool isHiveEnable = true,
  String prefixBox = '',
}) async {
  /// For unit testing only
  if (isUnitTest) {
    await sl.reset();
  }
  sl.registerSingleton<DioClient>(DioClient(isUnitTest: isUnitTest));
  _dataSources();
  _repositories();
  _useCase();
  _cubit();
  if (isHiveEnable) {
    await _initHiveBoxes(
      isUnitTest: isUnitTest,
      prefixBox: prefixBox,
    );
  }
}

Future<void> _initHiveBoxes({
  bool isUnitTest = false,
  String prefixBox = '',
}) async {
  await MainBoxMixin.initHive(prefixBox);
  sl.registerSingleton<MainBoxMixin>(MainBoxMixin());

  await UserBoxMixin.initHive("saved_users_");
  sl.registerSingleton<UserBoxMixin>(UserBoxMixin());
}

/// Register repositories
void _repositories() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<UsersRepository>(
    () => UsersRepositoryImpl(
      sl(),
      sl(),
    ),
  );
}

/// Register dataSources
void _dataSources() {
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<UsersRemoteDatasource>(
    () => UsersRemoteDatasourceImpl(sl()),
  );
  sl.registerLazySingleton<UsersLocalDatasource>(
    () => UsersLocalDatasourceImpl(sl()),
  );
}

void _useCase() {
  /// Auth
  sl.registerLazySingleton(() => PostLogin(sl()));
  sl.registerLazySingleton(() => PostRegister(sl()));

  /// Users
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => GetSavedUsersUseCase(sl()));
  sl.registerLazySingleton(() => AddUserUseCase(sl()));
  sl.registerLazySingleton(() => RemoveUserUseCase(sl()));
  sl.registerLazySingleton(() => ClearUsersUseCase(sl()));
}

void _cubit() {
  /// Auth
  sl.registerFactory(() => RegisterCubit(sl()));
  sl.registerFactory(() => AuthCubit(sl()));

  /// Users
  sl.registerFactory(() => UsersCubit(sl()));
  sl.registerFactory(() => SettingsCubit());
  sl.registerFactory(() => MainCubit());
}
