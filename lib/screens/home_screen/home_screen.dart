import 'package:admin_menu_mobile/screens/home_screen/home_view.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final PageController controller = PageController();
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
