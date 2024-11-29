import 'package:chart_q/core/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chart_q/core/auth/auth_provider.dart';
import 'package:chart_q/features/auth/presentation/pages/login_page.dart';
import 'package:chart_q/features/main/presentation/screens/home_screens.dart';
import 'package:chart_q/features/main/presentation/screens/study_screen.dart';
import 'package:chart_q/features/main/presentation/screens/quiz_screens.dart';
import 'package:chart_q/features/main/presentation/screens/profile_screens.dart';
import 'package:chart_q/features/main/presentation/screens/study_detail_screen.dart';
import 'package:chart_q/shared/widgets/scaffold_with_nav_bar.dart';
import 'package:flutter/material.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _mainNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoggingIn) {
        logger.d('redirect to login page');
        return '/login';
      }

      if (isLoggedIn && isLoggingIn) {
        logger.d('redirect to main page');
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        navigatorKey: _mainNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            parentNavigatorKey: _mainNavigatorKey,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
            routes: [
              // 홈 화면의 하위 라우트들...
            ],
          ),
          GoRoute(
            path: '/study',
            parentNavigatorKey: _mainNavigatorKey,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: StudyScreen()),
            routes: [
              // 스터디 화면의 하위 라우트들...
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => StudyDetailScreen(
                  studyId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/quiz',
            parentNavigatorKey: _mainNavigatorKey,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: QuizScreen()),
            routes: [
              // 퀴즈 화면의 하위 라우트들...
            ],
          ),
          GoRoute(
            path: '/profile',
            parentNavigatorKey: _mainNavigatorKey,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
            routes: [
              // 프로필 화면의 하위 라우트들...
            ],
          ),
        ],
      ),
    ],
  );
}
