import 'package:admin_menu_mobile/common/bloc/bloc_helper.dart';
import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/widgets/error_screen.dart';
import 'package:admin_menu_mobile/widgets/loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_menu_mobile/config/router.dart';
import 'package:admin_menu_mobile/widgets/empty_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import '../../features/order/dtos/order_model.dart';
import '../../widgets/widgets.dart';
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
                OrderBloc()..add(OrdersFecthed(tableName: nameTable!)),
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

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
        buildWhen: (previous, current) =>
            context.read<OrderBloc>().operation == ApiOperation.select,
        builder: (context, state) => switch (state.status) {
              Status.loading => const LoadingScreen(),
              Status.empty => const EmptyScreen(),
              Status.failure => ErrorScreen(errorMsg: state.error),
              Status.success => ListView.builder(
                  itemCount: state.datas!.length,
                  itemBuilder: (context, index) =>
                      ExpandableListView(orderModel: state.datas![index]))
            });
  }
}

class ExpandableListView extends StatelessWidget {
  final Orders? orderModel;
  const ExpandableListView({super.key, this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: GestureDetector(
            onTap: () =>
                context.push(RouteName.orderDetail, extra: orderModel!.id),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Card(
                      child: Container(
                          padding: EdgeInsets.all(defaultPadding),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _buildIDAndTimeOrder(),
                                _buildPrice(context)
                              ])))
                ]
                    .animate(interval: 50.ms)
                    .slideX(
                        begin: -0.1,
                        end: 0,
                        curve: Curves.easeInOutCubic,
                        duration: 500.ms)
                    .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms))));
  }

  Widget _buildPrice(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonLineText(
              valueStyle: context.textStyleMedium!.copyWith(
                  color: context.colorScheme.secondary,
                  fontWeight: FontWeight.bold),
              value: Ultils.currencyFormat(
                  double.parse(orderModel!.totalPrice.toString())))
        ]);
  }

  Widget _buildIDAndTimeOrder() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonLineText(title: "ID: ", value: orderModel!.id!),
          SizedBox(height: defaultPadding / 2),
          CommonLineText(
              title: "Đặt lúc: ",
              value: Ultils.formatDateTime(orderModel!.dateOrder!))
        ]);
  }
}
