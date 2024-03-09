import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../common/bloc/generic_bloc_state.dart';
import '../../../../common/widget/empty_screen.dart';
import '../../../../common/widget/error_screen.dart';
import '../../../../common/widget/loading_screen.dart';
import '../../../../config/config.dart';
import '../../bloc/food_bloc.dart';
import 'item_food.dart';

class ListFoodDontShow extends StatefulWidget {
  const ListFoodDontShow({super.key, required this.textSearch});
  final String textSearch;
  @override
  State<ListFoodDontShow> createState() => _ListFoodDontShowState();
}

class _ListFoodDontShowState extends State<ListFoodDontShow>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
            create: (context) =>
                FoodBloc()..add(const FoodsFetched(isShowFood: false)),
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
    return RefreshIndicator.adaptive(
        child: (switch (foodIsShow.status) {
          Status.loading => const LoadingScreen(),
          Status.empty => const EmptyScreen(),
          Status.failure => ErrorScreen(errorMsg: foodIsShow.error),
          Status.success => ListView.builder(
              physics: const BouncingScrollPhysics(),
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
                      food: foodIsShow.datas![i],
                      onTap: () {
                        context
                            .push(RouteName.foodDetail,
                                extra: foodIsShow.datas![i])
                            .then((value) {
                          if (value is bool || value == true) {
                            context
                                .read<FoodBloc>()
                                .add(const FoodsFetched(isShowFood: false));
                          }
                        });
                      });
                }
                return const SizedBox();
              })
        }),
        onRefresh: () async => context
            .read<FoodBloc>()
            .add(const FoodsFetched(isShowFood: false)));
  }
}
