import 'package:admin_menu_mobile/core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../common/bloc/generic_bloc_state.dart';
import '../../../../../common/widget/empty_screen.dart';
import '../../../../../common/widget/error_screen.dart';
import '../../../../../common/widget/loading_screen.dart';
import '../../bloc/print_bloc.dart';
import '../../cubit/print_cubit.dart';
import '../../data/model/print_model.dart';
import '../../data/print_data_source/print_data_source.dart';

class PrintScreen extends StatelessWidget {
  const PrintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PrintBloc()..add(PrintsFetched()),
        child: const PrintView());
  }
}

// ignore: must_be_immutable
class PrintView extends StatelessWidget {
  const PrintView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppbar(context), body: _buildBody(context));
  }

  Widget _buildBody(BuildContext context) {
    var printState = context.watch<PrintBloc>().state;

    return switch (printState.status) {
      Status.loading => const LoadingScreen(),
      Status.empty => const EmptyScreen(),
      Status.failure => ErrorScreen(errorMsg: printState.error),
      Status.success => ListView.builder(
          itemCount: printState.datas!.length,
          itemBuilder: (context, index) =>
              _buildItemPrint(context, printState.datas![index]))
    };
  }

  Widget _buildItemPrint(BuildContext context, PrintModel print) {
    var isPrintActive = ValueNotifier(false);
    var printCubit = context.watch<PrintCubit>().state;
    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SvgPicture.asset('assets/icon/print.svg',
                            colorFilter: const ColorFilter.mode(
                                Colors.white, BlendMode.srcIn))),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(print.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Row(children: [
                            _buildChildItem(context, 'IP: ', print.ip)
                          ]),
                          _buildChildItem(context, 'port: ', print.port)
                        ])
                  ]),
                  ValueListenableBuilder(
                      valueListenable: isPrintActive,
                      builder: (context, value, child) {
                        logger.d(value);
                        if (value) {
                          _handleSavePrint(print);
                          context.read<PrintCubit>().onPrintChanged(print);
                        }
                        return Transform.scale(
                            scale: 0.8,
                            child: Switch(
                                activeTrackColor: context.colorScheme.secondary,
                                value: printCubit.id == print.id ? true : false,
                                onChanged: (value) {
                                  isPrintActive.value = value;
                                }));
                      })
                ])));
  }

  void _handleSavePrint(PrintModel print) {
    PrintDataSource.setPrint(print);
  }

  Widget _buildChildItem(BuildContext context, String label, value) {
    return Row(children: [
      Text(label),
      Text(value, style: TextStyle(color: Colors.white.withOpacity(0.4)))
    ]);
  }

  _buildAppbar(BuildContext context) => AppBar(
      centerTitle: true,
      title: Text('Cấu hình máy in', style: context.titleStyleMedium));
}
