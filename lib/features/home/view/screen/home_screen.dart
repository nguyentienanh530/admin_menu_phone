import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/common/widget/empty_screen.dart';
import 'package:admin_menu_mobile/common/widget/error_screen.dart';
import 'package:admin_menu_mobile/common/widget/loading_screen.dart';
import 'package:admin_menu_mobile/config/router.dart';
import 'package:admin_menu_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:admin_menu_mobile/features/category/view/screen/categories_screen.dart';
import 'package:admin_menu_mobile/features/order/view/screen/order_screen.dart';
import 'package:admin_menu_mobile/features/user/bloc/user_bloc.dart';
import 'package:admin_menu_mobile/features/dashboard/view/screen/dashboard_screen.dart';
import 'package:admin_menu_mobile/features/food/view/screen/food_screen.dart';
import 'package:admin_menu_mobile/features/user/view/screen/profile_screen.dart';
import 'package:admin_menu_mobile/features/table/view/screen/table_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_repository/user_repository.dart';

import '../../../print/cubit/is_use_print_cubit.dart';
import '../../../print/cubit/print_cubit.dart';
import '../../../print/data/print_data_source/print_data_source.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => UserBloc(), child: const HomeView());
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController controller = PageController();

  @override
  void initState() {
    _updateToken();
    getUserData();
    getIsUsePrint();
    _handleGetPrint();
    super.initState();
  }

  void _handleGetPrint() async {
    var print = await PrintDataSource.getPrint();
    if (!mounted) return;
    if (print != null) {
      context.read<PrintCubit>().onPrintChanged(print);
    }
  }

  void getIsUsePrint() async {
    var isUsePrint = await PrintDataSource.getIsUsePrint() ?? false;
    if (!mounted) return;
    context.read<IsUsePrintCubit>().onUsePrintChanged(isUsePrint);
  }

  void getUserData() {
    if (!mounted) return;
    context.read<UserBloc>().add(UserFecthed(userID: _getUserID()));
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  _updateToken() async {
    var token = await getToken();

    UserRepository(firebaseFirestore: FirebaseFirestore.instance)
        .updateAdminToken(userID: _getUserID(), token: token ?? '');
  }

  String _getUserID() {
    return context.read<AuthBloc>().state.user.id;
  }

  // _handelUpdate(String userID, String token) {
  //   context.read<UserBloc>().add(UpdateToken(userID: userID, token: token));
  // }

  final List<Widget> _widgetOptions = [
    const DashboardScreen(),
    const OrderScreen(),
    const FoodScreen(),
    const TableScreen(),
    const CategoriesScreen(),
    const ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    var userState = context.watch<UserBloc>().state;

    switch (userState.status) {
      case Status.loading:
        return Scaffold(
            bottomNavigationBar: _buildBottomBar(context),
            body: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller,
                children: _widgetOptions));
      case Status.empty:
        return const EmptyScreen();
      case Status.failure:
        return ErrorScreen(errorMsg: userState.error ?? '');
      case Status.success:
        if (userState.data?.role == 'admin') {
          _updateToken();
          return Scaffold(
              bottomNavigationBar: _buildBottomBar(context),
              body: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller,
                  children: _widgetOptions));
        }
        return Center(
            child: Card(
                margin: const EdgeInsets.all(16),
                color: context.colorScheme.error.withOpacity(0.2),
                child: Container(
                    height: context.sizeDevice.width * 0.8,
                    width: context.sizeDevice.width * 0.8,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outlined,
                              color: context.colorScheme.error, size: 50.0),
                          const SizedBox(height: 10.0),
                          Text('Thông báo',
                              style: context.titleStyleLarge!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10.0),
                          const Text("Tài khoản không có quyền sử dụng!",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center),
                          const SizedBox(height: 30),
                          FilledButton(
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(const AuthLogoutRequested());
                                context.go(RouteName.login);
                              },
                              child: const Text('Quay lại đăng nhập',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))
                        ]))));

      default:
        return const LoadingScreen();
    }
  }

  Widget _buildBottomBar(BuildContext context) {
    return ConvexAppBar(
        items: [
          TabItem(
              fontFamily: GoogleFonts.nunito().fontFamily,
              icon: SvgPicture.asset('assets/icon/home.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              activeIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/icon/home.svg',
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn))),
              title: "Trang chủ"),
          TabItem(
              fontFamily: GoogleFonts.nunito().fontFamily,
              icon: SvgPicture.asset('assets/icon/ordered.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              activeIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/icon/ordered.svg',
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn))),
              title: "Đơn"),
          TabItem(
              fontFamily: GoogleFonts.nunito().fontFamily,
              icon: SvgPicture.asset('assets/icon/food.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              activeIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/icon/food.svg',
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn))),
              title: "Món ăn"),
          TabItem(
              fontFamily: GoogleFonts.nunito().fontFamily,
              icon: SvgPicture.asset('assets/icon/chair.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              activeIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/icon/chair.svg',
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn))),
              title: "Bàn ăn"),
          TabItem(
              icon: SvgPicture.asset('assets/icon/category.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              activeIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/icon/category.svg',
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn))),
              title: "Danh mục"),
          TabItem(
              fontFamily: GoogleFonts.nunito().fontFamily,
              icon: SvgPicture.asset('assets/icon/user.svg',
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              activeIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset('assets/icon/user.svg',
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn))),
              title: "Hồ sơ")
        ],
        style: TabStyle.reactCircle,
        activeColor: context.colorScheme.primary,
        shadowColor: context.colorScheme.inversePrimary,
        backgroundColor: context.colorScheme.background,

        // color: context.colorScheme.secondary,
        top: -15,
        curveSize: 60,
        onTap: (index) {
          controller.jumpToPage(index);
        });
  }
}
