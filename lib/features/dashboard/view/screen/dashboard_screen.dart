import 'package:admin_menu_mobile/core/utils/app_string.dart';
import 'package:admin_menu_mobile/core/utils/extensions.dart';
import 'package:flutter/material.dart';

import 'dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(context), body: const DashboardView());
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text(AppString.titleManage,
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true);
  }
}
