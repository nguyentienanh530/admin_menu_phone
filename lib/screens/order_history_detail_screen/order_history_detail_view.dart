import 'package:admin_menu_mobile/features/food/data/food_model.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../features/order/dtos/order_model.dart';

class OrderHistoryDetailView extends StatelessWidget {
  const OrderHistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    var loadingOrInit = Center(
        child: SpinKitCircle(color: context.colorScheme.primary, size: 30));
    return BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
      return (switch (state.status) {
        OrderStatus.loading => loadingOrInit,
        OrderStatus.failure => Center(child: Text(state.message)),
        OrderStatus.success => _buildBody(context, state.order),
        OrderStatus.initial => loadingOrInit
      });
    });
  }

  Widget _buildBody(BuildContext context, OrderModel orderModel) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Thời gian đặt:", style: context.textStyleSmall),
            Text(Ultils.formatDateTime(orderModel.dateOrder!),
                style: context.textStyleSmall)
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Thời gian thanh toán:", style: context.textStyleSmall),
            Text(Ultils.formatDateTime(orderModel.datePay!),
                style: context.textStyleSmall)
          ]),
          SizedBox(height: defaultPadding),
          Table(
              border: TableBorder.all(
                  color: context.colorScheme.primary, width: 0.3),
              columnWidths: <int, TableColumnWidth>{
                0: FixedColumnWidth(context.sizeDevice.width * 0.5),
                1: FlexColumnWidth(context.sizeDevice.width * 0.0015),
                2: const FlexColumnWidth()
              },
              children: [
                TableRow(children: <Widget>[
                  Container(
                      height: 40,
                      alignment: Alignment.center,
                      color: context.colorScheme.primary,
                      child: Text("Món", style: context.textStyleSmall)),
                  Container(
                      alignment: Alignment.center,
                      height: 40,
                      color: context.colorScheme.primary,
                      child: Text("Số lượng", style: context.textStyleSmall)),
                  Container(
                      alignment: Alignment.center,
                      height: 40,
                      color: context.colorScheme.primary,
                      child: Text("Giá", style: context.textStyleSmall))
                ])
              ]),
          Table(
              border: TableBorder.all(
                  color: context.colorScheme.primary, width: 0.3),
              columnWidths: <int, TableColumnWidth>{
                0: FixedColumnWidth(context.sizeDevice.width * 0.5),
                1: FlexColumnWidth(context.sizeDevice.width * 0.0015),
                2: const FlexColumnWidth()
              },
              children: orderModel.foods!
                  .map((e) => _buildTable(context, e))
                  .toList()),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Tổng tiền:", style: context.textStyleSmall),
            Text(
                Ultils.currencyFormat(
                    double.parse(orderModel.totalPrice.toString())),
                style: context.textStyleSmall)
          ])
        ]));
  }

  TableRow _buildTable(BuildContext context, FoodModel food) {
    return TableRow(children: <Widget>[
      Container(
          padding: const EdgeInsets.all(5),
          height: 40,
          child: Text(food.title!, style: context.textStyleSmall)),
      Container(
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          height: 40,
          child: Text(food.quantity.toString(), style: context.textStyleSmall)),
      Container(
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          height: 40,
          child: Text(
              Ultils.currencyFormat(double.parse(food.totalPrice.toString())),
              style: context.textStyleSmall))
    ]);
  }
}
