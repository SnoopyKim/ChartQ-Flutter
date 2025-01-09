class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String welcome = '/welcome';

  static const String study = '/study';
  static String studyDetail(String id) => '/study/$id';

  static const String quiz = '/quiz';
  static String quizDetail(String id) => '/quiz/$id';

  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String deleteAccount = '/profile/delete';
  static const String subscribe = '/profile/subscribe';
}
