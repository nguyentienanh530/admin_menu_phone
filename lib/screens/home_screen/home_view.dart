import 'package:admin_menu_mobile/screens/create_food_screen/create_food_screen.dart';
import 'package:admin_menu_mobile/screens/dashboard_screen/dashboard_screen.dart';
import 'package:admin_menu_mobile/screens/profile_screen/profile_screen.dart';
import 'package:admin_menu_mobile/screens/table_screen/table_screen.dart';
import 'package:flutter/material.dart';

import '../order_history_screen/order_history_screen.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key, this.indexBottomBar});
  final int? indexBottomBar;

  @override
  Widget build(BuildContext context) {
    return PageView(children: [_widgetOptions[indexBottomBar!]]);
  }

  final List<Widget> _widgetOptions = [
    const DashboardScreen(),
    const OrderHistoryScreen(),
    const CreateFoodScreen(),
    const TableScreen(),
    const ProfileScreen()
  ];
}
