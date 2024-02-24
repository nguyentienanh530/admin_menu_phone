import 'package:admin_menu_mobile/features/category/bloc/category_bloc.dart';
import 'package:admin_menu_mobile/features/food/bloc/food_bloc.dart';
import 'package:admin_menu_mobile/features/food/data/food_model.dart';
import 'package:admin_menu_mobile/screens/update_food_screen/update_food_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/utils.dart';

class UpdateFoodScreen extends StatelessWidget {
  const UpdateFoodScreen({super.key, required this.foodModel});
  final FoodModel foodModel;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => CategoryBloc()..add(FetchCategories())),
          BlocProvider(
              create: (context) =>
                  FoodBloc()..add(GetFoodByID(idFood: foodModel.id!))),
        ],
        child: Scaffold(
            appBar: _buildAppbar(context),
            body: UpdateFoodView(foodModel: foodModel)));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text('Cập nhật món ăn',
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true);
  }
}
