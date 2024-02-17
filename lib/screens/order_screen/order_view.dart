import 'package:admin_menu_mobile/config/router.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/utils/contants.dart';
import 'package:admin_menu_mobile/utils/extensions.dart';
import 'package:admin_menu_mobile/utils/util.dart';
import 'package:admin_menu_mobile/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';

import '../../features/order/data/order_model.dart';
import '../../widgets/widgets.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      switch (state) {
        case OrderInProgress():
          return Center(
              child:
                  SpinKitCircle(color: context.colorScheme.primary, size: 30));

        case OrderFailure():
          return Center(child: Text(state.error!));

        case OrderSuccess():
          if (state.orderModel!.isEmpty) {
            return const EmptyScreen();
          }
          return ListView.builder(
              itemCount: state.orderModel!.length,
              itemBuilder: (context, index) =>
                  ExpandableListView(orderModel: state.orderModel![index]));

        case OrderInitial():
          return Center(
              child:
                  SpinKitCircle(color: context.colorScheme.primary, size: 30));
      }
    });
  }
}

class ExpandableListView extends StatelessWidget {
  final OrderModel? orderModel;
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
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonLineText(
                                      title: "ID: ", value: orderModel!.id!),
                                  SizedBox(height: defaultPadding / 2),
                                  CommonLineText(
                                      title: "Thời gian đặt: ",
                                      value: Ultils.formatDateTime(
                                          orderModel!.dateOrder!))
                                ]),
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonLineText(
                                      valueStyle: context.textStyleMedium!
                                          .copyWith(
                                              color:
                                                  context.colorScheme.secondary,
                                              fontWeight: FontWeight.bold),
                                      value: Ultils.currencyFormat(double.parse(
                                          orderModel!.totalPrice.toString())))
                                ])
                          ])),
                )
              ]
                  .animate(interval: 50.ms)
                  .slideX(
                      begin: -0.1,
                      end: 0,
                      curve: Curves.easeInOutCubic,
                      duration: 500.ms)
                  .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms))),
    );
  }
}
