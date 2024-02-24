import 'package:admin_menu_mobile/config/config.dart';
import 'package:admin_menu_mobile/features/table/bloc/table_bloc.dart';
import 'package:admin_menu_mobile/screens/table_screen/create_or_update_table.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

import '../../common/bloc/bloc_helper.dart';
import '../../common/bloc/generic_bloc_state.dart';
import '../../common/dialog/progress_dialog.dart';
import '../../common/dialog/retry_dialog.dart';
import '../../features/table/model/table_model.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/error_screen.dart';
import '../../widgets/loading_screen.dart';
import '../../widgets/widgets.dart';

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
        appBar: _buildAppbar(context),
        body: const SafeArea(child: TableView()));
  }

  getData() async {
    if (!mounted) return;
    context.read<TableBloc>().add(TablesFetched());
  }

  _buildAppbar(BuildContext context) => AppBar(
      centerTitle: true,
      title: Text("Bàn ăn",
          style:
              context.textStyleMedium!.copyWith(fontWeight: FontWeight.bold)),
      actions: [_buildIconCreateTable()]);

  Widget _buildIconCreateTable() {
    return SizedBox(
        child: IconButton(
            onPressed: () async {
              var result = await context.push<bool>(RouteName.createTable,
                  extra: {'mode': Mode.create});
              if (result != null && result) {
                getData();
              } else {
                print('k co gi');
              }
            },
            icon: const Icon(Icons.add)));
  }

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
                Status.success => _buildBody(context, state.data!)
              });
            }));
  }

  Widget _buildBody(BuildContext context, List<TableModel> tables) {
    return Column(children: [
      Expanded(
          child: SingleChildScrollView(
              child: Column(children: [
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
                            context.push(RouteName.createTable,
                                extra: {'mode': Mode.update, 'table': table});
                          }, title: 'Cập nhật'),
                          _buildActionSlidable(context,
                              color: context.colorScheme.errorContainer,
                              icon: Icons.delete,
                              onTap: () => onDeleteTable(context, table),
                              title: 'Xóa'),
                        ]),
                    child: _buildItem(context, table)))
                .toList())
      ])))
    ]);
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
                      pop(context, 1);
                    },
                    isProgressed: false)
              };
            }));
  }

  Widget _buildItem(BuildContext context, TableModel table) {
    return Card(
      shape: const OutlineInputBorder(borderRadius: BorderRadius.zero),
      margin: const EdgeInsets.all(0),
      child: InkWell(
          onTap: () {
            // Get.to(() => UpdateTableScreen(id: table.id!, tableModel: table));
          },
          child: SizedBox(
              height: context.sizeDevice.width * 0.15,
              child: Row(
                  children: [
                _buildImage(context, table),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CommonLineText(title: 'Tên bàn: ', value: table.name),
                      CommonLineText(
                          title: 'Số ghế: ', value: table.seats.toString())
                    ])
              ]
                      .animate(interval: 50.ms)
                      .slideX(
                          begin: -0.1,
                          end: 0,
                          curve: Curves.easeInOutCubic,
                          duration: 500.ms)
                      .fadeIn(
                          curve: Curves.easeInOutCubic, duration: 500.ms)))),
    );
  }

  Widget _buildImage(BuildContext context, TableModel table) {
    return Container(
        height: context.sizeDevice.width * 0.15,
        width: context.sizeDevice.width * 0.15,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.3),
            image: DecorationImage(
                image: NetworkImage(table.image == "" ? noImage : table.image),
                fit: BoxFit.cover)));
  }
}
