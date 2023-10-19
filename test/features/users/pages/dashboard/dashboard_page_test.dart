import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

//ignore_for_file: depend_on_referenced_packages
import 'package:mocktail/mocktail.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:tdd_boilerplate/core/core.dart';
import 'package:tdd_boilerplate/dependencies_injection.dart';
import 'package:tdd_boilerplate/features/features.dart';

import '../../../../helpers/fake_path_provider_platform.dart';
import '../../../../helpers/json_reader.dart';
import '../../../../helpers/paths.dart';
import '../../../../helpers/test_mock.mocks.dart';

class MockUsersCubit extends MockCubit<UsersState> implements UsersCubit {}

class FakeUserState extends Fake implements UsersState {}

void main() {
  late UsersCubit usersCubit;
  late UserListEntity users;

  setUpAll(() {
    HttpOverrides.global = null;
    registerFallbackValue(FakeUserState());
    registerFallbackValue(const UsersParams());
  });

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    PathProviderPlatform.instance = FakePathProvider();
    await serviceLocator(isUnitTest: true, prefixBox: 'dashboard_page_test_');
    usersCubit = MockUsersCubit();
    users = UsersResponse.fromJson(
      json.decode(jsonReader(successUserPath)) as Map<String, dynamic>,
    ).toEntity();
  });

  Widget rootWidget(Widget body) {
    return BlocProvider<UsersCubit>.value(
      value: usersCubit,
      child: OKToast(
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
      ),
    );
  }

  testWidgets(
    'renders DashboardPage for UsersStatus.loading',
    (tester) async {
      when(() => usersCubit.state).thenReturn(const UsersState.loading());
      await tester.pumpWidget(rootWidget(const DashboardPage()));
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      expect(find.byType(Loading), findsOneWidget);
    },
  );

  testWidgets(
    'renders DashboardPage for UsersStatus.empty',
    (tester) async {
      when(() => usersCubit.state).thenReturn(const UsersState.empty());
      await tester.pumpWidget(rootWidget(const DashboardPage()));
      await tester.pumpAndSettle(); //if not include this the test will fail

      expect(find.byType(Empty), findsOneWidget);
    },
  );

  testWidgets(
    'renders DashboardPage for UsersStatus.failure',
    (tester) async {
      when(() => usersCubit.state).thenReturn(const UsersState.failure(""));
      await tester.pumpWidget(rootWidget(const DashboardPage()));
      await tester.pumpAndSettle(); //if not include this the test will fail

      expect(find.byType(Empty), findsOneWidget);
    },
  );

  testWidgets(
    'renders DashboardPage for UsersStatus.success',
    (tester) async {
      when(() => usersCubit.state).thenReturn(
        UsersState.success(users),
      );
      await tester.pumpWidget(rootWidget(const DashboardPage()));
      await tester.pumpAndSettle(); //if not include this the test will fail

      expect(find.byType(ListView), findsOneWidget);
    },
  );

  testWidgets(
    'trigger refresh when pull to refresh',
    (tester) async {
      when(() => usersCubit.state).thenReturn(
        UsersState.success(users),
      );
      when(() => usersCubit.refreshUsers(any())).thenAnswer((_) async {});

      await tester.pumpWidget(rootWidget(const DashboardPage()));
      await tester.pumpAndSettle(); //if not include this the test will fail

      await tester.fling(
        find.text('Michael Lawson'),
        const Offset(0.0, 500.0),
        1000.0,
      );

      /// Do loops to waiting refresh indicator showing
      /// instead using tester.pumpAndSettle it's will result time out error
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      verify(() => usersCubit.refreshUsers(any())).called(1);
    },
  );

  testWidgets(
    'save user to local db by tapping favorite button',
    (tester) async {
      when(() => usersCubit.state).thenReturn(
        UsersState.success(users),
      );
      await tester.pumpWidget(rootWidget(const DashboardPage()));
      await tester.pumpAndSettle(); //if not include this the test will fail

      // Find the widget by its key.
      final buttonFinder = find.byKey(const Key('favButton_0'));

      // Verify that the button exists in the widget tree.
      expect(buttonFinder, findsOneWidget);

      // Simulate a tap on the button.
      await tester.tap(buttonFinder);

      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 3));
      }
    },
  );
}
