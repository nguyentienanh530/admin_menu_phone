import 'package:admin_menu_mobile/common/bloc/bloc_helper.dart';
import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/features/table/data/model/table_model.dart';
import 'package:admin_menu_mobile/common/widget/error_screen.dart';
import 'package:admin_menu_mobile/common/widget/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_menu_mobile/config/router.dart';
import 'package:admin_menu_mobile/common/widget/empty_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../data/model/order_model.dart';
import '../../../../core/utils/utils.dart';

class OrderOnTable extends StatelessWidget {
  const OrderOnTable({super.key, this.tableModel});
  final TableModel? tableModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context),
        body: BlocProvider(
            create: (context) =>
                OrderBloc()..add(OrdersFecthed(tableID: tableModel!.id!)),
            child: const OrderView()));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text(' ${AppString.titleOrder} - ${tableModel!.name}',
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
            onTap: () async {
              await context.push(RouteName.orderDetail, extra: orderModel).then(
                  (value) => context
                      .read<OrderBloc>()
                      .add(OrdersFecthed(tableID: orderModel!.tableID!)));
            },
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
              value: Ultils.formatDateTime(orderModel!.orderTime!))
        ]);
  }
}
