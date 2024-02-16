import 'package:admin_menu_mobile/features/search_food/cubit/text_search_cubit.dart';
import 'package:admin_menu_mobile/screens/search_food_screen/search_food_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/utils.dart';

class SearchFoodScreen extends StatelessWidget {
  const SearchFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: context.colorScheme.background,
        appBar: _buildAppbar(context),
        body: BlocProvider(
            create: (context) => TextSearchCubit(), child: SearchFoodView()));
  }
}

_buildAppbar(BuildContext context) {
  return AppBar(
      title: Text(AppText.searchFood,
          style:
              context.titleStyleMedium!.copyWith(fontWeight: FontWeight.bold)),
      centerTitle: true);
}
