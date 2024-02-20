import 'package:admin_menu_mobile/config/router.dart';
import 'package:admin_menu_mobile/features/food/bloc/food_bloc.dart';
import 'package:admin_menu_mobile/features/order/dtos/food_dto.dart';
import 'package:admin_menu_mobile/features/search_food/cubit/text_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../features/food/data/food_model.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class AddFoodView extends StatelessWidget {
  AddFoodView({super.key});
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
      Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: _buildSearch(context)),
      Expanded(child:
          BlocBuilder<TextSearchCubit, String>(builder: (context, state) {
        return AfterSearchUI(text: state);
      }))
    ]
            .animate(interval: 50.ms)
            .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 500.ms)
            .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms));
  }

  Widget _buildSearch(BuildContext context) {
    return CommonTextField(
        controller: _searchController,
        onChanged: (value) =>
            context.read<TextSearchCubit>().textChanged(value),
        hintText: "Tìm kiếm",
        suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              context.read<TextSearchCubit>().clear();
              _searchController.clear();
            }),
        prefixIcon: const Icon(Icons.search));

    // TextFormField(
    //     // controller: controller,
    //     onChanged: (value) {
    //       // _.textValue.value = value;

    //       // context.read<SearchBloc>().setSearchText(value);
    //       // context.read<SearchBloc>().getData();
    //     },
    //     style: context.textStyleSmall,
    //     decoration: InputDecoration(
    //         border: InputBorder.none,
    //         prefixIcon: const Icon(Icons.search),
    //         hintText: "Tìm kiếm",
    //         hintStyle: context.textStyleSmall,
    //         suffixIcon: IconButton(
    //             icon: const Icon(Icons.close),
    //             onPressed: () {
    //               // _.textValue.value = '';
    //               // controller.clear();

    //               // searchCtrl.saerchInitialize();
    //             })),
    //     textInputAction: TextInputAction.search,
    //     onFieldSubmitted: (value) {
    //       if (value == '') {
    //         // Get.snackbar('Thông báo', 'trống').show();
    //       } else {
    //         // searchCtrl.setSearchText(value);
    //         // context
    //         //     .read<SearchBloc>()
    //         //     .addToSearchList(value);
    //         // context.read<SearchBloc>().getData();
    //       }
    //     });
  }
}

class AfterSearchUI extends StatelessWidget {
  final String? text;

  const AfterSearchUI({super.key, this.text});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => FoodBloc()..add(GetFoods()),
        child: BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
          switch (state) {
            case FoodInProgress():
              return Center(
                  child: SpinKitCircle(
                      color: context.colorScheme.primary, size: 30));

            case FoodFailue():
              return Center(child: Text(state.error));

            case FoodSuccess():
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.foods.length,
                  itemBuilder: (context, i) {
                    if (state.foods[i].title
                            .toString()
                            .toLowerCase()
                            .contains(text!.toLowerCase()) ||
                        TiengViet.parse(
                                state.foods[i].title.toString().toLowerCase())
                            .contains(text!.toLowerCase())) {
                      return _buildItemSearch(context, state.foods[i]);
                    }
                    return const SizedBox();
                  });
            case FoodInitial():
              return Center(
                  child: SpinKitCircle(
                      color: context.colorScheme.primary, size: 30));
          }
        }));
  }

  Widget _buildItemSearch(BuildContext context, FoodModel food) {
    return InkWell(
        onTap: () {
          context.pop<FoodModel>(food);
        },
        child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 1),
            child: Card(
                borderOnForeground: false,
                child: SizedBox(
                    height: 45,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildImage(food),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildTitle(context, food),
                                // _buildCategory(context, food),
                                _buildPrice(context, food)
                              ])
                        ]
                            .animate(interval: 50.ms)
                            .slideX(
                                begin: -0.1,
                                end: 0,
                                curve: Curves.easeInOutCubic,
                                duration: 500.ms)
                            .fadeIn(
                                curve: Curves.easeInOutCubic,
                                duration: 500.ms))))));
  }

  Widget _buildImage(FoodModel food) {
    return Hero(
        tag: 'hero-tag-${food.id}-search',
        child: Material(
            color: Colors.transparent,
            child: Container(
                margin: EdgeInsets.all(defaultPadding / 3),
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.3),
                    image: DecorationImage(
                        image: NetworkImage(
                            food.image == null || food.image == ""
                                ? noImage
                                : food.image ?? ""),
                        fit: food.isImageCrop == true
                            ? BoxFit.cover
                            : BoxFit.fill)))));
  }

  Widget _buildCategory(BuildContext context, FoodModel food) {
    return FittedBox(
        child: Text(food.category!, style: context.textStyleSmall!));
  }

  Widget _buildTitle(BuildContext context, FoodModel food) {
    return FittedBox(
        child: Text(food.title!,
            style:
                context.textStyleSmall!.copyWith(fontWeight: FontWeight.bold)));
  }

  Widget _buildPrice(BuildContext context, FoodModel food) {
    double discountAmount = (food.price! * food.discount!.toDouble()) / 100;
    double discountedPrice = food.price! - discountAmount;
    return food.isDiscount == false
        ? Text(Ultils.currencyFormat(double.parse(food.price.toString())),
            style: context.textStyleSmall!.copyWith(
                color: context.colorScheme.secondary,
                fontWeight: FontWeight.bold))
        : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Text(Ultils.currencyFormat(double.parse(food.price.toString())),
                  style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 3.0,
                      decorationColor: Colors.red,
                      decorationStyle: TextDecorationStyle.solid,
                      // fontSize: defaultSizeText,
                      color: Color.fromARGB(255, 131, 128, 126),
                      fontWeight: FontWeight.w700)),
              const SizedBox(width: 10.0),
              Text(
                  Ultils.currencyFormat(
                      double.parse(discountedPrice.toString())),
                  style: context.textStyleSmall!
                      .copyWith(color: context.colorScheme.tertiaryContainer))
            ])
          ]);
  }

  Widget _buildPercentDiscount(FoodModel food) {
    return Container(
        height: 80,
        width: 80,
        // decoration: BoxDecoration(color: redColor),
        child: Center(child: CommonLineText(value: "${food.discount}%")

            // Text("${food.discount}%",
            //     style: TextStyle(
            //         fontSize: 16,
            //         color: textColor,
            //         fontFamily: Constant.font,
            //         fontWeight: FontWeight.w600)))
            ));
  }
}
