import 'package:admin_menu_mobile/common/widget/common_refresh_indicator.dart';
import 'package:admin_menu_mobile/common/widget/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:tiengviet/tiengviet.dart';
import '../../../../common/bloc/generic_bloc_state.dart';
import '../../../../common/dialog/app_alerts.dart';
import '../../../../common/dialog/progress_dialog.dart';
import '../../../../common/dialog/retry_dialog.dart';
import '../../../../common/widget/common_bottomsheet.dart';
import '../../../../common/widget/empty_screen.dart';
import '../../../../common/widget/error_screen.dart';
import '../../../../config/config.dart';
import '../../../../core/utils/utils.dart';
import '../../bloc/food_bloc.dart';
import '../../data/model/food_model.dart';
import 'item_food.dart';

class ListFoodIsShow extends StatefulWidget {
  const ListFoodIsShow({super.key, required this.textSearch});
  final String textSearch;
  @override
  State<ListFoodIsShow> createState() => _ListFoodIsShowState();
}

class _ListFoodIsShowState extends State<ListFoodIsShow>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
            create: (context) =>
                FoodBloc()..add(const FoodsFetched(isShowFood: true)),
            child: ListFoodIsShowView(textSearch: widget.textSearch))
        .animate()
        .slideX(
            begin: -0.1, end: 0, curve: Curves.easeInOutCubic, duration: 500.ms)
        .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms);
  }

  @override
  bool get wantKeepAlive => true;
}

class ListFoodIsShowView extends StatelessWidget {
  const ListFoodIsShowView({super.key, required this.textSearch});
  final String textSearch;

  @override
  Widget build(BuildContext context) {
    var foodIsShow = context.watch<FoodBloc>().state;
    return CommonRefreshIndicator(
        child: (switch (foodIsShow.status) {
          Status.loading => const LoadingScreen(),
          Status.empty => const EmptyScreen(),
          Status.failure => ErrorScreen(errorMsg: foodIsShow.error),
          Status.success => ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: foodIsShow.datas!.length,
              itemBuilder: (context, i) {
                if (foodIsShow.datas![i].name
                        .toString()
                        .toLowerCase()
                        .contains(textSearch.toLowerCase()) ||
                    TiengViet.parse(
                            foodIsShow.datas![i].name.toString().toLowerCase())
                        .contains(textSearch.toLowerCase())) {
                  return ItemFood(
                      onTapDeleteFood: () =>
                          _buildDeleteFood(context, foodIsShow.datas![i]),
                      index: i,
                      food: foodIsShow.datas![i],
                      onTap: () {
                        context
                            .push(RouteName.foodDetail,
                                extra: foodIsShow.datas![i])
                            .then((value) {
                          if (value is bool || value == true) {
                            context
                                .read<FoodBloc>()
                                .add(const FoodsFetched(isShowFood: true));
                          }
                        });
                      });
                }
                return const SizedBox();
              })

          // ListItemFood(
          //     text: textSearch,
          //     foods: foodIsShow.datas ?? <Food>[],
          //     onBack: () => context
          //         .read<FoodBloc>()
          //         .add(const FoodsFetched(isShowFood: false)))
        }),
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          if (!context.mounted) return;
          context.read<FoodBloc>().add(const FoodsFetched(isShowFood: true));
        });
  }

  _buildDeleteFood(BuildContext context, Food food) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              // height: 200,
              child: CommonBottomSheet(
                  title: "Bạn có muốn xóa món ăn này không?",
                  textConfirm: 'Xóa',
                  textCancel: "Hủy",
                  textConfirmColor: context.colorScheme.errorContainer,
                  onConfirm: () => _handleDeleteFood(context, food)));
        });
  }

  void _handleDeleteFood(BuildContext context, Food food) {
    context.read<FoodBloc>().add(DeleteFood(foodID: food.id));
    showDialog(
        context: context,
        builder: (context) => BlocBuilder<FoodBloc, GenericBlocState<Food>>(
            builder: (context, state) => switch (state.status) {
                  Status.empty => const SizedBox(),
                  Status.loading => const ProgressDialog(
                      isProgressed: true, descriptrion: 'Đang xóa'),
                  Status.failure => RetryDialog(
                      title: state.error ?? "Lỗi",
                      onRetryPressed: () => context
                          .read<FoodBloc>()
                          .add(DeleteFood(foodID: food.id))),
                  Status.success => ProgressDialog(
                      descriptrion: 'Xóa thành công',
                      onPressed: () {
                        FToast()
                          ..init(context)
                          ..showToast(
                              child: AppAlerts.successToast(
                                  msg: 'Xóa thành công!'));
                        pop(context, 2);
                      },
                      isProgressed: false)
                }));
  }
}
