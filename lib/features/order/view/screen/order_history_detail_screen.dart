import 'package:admin_menu_mobile/features/order/data/model/food_dto.dart';
import 'package:admin_menu_mobile/features/order/data/model/order_model.dart';
import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:flutter/material.dart';

class OrderHistoryDetailScreen extends StatelessWidget {
  const OrderHistoryDetailScreen({super.key, required this.orders});
  final Orders orders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context),
        body: OrderHistoryDetailView(orders: orders));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text('Chi tiết đơn hàng',
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true);
  }
}

class OrderHistoryDetailView extends StatelessWidget {
  const OrderHistoryDetailView({super.key, required this.orders});
  final Orders orders;

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Thời gian đặt:", style: context.textStyleSmall),
            Text(Ultils.formatDateTime(orders.orderTime!),
                style: context.textStyleSmall)
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Thời gian thanh toán:", style: context.textStyleSmall),
            Text(Ultils.formatDateTime(orders.orderTime!),
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
              children:
                  orders.foods.map((e) => _buildTable(context, e)).toList()),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Tổng tiền:", style: context.textStyleSmall),
            Text(
                Ultils.currencyFormat(
                    double.parse(orders.totalPrice.toString())),
                style: context.textStyleSmall)
          ])
        ]));
  }

  TableRow _buildTable(BuildContext context, FoodDto food) {
    return TableRow(children: <Widget>[
      Container(
          padding: const EdgeInsets.all(5),
          height: 40,
          child: Text(food.foodName, style: context.textStyleSmall)),
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
