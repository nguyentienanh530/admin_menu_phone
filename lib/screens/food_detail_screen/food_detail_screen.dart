import 'package:admin_menu_mobile/features/food/bloc/food_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/food/data/food_model.dart';
import '../../utils/utils.dart';
import 'food_detail_view.dart';

class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key, this.food});
  final FoodModel? food;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodBloc()..add(GetFoodByID(idFood: food!.id!)),
      child: Scaffold(
          appBar: _buildAppbar(context), body: FoodDetailView(food: food!)),
    );
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text(AppText.titleFoodDetail,
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true);
  }
}
