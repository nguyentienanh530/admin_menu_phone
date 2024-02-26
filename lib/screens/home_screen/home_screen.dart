import 'package:admin_menu_mobile/features/auth/bloc/auth_bloc.dart';
import 'package:admin_menu_mobile/features/user/bloc/user_bloc.dart';
import 'package:admin_menu_mobile/screens/create_food_screen/create_food_screen.dart';
import 'package:admin_menu_mobile/screens/dashboard_screen/dashboard_screen.dart';
import 'package:admin_menu_mobile/screens/profile_screen/profile_screen.dart';
import 'package:admin_menu_mobile/screens/table_screen/table_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../order_history_screen/order_history_screen.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController controller = PageController();

  @override
  void initState() {
    _updateToken();
    super.initState();
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  _updateToken() async {
    var token = await getToken();
    _handelUpdate(_getUserID(), token!);
  }

  String _getUserID() {
    return context.read<AuthBloc>().state.user.id;
  }

  _handelUpdate(String userID, String token) {
    context.read<UserBloc>().add(UpdateToken(userID: userID, token: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: _buildBottomBar(context),
        body: HomeView(controller: controller));
  }

  Widget _buildBottomBar(BuildContext context) {
    return ConvexAppBar(
        items: [
          TabItem(
              fontFamily: GoogleFonts.nunito().fontFamily,
              icon: const Icon(Icons.house_rounded, size: 20),
              activeIcon: const Icon(Icons.house_rounded, size: 30),
              title: "Trang chủ"),
          TabItem(
              fontFamily: GoogleFonts.nunito().fontFamily,
              icon: const Icon(Icons.history_rounded, size: 20),
              activeIcon: const Icon(Icons.history_rounded, size: 30),
              title: "Lịch sử"),
          TabItem(
              fontFamily: GoogleFonts.nunito().fontFamily,
              icon: const Icon(Icons.add_box_rounded, size: 20),
              activeIcon: const Icon(Icons.add_box_rounded, size: 30),
              title: "Tạo món"),
          TabItem(
              fontFamily: GoogleFonts.nunito().fontFamily,
              icon: const Icon(Icons.table_restaurant, size: 20),
              activeIcon: const Icon(Icons.table_restaurant, size: 30),
              title: "Bàn ăn"),
          TabItem(
              fontFamily: GoogleFonts.nunito().fontFamily,
              icon: const Icon(Icons.person, size: 20),
              activeIcon: const Icon(Icons.person, size: 30),
              title: "Hồ sơ")
        ],
        style: TabStyle.reactCircle,
        activeColor: context.colorScheme.primary,
        shadowColor: context.colorScheme.inversePrimary,
        backgroundColor: context.colorScheme.background,
        top: -15,
        curveSize: 60,
        onTap: (index) {
          controller.jumpToPage(index);
        });
  }
}

class HomeView extends StatelessWidget {
  HomeView({super.key, required this.controller});

  final PageController controller;
  @override
  Widget build(BuildContext context) {
    return PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: _widgetOptions);
  }

  final List<Widget> _widgetOptions = [
    const DashboardScreen(),
    const OrderHistoryScreen(),
    const CreateFoodScreen(),
    const TableScreen(),
    const ProfileScreen()
  ];
}
