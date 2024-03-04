import 'package:admin_menu_mobile/config/config.dart';
import 'package:admin_menu_mobile/features/table/bloc/table_bloc.dart';
import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/bloc/bloc_helper.dart';
import '../../../../common/bloc/generic_bloc_state.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/common_bottomsheet.dart';
import '../../../../common/widget/common_line_text.dart';
import '../../data/model/table_model.dart';
import '../../../../common/widget/empty_screen.dart';
import '../../../../common/widget/error_screen.dart';
import '../../../../common/widget/loading_screen.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: _buildFloatingActionButton(),
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        appBar: _buildAppbar(context),
        body: const SafeArea(child: TableView()));
  }

  getData() async {
    if (!mounted) return;
    context.read<TableBloc>().add(TablesFetched());
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        heroTag: 'addTable',
        backgroundColor: context.colorScheme.secondary,
        onPressed: () async {
          var result = await context
              .push<bool>(RouteName.createTable, extra: {'mode': Mode.create});
          if (result != null && result) {
            getData();
          } else {}
        },
        child: const Icon(Icons.add));
  }

  _buildAppbar(BuildContext context) => AppBar(
      centerTitle: true,
      title: Text("Bàn ăn",
          style:
              context.textStyleMedium!.copyWith(fontWeight: FontWeight.bold)));

  @override
  bool get wantKeepAlive => true;
}

class TableView extends StatelessWidget {
  const TableView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          context.read<TableBloc>().add(TablesFetched());
        },
        child: BlocBuilder<TableBloc, GenericBlocState<TableModel>>(
            buildWhen: (previous, current) =>
                context.read<TableBloc>().operation == ApiOperation.select,
            builder: (context, state) {
              return (switch (state.status) {
                Status.loading => const LoadingScreen(),
                Status.failure => ErrorScreen(errorMsg: state.error),
                Status.empty => const EmptyScreen(),
                Status.success =>
                  _buildBody(context, state.datas as List<TableModel>)
              });
            }));
  }

  Widget _buildBody(BuildContext context, List<TableModel> tables) {
    return Column(children: [
      Expanded(
          child: SingleChildScrollView(
              child: Column(
                  children: [
        Column(
            children: tables
                .map((table) => Slidable(
                    endActionPane: ActionPane(
                        extentRatio: 0.6,
                        motion: const ScrollMotion(),
                        children: [
                          _buildActionSlidable(context,
                              color: context.colorScheme.primaryContainer,
                              icon: Icons.update, onTap: () {
                            context.push(RouteName.createTable, extra: {
                              'mode': Mode.update,
                              'table': table
                            }).then((result) {
                              if (result is bool && result) {
                                context.read<TableBloc>().add(TablesFetched());
                              }
                            });
                          }, title: 'Cập nhật'),
                          _buildActionSlidable(context,
                              color: context.colorScheme.errorContainer,
                              icon: Icons.delete,
                              onTap: () => _dialogDeleted(context, table),
                              title: 'Xóa'),
                        ]),
                    child: _buildItem(context, table)))
                .toList())
      ]
                      .animate(interval: 50.ms)
                      .slideX(
                          begin: -0.1,
                          end: 0,
                          curve: Curves.easeInOutCubic,
                          duration: 500.ms)
                      .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms))))
    ]);
  }

  void _dialogDeleted(BuildContext context, TableModel table) {
    showModalBottomSheet(
        context: context,
        builder: (context) => CommonBottomSheet(
              title: 'Chắc chắn muốn xóa bàn: ${table.name}?',
              textCancel: 'Hủy',
              textConfirm: 'Xóa',
              textConfirmColor: context.colorScheme.errorContainer,
              onCancel: () => context.pop(),
              onConfirm: () => onDeleteTable(context, table),
            ));
  }

  Widget _buildActionSlidable(BuildContext context,
      {Function()? onTap, String? title, IconData? icon, Color? color}) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: context.sizeDevice.width * 0.3,
            height: context.sizeDevice.width * 0.2,
            decoration: BoxDecoration(color: color),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon!, size: 18),
                  Text(title!, style: context.textStyleSmall)
                ])));
  }

  void onDeleteTable(BuildContext context, TableModel table) {
    // context.pop();
    context.read<TableBloc>().add(TableDeleted(idTable: table.id!));
    logger.d(context.read<TableBloc>().operation);
    showDialog(
        context: context,
        builder: (_) => BlocBuilder<TableBloc, GenericBlocState<TableModel>>(
            buildWhen: (previous, current) =>
                context.read<TableBloc>().operation == ApiOperation.delete &&
                previous.status != current.status,
            builder: (context, state) {
              logger.d(state.status);

              return switch (state.status) {
                Status.empty => const SizedBox(),
                Status.loading => const ProgressDialog(
                    descriptrion: "Deleting post...", isProgressed: true),
                Status.failure => RetryDialog(
                    title: state.error ?? "Error",
                    onRetryPressed: () => context
                        .read<TableBloc>()
                        .add(TableDeleted(idTable: table.id!))),
                Status.success => ProgressDialog(
                    descriptrion: "Đã xoá bàn: ${table.name}",
                    onPressed: () {
                      context.read<TableBloc>().add(TablesFetched());
                      pop(context, 2);
                    },
                    isProgressed: false)
              };
            }));
  }

  Widget _buildItem(BuildContext context, TableModel table) {
    return Card(
        color: table.status == AppString.tableStatusOccupied
            ? context.colorScheme.primaryContainer
            : null,
        shape: const OutlineInputBorder(borderRadius: BorderRadius.zero),
        margin: const EdgeInsets.all(0),
        child: Container(
            width: context.sizeDevice.width,
            padding: const EdgeInsets.all(15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CommonLineText(title: 'Tên bàn: ', value: table.name),
                  CommonLineText(
                      title: 'Số ghế: ', value: table.seats.toString()),
                  CommonLineText(
                      title: 'Trạng thái: ',
                      value: Ultils.tableStatus(table.status),
                      valueStyle: table.status == AppString.tableStatusOccupied
                          ? context.textStyleSmall!
                              .copyWith(color: Colors.greenAccent)
                          : context.textStyleSmall!
                              .copyWith(color: Colors.redAccent))
                ])));
  }
}
