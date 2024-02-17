import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/screens/order_screen/order_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/utils.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key, this.nameTable});
  final String? nameTable;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context),
        body: BlocProvider(
            create: (context) =>
                OrderBloc()..add(GetOrderOnTable(nameTable: nameTable)),
            child: const OrderView()));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text(' ${AppText.titleOrder} - $nameTable',
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true);
  }
}
