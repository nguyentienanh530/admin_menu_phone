import 'package:admin_menu_mobile/features/food/data/food_model.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:readmore/readmore.dart';

import '../../widgets/widgets.dart';

class FoodDetailView extends StatelessWidget {
  const FoodDetailView({super.key, required this.food});
  final FoodModel food;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ImageFood(food: food),
                    _buildTitle(context, food),
                    _buildPrice(context, food),
                    _buildDescription(context, food),
                    food.photoGallery != null
                        ? _Gallery(food: food)
                        : const SizedBox()
                  ]
                      .animate(interval: 50.ms)
                      .slideX(
                          begin: -0.1,
                          end: 0,
                          curve: Curves.easeInOutCubic,
                          duration: 500.ms)
                      .fadeIn(
                          curve: Curves.easeInOutCubic, duration: 500.ms)))),
      Container(
          padding: EdgeInsets.all(defaultPadding),
          height: 150,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildUpdateFood(context, food),
                _buildDeleteFood(context, food)
              ]))
    ]);
  }

  Widget _buildDeleteFood(BuildContext context, FoodModel food) {
    return InkWell(
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                  height: 200,
                  child: CommonBottomSheet(
                      title: "Bạn có muốn xóa món ăn này không?",
                      textConfirm: 'Xóa',
                      textCancel: "Hủy",
                      onCancel: () {
                        context.pop();
                      },
                      onConfirm: () {
                        // deleteDoc();
                      }));
            },
          );
        },
        child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                color: context.colorScheme.error),
            child: Center(
                child: Text("Xoá món ăn", style: context.textStyleMedium))));
  }

  Widget _buildUpdateFood(BuildContext context, FoodModel food) {
    return InkWell(
        onTap: () {
          // Navigator.of(context).push(PageRouteBuilder(
          //     pageBuilder: (_, __, ___) =>
          //         UpdateFoodDetailScreen(food: widget.food, id: widget.id)));
        },
        child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                color: context.colorScheme.primary),
            child: Center(
                child:
                    Text("Cập nhật món ăn", style: context.textStyleMedium))));
  }

  Widget _buildDescription(BuildContext context, FoodModel food) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Description',
              style: context.titleStyleMedium!
                  .copyWith(fontWeight: FontWeight.bold)),
          ReadMoreText(food.description ?? "",
              trimLines: 8,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Xem thêm...',
              trimExpandedText: 'ẩn bớt',
              style: context.textStyleSmall,
              lessStyle: context.textStyleSmall!
                  .copyWith(color: context.colorScheme.secondary),
              moreStyle: context.textStyleSmall!
                  .copyWith(color: context.colorScheme.secondary))
        ]));
  }

  Widget _buildTitle(BuildContext context, FoodModel food) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        child: Text(food.title!,
            style:
                context.textStyleLarge!.copyWith(fontWeight: FontWeight.bold)));
  }

  Widget _buildPrice(BuildContext context, FoodModel food) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding / 2),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(Ultils.currencyFormat(double.parse(food.price.toString())),
              style: context.textStyleLarge!.copyWith(
                  color: context.colorScheme.secondary,
                  fontWeight: FontWeight.bold))
        ]));
  }
}

class _ImageFood extends StatelessWidget {
  const _ImageFood({required this.food});
  final FoodModel food;
  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: 'hero-tag-${food.id}-search',
        child: Material(
            child: Container(
                height: context.sizeDevice.height * 0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: context.colorScheme.background,
                    // borderRadius:
                    //     BorderRadius.vertical(bottom: Radius.circular(22 )),
                    image: DecorationImage(
                        image: NetworkImage(
                            food.image == null || food.image == ""
                                ? noImage
                                : food.image ?? ""),
                        fit: BoxFit.cover)),
                alignment: Alignment.topCenter)));
  }
}

class _Gallery extends StatelessWidget {
  const _Gallery({required this.food});
  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding / 2),
          child: Text('Gallery', style: context.titleStyleLarge)),
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding / 2),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: _buildImage(context, food.photoGallery![0])),
            SizedBox(width: defaultPadding / 2),
            Expanded(child: _buildImage(context, food.photoGallery![1])),
            SizedBox(width: defaultPadding / 2),
            Expanded(child: _buildImage(context, food.photoGallery![2]))
          ]))
    ]);
  }

  Widget _buildImage(BuildContext context, String item) {
    return InkWell(
        onTap: () {
          viewImage(context, item);
        },
        child: Container(
            height: context.sizeDevice.height * 0.15,
            width: context.sizeDevice.width / 3.8,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                image: DecorationImage(
                    image: NetworkImage(item), fit: BoxFit.cover),
                color: Colors.transparent,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 5.0,
                      color: Colors.black12.withOpacity(0.1),
                      spreadRadius: 2.0)
                ])));
  }

  viewImage(BuildContext context, String item) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return Material(
              clipBehavior: Clip.antiAlias,
              elevation: 18.0,
              color: context.colorScheme.background,
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Container(
                        height: context.sizeDevice.width * 0.9,
                        width: context.sizeDevice.width * 0.9,
                        decoration: BoxDecoration(
                            color: kRedColor,
                            borderRadius:
                                BorderRadius.circular(defaultBorderRadius),
                            image: DecorationImage(
                                fit: BoxFit.cover, image: NetworkImage(item)))),
                    IconButton(
                        iconSize: 30,
                        onPressed: () {
                          context.pop();
                        },
                        icon: const Icon(Icons.highlight_remove_sharp),
                        color: context.colorScheme.secondaryContainer)
                  ])));
        },
        transitionDuration: const Duration(milliseconds: 500)));
  }
}
