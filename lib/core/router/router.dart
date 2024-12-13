import 'package:chart_q/core/utils/logger.dart';
import 'package:chart_q/features/auth/presentation/pages/welcome_page.dart';
import 'package:chart_q/features/main/presentation/screens/profile_edit_screen.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart';

part 'router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _mainNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'main');

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    redirect: (context, state) {
      final authEvent = authState.value?.event;
      final user = authState.value?.session?.user;
      switch (authEvent) {
        case AuthChangeEvent.initialSession:
          if (user == null) {
            logger.d('redirect to login page');
            return '/login';
          }
          return null;
        case AuthChangeEvent.signedIn:
          if (state.matchedLocation == '/login') {
            logger.d('redirect to main page');
            return '/home';
          }
          return null;
        case AuthChangeEvent.signedOut:
          if (state.matchedLocation != '/login') {
            logger.d('redirect to login page');
            return '/login';
          }
          return null;
        case AuthChangeEvent.userUpdated:
          final isWelcomeDone =
              user!.userMetadata?['chartq']?['is_welcome_done'] == true;
          final isWelcoming = state.matchedLocation == '/welcome';
          if (!isWelcomeDone && !isWelcoming) {
            logger.d('redirect to welcome page');
            return '/welcome';
          }
          return null;
        default:
          return null;
      }
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      ShellRoute(
        navigatorKey: _mainNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(child: ScaffoldWithNavBar(child: child));
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
            routes: [
              // 홈 화면의 하위 라우트들...
            ],
          ),
          GoRoute(
            path: '/study',
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
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: QuizScreen()),
            routes: [
              // 퀴즈 화면의 하위 라우트들...
            ],
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
            routes: [
              // 프로필 화면의 하위 라우트들...
              GoRoute(
                path: 'edit',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => ProfileEditScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
