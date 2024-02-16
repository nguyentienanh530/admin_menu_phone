import 'package:admin_menu_mobile/features/food/data/food_model.dart';
import 'package:admin_menu_mobile/screens/food_detail_screen/food_detail_screen.dart';
import 'package:admin_menu_mobile/screens/search_food_screen/search_food_screen.dart';
import 'package:admin_menu_mobile/screens/sign_up_screen/signup_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/bloc/auth_bloc.dart';
import '../screens/home_screen/home_screen.dart';
import '../screens/login_screen/login_screen.dart';

class RouteName {
  static const String home = '/';
  static const String login = '/login';
  static const String postDetail = '/post/:id';
  static const String profile = '/profile';
  static const String register = '/register';
  static const String searchFood = '/searchFood';
  static const String foodDetail = '/foodDetail';

  static const publicRoutes = [login, register];
}

final router = GoRouter(
    redirect: (context, state) {
      if (RouteName.publicRoutes.contains(state.fullPath)) {
        return null;
      }
      if (context.read<AuthBloc>().state.status == AuthStatus.authenticated) {
        return null;
      }
      return RouteName.login;
    },
    routes: [
      GoRoute(
          path: RouteName.home,
          builder: (context, state) => const HomeScreen()),
      GoRoute(
          path: RouteName.login,
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          path: RouteName.register,
          builder: (context, state) => const SignUpScreen()),
      GoRoute(
          path: RouteName.searchFood,
          builder: (context, state) => const SearchFoodScreen()),
      GoRoute(
          path: RouteName.foodDetail,
          builder: (context, state) {
            final FoodModel foodModel =
                GoRouterState.of(context).extra as FoodModel;
            return FoodDetailScreen(food: foodModel);
          })
    ]);
