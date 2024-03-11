import 'package:admin_menu_mobile/core/utils/app_string.dart';
import 'package:admin_menu_mobile/core/utils/extensions.dart';
import 'package:admin_menu_mobile/features/dashboard/cubit/daily_revenue_cubit.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/features/table/bloc/table_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dashboard_view.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => OrderBloc()),
          BlocProvider(create: (context) => TableBloc()),
          BlocProvider(create: (context) => DailyRevenueCubit())
        ],
        child: Scaffold(
            appBar: _buildAppbar(context), body: const DashboardView()));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text(AppString.titleManage, style: context.titleStyleMedium),
        centerTitle: true);
  }
}
