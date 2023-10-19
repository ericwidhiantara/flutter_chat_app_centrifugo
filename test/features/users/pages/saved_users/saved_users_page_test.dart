import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

//ignore_for_file: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/dependencies_injection.dart';
import 'package:tdd_boilerplate/features/features.dart';

import '../../../../helpers/fake_path_provider_platform.dart';
import '../../../../helpers/test_mock.mocks.dart';

class MockSavedUsersCubit extends MockCubit<SavedUsersState>
    implements SavedUsersCubit {}

class FakeSavedUserState extends Fake implements SavedUsersState {}

void main() {
  late SavedUsersCubit savedUsersCubit;
  late List<UserEntity> users;

  setUpAll(() {
    HttpOverrides.global = null;
    registerFallbackValue(FakeSavedUserState());
    registerFallbackValue(const UsersParams());
  });

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(isUnitTest: true, prefixBox: 'saved_users_page_test_');
    savedUsersCubit = MockSavedUsersCubit();
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
  });

  Widget rootWidget(Widget body) {
    return BlocProvider<SavedUsersCubit>.value(
      value: savedUsersCubit,
      child: ScreenUtilInit(
        designSize: const Size(375, 667),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) => MaterialApp(
          localizationsDelegates: const [
            Strings.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: const Locale("en"),
          theme: themeLight(MockBuildContext()),
          home: body,
        ),
      ),
    );
  }

  testWidgets(
    'renders SavedUsersPage for UsersStatus.loading',
    (tester) async {
      when(() => savedUsersCubit.state)
          .thenReturn(const SavedUsersState.loading());
      await tester.pumpWidget(rootWidget(const SavedUsersPage()));
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      expect(find.byType(Loading), findsOneWidget);
    },
  );

  testWidgets(
    'renders SavedUsersPage for UsersStatus.empty',
    (tester) async {
      when(() => savedUsersCubit.state)
          .thenReturn(const SavedUsersState.empty());
      await tester.pumpWidget(rootWidget(const SavedUsersPage()));
      await tester.pumpAndSettle(); //if not include this the test will fail

      expect(find.byType(Empty), findsOneWidget);
    },
  );

  testWidgets(
    'renders SavedUsersPage for UsersStatus.failure',
    (tester) async {
      when(() => savedUsersCubit.state)
          .thenReturn(const SavedUsersState.failure(""));
      await tester.pumpWidget(rootWidget(const SavedUsersPage()));
      await tester.pumpAndSettle(); //if not include this the test will fail

      expect(find.byType(Empty), findsOneWidget);
    },
  );

  testWidgets(
    'renders SavedUsersPage for UsersStatus.success',
    (tester) async {
      when(() => savedUsersCubit.state).thenReturn(
        SavedUsersState.success(users, ""),
      );
      await tester.pumpWidget(rootWidget(const SavedUsersPage()));
      await tester.pumpAndSettle(); //if not include this the test will fail

      expect(find.byType(ListView), findsOneWidget);
    },
  );

  testWidgets(
    'trigger refresh when pull to refresh',
    (tester) async {
      when(() => savedUsersCubit.state).thenReturn(
        SavedUsersState.success(users, ""),
      );
      when(() => savedUsersCubit.refreshUsers()).thenAnswer((_) async {});

      await tester.pumpWidget(rootWidget(const SavedUsersPage()));
      await tester.pumpAndSettle(); //if not include this the test will fail

      await tester.fling(
        find.text('George Bluth'),
        const Offset(0.0, 500.0),
        1000.0,
      );

      /// Do loops to waiting refresh indicator showing
      /// instead using tester.pumpAndSettle it's will result time out error
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      verify(() => savedUsersCubit.refreshUsers()).called(1);
    },
  );
}
