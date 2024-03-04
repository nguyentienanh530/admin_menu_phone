import 'package:admin_menu_mobile/common/bloc/bloc_helper.dart';
import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/config/router.dart';
import 'package:admin_menu_mobile/features/food/bloc/food_bloc.dart';
import 'package:admin_menu_mobile/features/food/data/model/food_model.dart';
import 'package:admin_menu_mobile/features/order/bloc/order_bloc.dart';
import 'package:admin_menu_mobile/features/order/data/model/order_model.dart';
import 'package:admin_menu_mobile/features/table/bloc/table_bloc.dart';
import 'package:admin_menu_mobile/features/table/data/model/table_model.dart';
import 'package:admin_menu_mobile/features/user/bloc/user_bloc.dart';
import 'package:admin_menu_mobile/features/user/data/model/user_model.dart';
import 'package:admin_menu_mobile/common/widget/empty_screen.dart';
import 'package:admin_menu_mobile/common/widget/error_screen.dart';
import 'package:admin_menu_mobile/common/widget/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widget/display_white_text.dart';
import '../../../../core/utils/utils.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DashboardView>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    // context.read<OrderBloc>().add(OrdersWantingFecthed());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
        child: Column(children: [
      Padding(
          padding: EdgeInsets.only(
              left: defaultPadding, right: defaultPadding, top: defaultPadding),
          child: const DailyRevenue()),
      // Padding(
      //     padding: EdgeInsets.only(
      //         left: defaultPadding, right: defaultPadding, top: defaultPadding),
      //     child: ChartRevenue()),
      _buildHeader(context),
      _buildTitle(context),
      Padding(
          padding: EdgeInsets.all(defaultPadding), child: const _ListTable())
    ]));
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
                  // Expanded(child: _buildOrderWanting()),
                  SizedBox(width: defaultPadding),
                  Expanded(child: _buildUserAccount()),
                  SizedBox(width: defaultPadding),
                  Expanded(child: _buildFoods())
                ])));
  }

  Widget _buildUserAccount() {
    var loadingOrInitState = Center(
        child: SpinKitCircle(color: context.colorScheme.primary, size: 30));
    return BlocProvider(
        create: (context) => UserBloc()..add(UsersFetched()),
        child: BlocBuilder<UserBloc, GenericBlocState<UserModel>>(
            builder: (context, state) => switch (state.status) {
                  Status.loading => loadingOrInitState,
                  Status.empty => Text('Empty', style: context.textStyleSmall),
                  Status.failure =>
                    Text('Failure', style: context.textStyleSmall),
                  Status.success => _buidItemDashBoard(context,
                      title: "Người dùng",
                      title2: "Tài khoản",
                      value: state.datas!.length,
                      onTap: () {})
                }));
  }

  Widget _buildFoods() {
    var loadingOrInitState = Center(
        child: SpinKitCircle(color: context.colorScheme.primary, size: 30));
    return BlocProvider(
        create: (context) => FoodBloc()..add(FoodsFetched()),
        child: BlocBuilder<FoodBloc, GenericBlocState<Food>>(
            builder: (context, state) {
          return (switch (state.status) {
            Status.loading => loadingOrInitState,
            Status.empty => loadingOrInitState,
            Status.failure => Center(child: Text(state.error!)),
            Status.success => _buidItemDashBoard(context,
                  title: "Số lượng",
                  title2: "Món",
                  value: state.datas!.length, onTap: () {
                // context.push(RouteName.searchFood);
              })
          });
        }));
  }

  // Widget _buildOrderWanting() {
  //   return BlocProvider(
  //       create: (context) => OrderBloc()..add(OrdersWantingFecthed()),
  //       child: BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
  //           builder: (context, state) {
  //         print('dashboard + ${state.status}');
  //         return (switch (state.status) {
  //           Status.loading => Center(
  //               child: SpinKitCircle(
  //                   color: context.colorScheme.primary, size: 30)),
  //           Status.failure => Center(child: Text(state.error ?? '')),
  //           Status.success => _buidItemDashBoard(context,
  //               title: "Tổng đơn",
  //               title2: "Đang chờ",
  //               value: state.datas == null ? 0 : state.datas!.length,
  //               onTap: () {}),
  //           Status.empty => _buidItemDashBoard(context,
  //               title: "Tổng đơn", title2: "Đang chờ", value: 0, onTap: () {})
  //         });
  //       }));
  // }

  Widget _buidItemDashBoard(BuildContext context,
      {String? title, String? title2, Function()? onTap, int? value}) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
            child: Container(
                padding: EdgeInsets.all(defaultPadding / 2),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FittedBox(
                          child: Text(title!, style: context.textStyleSmall)),
                      FittedBox(
                          child: Text(
                              value == null || value == 0
                                  ? "0"
                                  : value.toString(),
                              style: context.textTheme.titleLarge!.copyWith(
                                  color: context.colorScheme.secondary,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center)),
                      FittedBox(
                          child: Text(title2!, style: context.textStyleSmall))
                    ]
                        .animate(interval: 50.ms)
                        .slideX(
                            begin: -0.1,
                            end: 0,
                            curve: Curves.easeInOutCubic,
                            duration: 500.ms)
                        .fadeIn(
                            curve: Curves.easeInOutCubic, duration: 500.ms)))));
  }

  @override
  bool get wantKeepAlive => true;
}

// class ChartRevenue extends StatelessWidget {
//   ChartRevenue({super.key});
//   var showingTooltip = -1;

//   @override
//   Widget build(BuildContext context) {
//     title() =>
//         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//           Text('Doanh thu ngày'.toUpperCase(), style: context.textStyleSmall),
//           Row(children: [
//             Text('Xem chi tiết', style: context.textStyleSmall),
//             const Icon(Icons.navigate_next_rounded)
//           ])
//         ]);

//     price() => Text(Ultils.currencyFormat(134534534),
//         style: context.titleStyleMedium!.copyWith(
//             fontWeight: FontWeight.bold, color: context.colorScheme.secondary));
//     childStatus(String title, String value) => Column(
//           children: [
//             Text(title,
//                 style: context.textStyleSmall!
//                     .copyWith(color: Colors.white.withOpacity(0.5))),
//             // const SizedBox(height: 16),
//             Text(value,
//                 style: context.textStyleLarge!
//                     .copyWith(fontWeight: FontWeight.bold)),
//           ],
//         );
//     status() => Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             childStatus('Đơn hàng mới', '10'),
//             childStatus('Tổng đơn/Ngày', '100'),
//             childStatus('Đơn đang lên', '1'),
//           ],
//         );

//     return Card(
//         child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: BarChart(BarChartData(
//               barGroups: [
//                 generateGroupData(1, 10),
//                 generateGroupData(2, 18),
//                 generateGroupData(3, 4),
//                 generateGroupData(4, 11),
//               ],
//             ))));
//   }

//   BarChartGroupData generateGroupData(int x, int y) {
//     return BarChartGroupData(
//       x: x,
//       showingTooltipIndicators: showingTooltip == x ? [0] : [],
//       barRods: [
//         BarChartRodData(toY: y.toDouble()),
//       ],
//     );
//   }
// }

class DailyRevenue extends StatelessWidget {
  const DailyRevenue({super.key});

  @override
  Widget build(BuildContext context) {
    title() =>
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Doanh thu ngày'.toUpperCase(), style: context.textStyleSmall),
          Row(children: [
            Text('Xem chi tiết', style: context.textStyleSmall),
            const Icon(Icons.navigate_next_rounded)
          ])
        ]);

    price() => Text(Ultils.currencyFormat(134534534),
        style: context.titleStyleMedium!.copyWith(
            fontWeight: FontWeight.bold, color: context.colorScheme.secondary));
    childStatus(String title, String value) => Column(
          children: [
            Text(title,
                style: context.textStyleSmall!
                    .copyWith(color: Colors.white.withOpacity(0.5))),
            const SizedBox(height: 8),
            Text(value,
                style: context.textStyleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
          ],
        );
    status() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            childStatus('Đơn hàng mới', '10'),
            childStatus('Tổng đơn/Ngày', '100'),
            childStatus('Đơn đang lên', '1'),
          ],
        );

    return Card(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                // height: context.sizeDevice.height * 0.2,
                width: context.sizeDevice.width,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title(),
                      price(),
                      Divider(color: context.colorScheme.primary),
                      status()
                    ]))));
  }
}

class ItemCirclePercent extends StatelessWidget {
  const ItemCirclePercent({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(child: SizedBox(height: context.sizeDevice.height * 0.2));
  }
}

class _ListTable extends StatelessWidget {
  const _ListTable();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TableBloc()..add(TablesFetched()),
        child: BlocBuilder<TableBloc, GenericBlocState<TableModel>>(
            builder: (context, state) {
          return switch (state.status) {
            Status.empty => const EmptyScreen(),
            Status.loading => const LoadingScreen(),
            Status.failure => ErrorScreen(errorMsg: state.error),
            Status.success => GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 4,
                // crossAxisSpacing: defaultPadding,
                // mainAxisSpacing: defaultPadding,
                children:
                    state.datas!.map((e) => _ItemTable(table: e)).toList()),
          };
        }));
  }
}

class _ItemTable extends StatelessWidget {
  const _ItemTable({this.table});
  final TableModel? table;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            OrderBloc()..add(OrdersOnTableFecthed(tableID: table!.id!)),
        child: BlocBuilder<OrderBloc, GenericBlocState<Orders>>(
            buildWhen: (previous, current) =>
                context.read<OrderBloc>().operation == ApiOperation.select,
            builder: (context, state) {
              logger.d("ádasd ${state.status} ");
              switch (state.status) {
                case Status.loading:
                  return Center(
                      child: SpinKitCircle(
                          color: context.colorScheme.primary, size: 30));
                case Status.failure:
                  return Center(child: Text(state.error ?? ''));
                case Status.success:
                  return GestureDetector(
                      onTap: () => context.push(RouteName.order, extra: table),
                      child: Card(
                          child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(3),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    FittedBox(
                                        child: Text(table!.name,
                                            style: context.textStyleSmall)),
                                    FittedBox(
                                        child: Text(
                                            state.datas!.length.toString(),
                                            style: context.textStyleLarge!
                                                .copyWith(
                                                    color: context
                                                        .colorScheme.secondary,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                    FittedBox(
                                        child: Text(
                                            Ultils.tableStatus(table!.status),
                                            style: context.textStyleSmall!
                                                .copyWith(
                                                    color: Colors.green))),
                                  ]))));
                case Status.empty:
                  return GestureDetector(
                      onTap: () => context.push(RouteName.order, extra: table),
                      child: Card(
                          child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(3),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    FittedBox(
                                        child: Text(table!.name,
                                            style: context.textStyleSmall)),
                                    FittedBox(
                                        child: Text('0',
                                            style: context.textStyleLarge!
                                                .copyWith(
                                                    color: context
                                                        .colorScheme.secondary,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                    FittedBox(
                                        child: Text(
                                            Ultils.tableStatus(table!.status),
                                            style: context.textStyleSmall!
                                                .copyWith(
                                                    color: Colors.redAccent)))
                                  ]))));
              }
            }));
  }
}
