import 'package:admin_menu_mobile/features/food/bloc/food_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:food_repository/food_repository.dart';
import 'package:order_repository/order_repository.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class SearchFoodView extends StatelessWidget {
  const SearchFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
      Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: _buildSearch(context)),
      const Expanded(child: AfterSearchUI(text: ''))
    ]
            .animate(interval: 50.ms)
            .slideX(
                begin: -0.1,
                end: 0,
                curve: Curves.easeInOutCubic,
                duration: 400.ms)
            .fadeIn(curve: Curves.easeInOutCubic, duration: 400.ms));
  }

  Widget _buildSearch(BuildContext context) {
    return CommonTextField(
      onChanged: (value) {},
      hintText: "Tìm kiếm",
      suffixIcon: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // _.textValue.value = '';
            // controller.clear();

            // searchCtrl.saerchInitialize();
          }),
      prefixIcon: const Icon(Icons.search),
    );

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
          // Get.to(() => Featuredfood2Detail(food: food, id: food.id));
        },
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 2),
            child: SizedBox(
                height: 80,
                child: Stack(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        Expanded(
                          flex: 7,
                          child: Container(
                            padding: EdgeInsets.all(defaultPadding),
                            decoration: BoxDecoration(
                                color: context.colorScheme.primary,
                                borderRadius:
                                    BorderRadius.circular(defaultBorderRadius)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildTitle(context, food),
                                  _buildCategory(context, food),
                                  _buildPrice(context, food)
                                ]),
                          ),
                        ),
                        const Spacer(),
                      ]),

                  // color: Colors.red,
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: _buildImage(food)),
                        const Expanded(flex: 2, child: SizedBox()),
                        Expanded(child: _buildImage(food)),
                      ])
                ]))));
  }

  Widget _buildImage(FoodModel food) {
    return Hero(
        tag: 'hero-tag-${food.id}-search',
        child: Material(
            color: Colors.transparent,
            child: Container(
                margin: EdgeInsets.all(defaultPadding),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.3),
                    // borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(15),
                    //     bottomLeft: Radius.circular(15)),
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
    return Text(food.category!, style: context.textStyleSmall!);
  }

  Widget _buildTitle(BuildContext context, FoodModel food) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      CommonLineText(
          value: food.title,
          valueStyle:
              context.textStyleSmall!.copyWith(fontWeight: FontWeight.bold))
    ]);
  }

  Widget _buildPrice(BuildContext context, FoodModel food) {
    double discountAmount = (food.price! * food.discount!.toDouble()) / 100;
    double discountedPrice = food.price! - discountAmount;
    return food.isDiscount == false
        ? CommonLineText(
            valueStyle: context.textStyleSmall!.copyWith(
                color: context.colorScheme.secondaryContainer,
                fontWeight: FontWeight.bold),
            value: Ultils.currencyFormat(
              double.parse(food.price.toString()),
            ))
        : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              CommonLineText(
                  value: Ultils.currencyFormat(
                      double.parse(food.price.toString())),
                  valueStyle: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 3.0,
                      decorationColor: Colors.red,
                      decorationStyle: TextDecorationStyle.solid,
                      // fontSize: defaultSizeText,
                      color: Color.fromARGB(255, 131, 128, 126),
                      fontWeight: FontWeight.w700)),
              const SizedBox(width: 10.0),
              CommonLineText(
                value: Ultils.currencyFormat(
                    double.parse(discountedPrice.toString())),
                valueStyle: context.textStyleSmall!
                    .copyWith(color: context.colorScheme.secondaryContainer),
              )
            ])
          ]);
  }

  Widget _buildPercentDiscount(Food food) {
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
