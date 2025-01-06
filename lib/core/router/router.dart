import 'package:chart_q/core/utils/logger.dart';
import 'package:chart_q/features/auth/presentation/pages/welcome_page.dart';
import 'package:chart_q/features/main/presentation/screens/delete_account_screen.dart';
import 'package:chart_q/features/main/presentation/screens/profile_edit_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chart_q/core/auth/auth_provider.dart';
import 'package:chart_q/features/auth/presentation/pages/login_page.dart';
import 'package:chart_q/features/main/presentation/screens/home_screen.dart';
import 'package:chart_q/features/main/presentation/screens/study_screen.dart';
import 'package:chart_q/features/main/presentation/screens/quiz_screen.dart';
import 'package:chart_q/features/main/presentation/screens/profile_screen.dart';
import 'package:chart_q/features/main/presentation/screens/study_detail_screen.dart';
import 'package:chart_q/shared/widgets/scaffold_with_nav_bar.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _mainNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'main');

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final user = ref.read(authProvider.notifier).user;

      final isGoingToLogin = state.matchedLocation == AppRoutes.login;
      final isGoingToWelcome = state.matchedLocation == AppRoutes.welcome;
      final isWelcomeDone = user?.userMetadata?['chartq_is_welcomed'] == true;

      if (isGoingToLogin) {
        if (user != null) {
          return isWelcomeDone ? AppRoutes.home : AppRoutes.welcome;
        }
      } else if (user == null) {
        return AppRoutes.login;
      }

      if (isGoingToWelcome && isWelcomeDone) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomePage(),
      ),
      ShellRoute(
        navigatorKey: _mainNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(child: ScaffoldWithNavBar(child: child));
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
            routes: [
              // 홈 화면의 하위 라우트들...
            ],
          ),
          GoRoute(
            path: AppRoutes.study,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: StudyScreen()),
            routes: [
              // 스터디 화면의 하위 라우트들...
              _ChildRoute(
                path: ':id',
                builder: (context, state) => StudyDetailScreen(
                  studyId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.quiz,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: QuizScreen()),
            routes: [
              // 퀴즈 화면의 하위 라우트들...
            ],
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ProfileScreen()),
            routes: [
              // 프로필 화면의 하위 라우트들...
              _ChildRoute(
                path: 'edit',
                builder: (context, state) => ProfileEditScreen(),
              ),
              _ChildRoute(
                path: 'delete',
                builder: (context, state) => DeleteAccountScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _ChildRoute extends GoRoute {
  _ChildRoute({
    required super.path,
    required Widget Function(BuildContext context, GoRouterState state) builder,
  }) : super(
          parentNavigatorKey: _rootNavigatorKey,
          pageBuilder: (context, state) => CustomTransitionPage(
            child: builder(context, state),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 200),
          ),
        );
}
