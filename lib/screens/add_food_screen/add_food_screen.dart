import 'package:admin_menu_mobile/features/search_food/cubit/text_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/utils.dart';
import 'add_food_view.dart';

class AddFoodScreen extends StatelessWidget {
  const AddFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: context.colorScheme.background,
        appBar: _buildAppbar(context),
        body: BlocProvider(
            create: (context) => TextSearchCubit(), child: AddFoodView()));
  }
}

_buildAppbar(BuildContext context) {
  return AppBar(
      title: Text(AppText.searchFood,
          style:
              context.titleStyleMedium!.copyWith(fontWeight: FontWeight.bold)),
      centerTitle: true);
}
