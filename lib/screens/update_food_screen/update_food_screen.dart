import 'package:admin_menu_mobile/features/category/bloc/category_bloc.dart';
import 'package:admin_menu_mobile/features/food/model/food_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/utils.dart';
import 'update_food_view.dart';

class UpdateFoodScreen extends StatelessWidget {
  const UpdateFoodScreen({super.key, required this.food, required this.mode});
  final Food food;
  final Mode mode;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => CategoryBloc()..add(FetchCategories())),
        ],
        child: Scaffold(
            appBar: _buildAppbar(context),
            body: UpdateFoodView(food: food, mode: mode)));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text('Cập nhật món ăn',
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true);
  }
}
