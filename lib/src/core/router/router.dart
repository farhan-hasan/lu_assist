
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lu_assist/src/features/auth/presentation/auth_screen/view/splash_screen.dart';
import 'package:lu_assist/src/features/auth/presentation/login/view/login_screen.dart';
import 'package:lu_assist/src/features/auth/presentation/signup/view/signup_screen.dart';
import 'package:lu_assist/src/features/bus_request/presentation/view/request_screen.dart';
import 'package:lu_assist/src/features/bus_schedule/presentation/view/create_schedule_screen.dart';
import 'package:lu_assist/src/features/bus_schedule/presentation/view/edit_schedule_screen.dart';
import 'package:lu_assist/src/features/bus_schedule/presentation/view/schedule_screen.dart';
import 'package:lu_assist/src/features/bus_track/presentation/view/track_screen.dart';
import 'package:lu_assist/src/features/news_feed/presentation/view/news_feed_screen.dart';
import 'package:lu_assist/src/features/profile/presentation/view/profile_screen.dart';
import 'package:lu_assist/src/shared/view/bottom_nav_screen.dart';

import '../../features/bus_request/presentation/view/create_request_schedule_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../shared/data/model/bus_model.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider(
  (ref) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
       initialLocation: OnBoardingScreen.route,
      observers: [BotToastNavigatorObserver()],
      routes: [
        GoRoute(
          path: OnBoardingScreen.route,
          builder: (context, state) {
            return OnBoardingScreen();
          },
        ),

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
          path: CreateScheduleScreen.route,
          builder: (context, state) {
            final Function(bool isSuccess) onCreate = state.extra as Function(bool isSuccess);
            return CreateScheduleScreen(
              onCreate: onCreate,
            );
          },
        ),

        GoRoute(
          path: CreateRequestScheduleScreen.route,
          builder: (context, state) {
            final Function(bool isSuccess) onCreate = state.extra as Function(bool isSuccess);
            return CreateRequestScheduleScreen(
              onCreate: onCreate,
            );
          },
        ),

        GoRoute(
          path: EditScheduleScreen.route,
          builder: (context, state) {
            Map<String,dynamic> data = state.extra as Map<String,dynamic>;
            final Function(bool isSuccess) onEdit = data["onEdit"];
            final BusModel bus = data["bus"];
            return EditScheduleScreen(
              bus: bus,
              onEdit: onEdit,
            );
          },
        ),
        StatefulShellRoute.indexedStack(
            branches: [
              StatefulShellBranch(
                 initialLocation: NewsFeedScreen.setRoute(),
                  routes: [
                    GoRoute(
                        path: NewsFeedScreen.route,
                        builder: (context, state) {
                          return NewsFeedScreen();
                        }),
                  ]),
              StatefulShellBranch(
                  initialLocation: ScheduleScreen.setRoute(),
                  routes: [
                    GoRoute(
                        path: ScheduleScreen.route,
                        builder: (context, state) {
                          return ScheduleScreen();
                        }),
                  ]),
              StatefulShellBranch(
                  initialLocation: RequestScreen.setRoute(),
                  routes: [
                    GoRoute(

                       path: RequestScreen.route,
                        builder: (context, state) {
                          return RequestScreen();

                        }),
                  ]),
              StatefulShellBranch(
                  initialLocation: TrackScreen.setRoute(),
                  routes: [
                    GoRoute(
                        path: TrackScreen.route,
                        builder: (context, state) {
                          return TrackScreen();
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
