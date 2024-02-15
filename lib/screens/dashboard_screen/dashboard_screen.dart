import 'package:admin_menu_mobile/features/table/bloc/table_bloc.dart';
import 'package:admin_menu_mobile/utils/app_text.dart';
import 'package:admin_menu_mobile/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context),
        body: MultiBlocProvider(
          providers: [BlocProvider(create: (context) => TableBloc())],
          child: const DashboardView(),
        ));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text(AppText.titleManage,
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true);
  }
}
