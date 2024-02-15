import 'package:admin_menu_mobile/features/table/bloc/table_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DashboardView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    context.read<TableBloc>().add(GetAllTable());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: SingleChildScrollView(
          child: Column(children: [
        Padding(
            padding: EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                top: defaultPadding),
            child: Row(
              children: [
                const Expanded(child: ItemCirclePercent()),
                SizedBox(width: defaultPadding),
                const Expanded(child: ItemCirclePercent())
              ],
            )),
        Padding(
            padding: EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
                top: defaultPadding),
            child: const ChartPaymentToDay()),
        _buildHeader(context),
        _buildTitle(context),
        Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: const _ListTable(),
        )
      ])),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(defaultPadding / 2),
        margin: EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
            color: context.colorScheme.secondary,
            borderRadius: BorderRadius.circular(10)),
        child: const Center(
            child: DisplayWhiteText(
                text: 'Danh sách bàn ăn',
                size: 14,
                fontWeight: FontWeight.bold)));
  }

  Widget _buildHeader(BuildContext context) {
    return SizedBox(
        height: context.sizeDevice.height * 0.25,
        child: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: _buidItemDashBoard(context,
                          title: "Tổng đơn",
                          title2: "Đang chờ",
                          value: 10, onTap: () {
                    // print(_.allOrder.length);
                    // Navigator.of(context).push(PageRouteBuilder(
                    //     pageBuilder: (_, __, ___) => const AllOrders()));
                  })),
                  SizedBox(width: defaultPadding),
                  Expanded(
                      child: _buidItemDashBoard(context,
                          title: "Người dùng",
                          title2: "Tài khoản",
                          value: 10, onTap: () {
                    // Get.to(() => UserListScreen());
                  })),
                  SizedBox(width: defaultPadding),
                  Expanded(
                      child: _buidItemDashBoard(context,
                          title: "Số lượng",
                          title2: "Món",
                          value: 10, onTap: () {
                    // Get.to(() => SearchFood());
                  }))
                ])));
  }

  Widget _buidItemDashBoard(BuildContext context,
      {String? title, String? title2, Function()? onTap, int? value}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.all(defaultPadding / 2),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                color: context.colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12.withOpacity(0.05),
                      blurRadius: 20.0,
                      spreadRadius: 10.0,
                      offset: const Offset(0.0, 10.0))
                ]),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FittedBox(child: Text(title!, style: context.textStyleSmall)),
                  FittedBox(
                      child: Text(
                          value == null || value == 0 ? "0" : value.toString(),
                          style: context.textTheme.titleLarge!.copyWith(
                              color: context.colorScheme.secondary,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center)),
                  FittedBox(child: Text(title2!, style: context.textStyleSmall))
                ])));
  }

  @override
  bool get wantKeepAlive => true;
}

class ChartPaymentToDay extends StatelessWidget {
  const ChartPaymentToDay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: context.sizeDevice.height * 0.2,
        decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: BorderRadius.circular(defaultBorderRadius)));
  }
}

class ItemCirclePercent extends StatelessWidget {
  const ItemCirclePercent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: context.sizeDevice.height * 0.2,
        decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: BorderRadius.circular(defaultBorderRadius)));
  }
}

class _ListTable extends StatelessWidget {
  const _ListTable();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TableBloc, TableState>(builder: (context, state) {
      var widget = (switch (state) {
        TableInProgress() => Center(
            child: SpinKitCircle(color: context.colorScheme.primary, size: 30)),
        TableFailure() => Text(state.error!),
        TableSuccess() => GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 4,
            crossAxisSpacing: defaultPadding,
            mainAxisSpacing: defaultPadding,
            children: state.tables!
                .map((e) => _ItemTable(nameTable: e.name))
                .toList()),
        TableInitial() => const SizedBox()
      });
      return widget;
    });
  }
}

class _ItemTable extends StatelessWidget {
  const _ItemTable({super.key, this.nameTable});
  final String? nameTable;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: BorderRadius.circular(defaultBorderRadius)),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          FittedBox(child: Text(nameTable!, style: context.textStyleSmall)),
          FittedBox(
            child: Text('100',
                style: context.textStyleLarge!.copyWith(
                    color: context.colorScheme.secondary,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox()
        ]));
  }
}
