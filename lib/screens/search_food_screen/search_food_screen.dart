import 'package:admin_menu_mobile/screens/search_food_screen/search_food_view.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class SearchFoodScreen extends StatelessWidget {
  const SearchFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(context),
      body: const SearchFoodView(),
    );
  }
}

_buildAppbar(BuildContext context) {
  return AppBar(
      title: Text(AppText.searchFood,
          style:
              context.titleStyleMedium!.copyWith(fontWeight: FontWeight.bold)),
      centerTitle: true);
}
