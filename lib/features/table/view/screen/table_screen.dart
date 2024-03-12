import 'package:admin_menu_mobile/common/widget/common_refresh_indicator.dart';
import 'package:admin_menu_mobile/config/config.dart';
import 'package:admin_menu_mobile/features/table/bloc/table_bloc.dart';
import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
          }
        },
        child: const Icon(Icons.add));
  }

  _buildAppbar(BuildContext context) => AppBar(
      centerTitle: true,
      title: Text("Bàn ăn", style: context.titleStyleMedium));

  @override
  bool get wantKeepAlive => true;
}

class TableView extends StatelessWidget {
  const TableView({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonRefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          if (!context.mounted) return;
          context.read<TableBloc>().add(TablesFetched());
        },
        child: BlocBuilder<TableBloc, GenericBlocState<TableModel>>(
            buildWhen: (previous, current) =>
                context.read<TableBloc>().operation == ApiOperation.select,
            builder: (context, state) {
              switch (state.status) {
                case Status.loading:
                  return const LoadingScreen();
                case Status.failure:
                  return ErrorScreen(errorMsg: state.error);
                case Status.empty:
                  return const EmptyScreen();
                case Status.success:
                  var newTables = [...state.datas ?? <TableModel>[]];
                  newTables.sort((a, b) => a.name.compareTo(b.name));
                  return _buildBody(context, newTables);
              }
            }));
  }

  Widget _buildBody(BuildContext context, List<TableModel> tables) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: tables.length,
          itemBuilder: (context, index) => _buildItem(context, tables[index])),
    );
  }

  void _dialogDeleted(BuildContext context, TableModel table) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CommonBottomSheet(
              title: 'Chắc chắn muốn xóa bàn: ${table.name}?',
              textCancel: 'Hủy',
              textConfirm: 'Xóa',
              textConfirmColor: context.colorScheme.errorContainer,
              onConfirm: () => onDeleteTable(context, table),
            ));
  }

  Widget _buildActionSlidable(BuildContext context,
      {Function()? onTap, String? title, IconData? icon, Color? color}) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          child: Container(
              width: context.sizeDevice.width * 0.3,
              height: context.sizeDevice.width * 0.3,
              decoration: BoxDecoration(color: color),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Icon(icon!, size: 18), Text(title!)])),
        ));
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
    return InkWell(
      onTap: () {
        context.push(RouteName.createTable,
            extra: {'mode': Mode.update, 'table': table}).then((result) {
          if (result is bool && result) {
            context.read<TableBloc>().add(TablesFetched());
          }
        });
      },
      child: Card(
          color: table.isUse ? context.colorScheme.primaryContainer : null,
          // shape: const OutlineInputBorder(borderRadius: BorderRadius.zero),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
              width: context.sizeDevice.width,
              padding: const EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonLineText(
                              title: 'Tên bàn: ',
                              value: table.name,
                              valueStyle: TextStyle(
                                  color: context.colorScheme.secondary,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          CommonLineText(
                              title: 'Số ghế: ', value: table.seats.toString()),
                          const SizedBox(height: 8),
                          CommonLineText(
                              title: 'Trạng thái: ',
                              value: Ultils.tableStatus(table.isUse),
                              valueStyle: TextStyle(
                                  color: table.isUse
                                      ? Colors.greenAccent
                                      : Colors.redAccent)),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // SizedBox(
                          //     height: 30,
                          //     child: FilledButton.icon(
                          //         onPressed: () {

                          //         },
                          //         icon: Padding(
                          //             padding:
                          //                 const EdgeInsets.symmetric(vertical: 8),
                          //             child: SvgPicture.asset(
                          //                 'assets/icon/pencil.svg',
                          //                 colorFilter: const ColorFilter.mode(
                          //                     Colors.white, BlendMode.srcIn))),
                          //         label: const FittedBox(child: Text('Sửa')))),
                          IconButton(
                              style: ButtonStyle(
                                  iconSize: const MaterialStatePropertyAll(15),
                                  backgroundColor: MaterialStatePropertyAll(
                                      context.colorScheme.errorContainer)),
                              onPressed: () => _dialogDeleted(context, table),
                              icon: SvgPicture.asset('assets/icon/trash.svg',
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn)))
                        ])
                  ]))),
    );
  }
}
