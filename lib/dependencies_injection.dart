import 'package:get_it/get_it.dart';
import 'package:tddboilerplate/core/core.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

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
}

/// Register repositories
void _repositories() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );

  sl.registerLazySingleton<ChatsRepository>(
    () => ChatsRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<RoomsRepository>(
    () => RoomsRepositoryImpl(sl()),
  );
}

/// Register dataSources
void _dataSources() {
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<ChatsRemoteDatasource>(
    () => ChatsRemoteDatasourceImpl(sl()),
  );

  sl.registerLazySingleton<RoomsRemoteDatasource>(
    () => RoomsRemoteDatasourceImpl(sl()),
  );
}

void _useCase() {
  /// Auth
  sl.registerLazySingleton(() => PostLogin(sl()));
  sl.registerLazySingleton(() => PostRegister(sl()));

  /// Rooms
  sl.registerLazySingleton(() => GetRoomsUsecase(sl()));
  sl.registerLazySingleton(() => PostCreateRoomUsecase(sl()));
  sl.registerLazySingleton(() => GetUsersUsecase(sl()));
  sl.registerLazySingleton(() => PostAddParticipantUsecase(sl()));

  /// Chats
  sl.registerLazySingleton(() => GetMessagesUsecase(sl()));
  sl.registerLazySingleton(() => PostSendMessageUsecase(sl()));
  sl.registerLazySingleton(() => PostReadSingleMessageUsecase(sl()));
  sl.registerLazySingleton(() => PostReadAllMessageUsecase(sl()));
}

void _cubit() {
  /// Auth
  sl.registerFactory(() => RegisterCubit(sl()));
  sl.registerFactory(() => AuthCubit(sl()));

  sl.registerFactory(() => SettingsCubit());
  sl.registerFactory(() => MainCubit());

  /// Rooms
  sl.registerFactory(() => RoomCubit(sl()));
  sl.registerFactory(() => CreateRoomCubit(sl()));
  sl.registerFactory(() => ParticipantCubit(sl()));
  sl.registerFactory(() => ParticipantDataCubit());
  sl.registerFactory(() => AddParticipantCubit(sl()));

  /// Chats
  sl.registerFactory(() => ChatCubit(sl()));
  sl.registerFactory(() => ChatFormCubit(sl(), sl(), sl()));
}
