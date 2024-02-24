import 'package:admin_menu_mobile/features/food/data/food_model.dart';
import 'package:admin_menu_mobile/features/table/model/table_model.dart';
import 'package:admin_menu_mobile/screens/add_food_screen/add_food_screen.dart';
import 'package:admin_menu_mobile/screens/food_detail_screen/food_detail_screen.dart';
import 'package:admin_menu_mobile/screens/order_detail_screen/order_detail_screen.dart';
import 'package:admin_menu_mobile/screens/order_history_detail_screen/order_history_detail_screen.dart';
import 'package:admin_menu_mobile/screens/order_screen/order_screen.dart';
import 'package:admin_menu_mobile/screens/search_food_screen/search_food_screen.dart';
import 'package:admin_menu_mobile/screens/sign_up_screen/signup_screen.dart';
import 'package:admin_menu_mobile/screens/table_screen/create_or_update_table.dart';
import 'package:admin_menu_mobile/screens/update_food_screen/update_food_screen.dart';
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
  static const String order = '/order';
  static const String orderDetail = '/orderDetail';
  static const String addFood = '/addFood';
  static const String orderHistoryDetail = '/orderHistoryDetail';
  static const String updateFood = '/updateFood';
  static const String createTable = '/createTable';
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
      GoRoute(path: RouteName.home, builder: (context, state) => HomeScreen()),
      GoRoute(
          path: RouteName.createTable,
          builder: (context, state) {
            final arg = GoRouterState.of(context).extra as Map<String, dynamic>;
            final mode = arg['mode'] as Mode;
            final table = arg['table'] ?? TableModel();

            return CreateTable(mode: mode, tableModel: table);
          }),
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
          path: RouteName.addFood,
          builder: (context, state) => const AddFoodScreen()),
      GoRoute(
          path: RouteName.foodDetail,
          builder: (context, state) {
            final FoodModel foodModel =
                GoRouterState.of(context).extra as FoodModel;
            return FoodDetailScreen(food: foodModel);
          }),
      GoRoute(
          path: RouteName.order,
          builder: (context, state) {
            final String nametable = GoRouterState.of(context).extra as String;
            return OrderScreen(nameTable: nametable);
          }),
      GoRoute(
          path: RouteName.orderDetail,
          builder: (context, state) {
            final String idOrder = GoRouterState.of(context).extra as String;
            return OrderDetailScreen(idOrder: idOrder);
          }),
      GoRoute(
          path: RouteName.orderHistoryDetail,
          builder: (context, state) {
            final String idOrder = GoRouterState.of(context).extra as String;
            return OrderHistoryDetailScreen(idOrder: idOrder);
          }),
      GoRoute(
          path: RouteName.updateFood,
          builder: (context, state) {
            final FoodModel foodModel =
                GoRouterState.of(context).extra as FoodModel;
            return UpdateFoodScreen(foodModel: foodModel);
          })
    ]);
