
import 'package:bot_toast/bot_toast.dart';
import 'package:lu_assist/src/features/auth/presentation/auth_screen/view/splash_screen.dart';
import 'package:lu_assist/src/features/auth/presentation/forget_password/view/forgot_password_screen.dart';
import 'package:lu_assist/src/features/auth/presentation/login/view/login_screen.dart';
import 'package:lu_assist/src/features/auth/presentation/signup/view/signup_screen.dart';
import 'package:lu_assist/src/features/home/presentation/view/home_screen.dart';
import 'package:lu_assist/src/features/profile/presentation/view/profile_screen.dart';
import 'package:lu_assist/src/shared/view/bottom_nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider(
  (ref) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation:HomeScreen.route,
      observers: [BotToastNavigatorObserver()],
      routes: [
        GoRoute(
          path: SplashScreen.route,
          builder: (context, state) {
            return const SplashScreen();
          },
        ),
        GoRoute(
          path: LoginScreen.route,
          builder: (context, state) {
            return LoginScreen();
          },
        ),
        GoRoute(
          path: SignupScreen.route,
          builder: (context, state) {
            return SignupScreen();
          },
        ),
        GoRoute(
          path: ForgotPasswordScreen.route,
          builder: (context, state) {
            return ForgotPasswordScreen();
          },
        ),
        StatefulShellRoute.indexedStack(
            branches: [
              StatefulShellBranch(
                  initialLocation: HomeScreen.setRoute(),
                  routes: [
                    GoRoute(
                        path: HomeScreen.route,
                        builder: (context, state) {
                          return HomeScreen();
                        }),
                  ]),
              StatefulShellBranch(
                  initialLocation: ProfileScreen.setRoute(),
                  routes: [
                    GoRoute(
                        path: ProfileScreen.route,
                        builder: (context, state) {
                          return ProfileScreen();
                        }),
                  ])
            ],
            builder: (context, state, navigationShell) {
              return BottomNavScreen(navigationShell: navigationShell);
            })
      ],
    );
  },
);
