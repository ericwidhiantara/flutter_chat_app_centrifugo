import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tddboilerplate/dependencies_injection.dart';
import 'package:tddboilerplate/features/features.dart';
import 'package:tddboilerplate/utils/utils.dart';

enum Routes {
  root("/"),
  splashScreen("/splashscreen"),

  /// Home Page
  dashboard("/dashboard"),
  chat("chat"),
  newRoom("new-room"),
  settings("/settings"),

  // Auth Page
  login("/auth/login"),
  register("/auth/register"),
  ;

  const Routes(this.path);

  final String path;
}

class AppRoute {
  static late BuildContext context;

  AppRoute.setStream(BuildContext ctx) {
    context = ctx;
  }

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: Routes.splashScreen.path,
        name: Routes.splashScreen.name,
        builder: (_, __) => SplashScreenPage(),
      ),
      GoRoute(
        path: Routes.root.path,
        name: Routes.root.name,
        redirect: (_, __) => Routes.dashboard.path,
      ),
      GoRoute(
        path: Routes.login.path,
        name: Routes.login.name,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.dashboard.path,
        name: Routes.dashboard.name,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<RoomCubit>()..fetchRoomList(const GetRoomsParams()),
          child: const RoomPage(),
        ),
        routes: [
          GoRoute(
            path: Routes.newRoom.path,
            name: Routes.newRoom.name,
            builder: (_, __) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) =>
                        sl<RoomCubit>()..fetchRoomList(const GetRoomsParams()),
                  ),
                  BlocProvider(
                    create: (context) => sl<CreateRoomCubit>(),
                  ),
                ],
                child: const CreateRoomPage(),
              );
            },
          ),
          GoRoute(
            path: Routes.chat.path,
            name: Routes.chat.name,
            builder: (_, state) {
              final room = state.extra! as RoomDataEntity;
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => sl<ChatCubit>()
                      ..fetchMessages(
                        GetMessagesParams(
                          roomId: room.roomId!,
                        ),
                      ),
                  ),
                  BlocProvider(
                    create: (context) => sl<ChatFormCubit>(),
                  ),
                ],
                child: ChatPage(room: room),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: Routes.register.path,
        name: Routes.register.name,
        builder: (_, __) => BlocProvider(
          create: (_) => sl<RegisterCubit>(),
          child: const RegisterPage(),
        ),
      ),
    ],
    initialLocation: Routes.splashScreen.path,
    routerNeglect: true,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: GoRouterRefreshStream(context.read<AuthCubit>().stream),
    redirect: (_, GoRouterState state) {
      final bool isLoginPage = state.matchedLocation == Routes.login.path ||
          state.matchedLocation == Routes.register.path;

      ///  Check if not login
      ///  if current page is login page we don't need to direct user
      ///  but if not we must direct user to login page
      if (!((MainBoxMixin.mainBox?.get(MainBoxKeys.isLogin.name) as bool?) ??
          false)) {
        return isLoginPage ? null : Routes.login.path;
      }

      /// Check if already login and in login page
      /// we should direct user to main page

      if (isLoginPage &&
          ((MainBoxMixin.mainBox?.get(MainBoxKeys.isLogin.name) as bool?) ??
              false)) {
        return Routes.root.path;
      }

      /// No direct
      return null;
    },
  );
}
