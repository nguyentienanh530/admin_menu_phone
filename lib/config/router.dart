import 'package:admin_menu_mobile/screens/sign_up_screen/signup_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/login_screen/login_screen.dart';

class RouteName {
  static const String home = '/';
  static const String login = '/login';
  static const String postDetail = '/post/:id';
  static const String profile = '/profile';
  static const String register = '/register';

  static const publicRoutes = [
    login,
    register,
  ];
}

final router = GoRouter(
  redirect: (context, state) {
    if (RouteName.publicRoutes.contains(state.fullPath)) {
      return null;
    }
    // if (context.read<AuthBloc>().state is AuthAuthenticateSuccess) {
    //   return null;
    // }
    return RouteName.login;
  },
  routes: [
    // GoRoute(
    //   path: RouteName.home,
    //   builder: (context, state) => HomeScreen(),
    // ),
    GoRoute(
      path: RouteName.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteName.register,
      builder: (context, state) => const SignUpScreen(),
    ),
  ],
);
