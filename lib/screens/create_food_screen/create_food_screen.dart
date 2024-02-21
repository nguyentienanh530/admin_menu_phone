import 'package:admin_menu_mobile/features/category/bloc/category_bloc.dart';
import 'package:admin_menu_mobile/features/food/bloc/food_bloc.dart';
import 'package:admin_menu_mobile/screens/create_food_screen/create_food_view.dart';
import 'package:admin_menu_mobile/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateFoodScreen extends StatefulWidget {
  const CreateFoodScreen({super.key});

  @override
  State<CreateFoodScreen> createState() => _CreateFoodScreenState();
}

class _CreateFoodScreenState extends State<CreateFoodScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FoodBloc()),
        BlocProvider(
            create: (context) => CategoryBloc()..add(FetchCategories()))
      ],
      child: Scaffold(appBar: _buildAppbar(context), body: CreateFoodView()),
    );
  }

  _buildAppbar(BuildContext context) => AppBar(
      centerTitle: true,
      title: Text("Khởi tạo món ăn", style: context.textStyleMedium));
  @override
  bool get wantKeepAlive => true;
}
