import 'package:admin_menu_mobile/features/search_food/cubit/text_search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_menu_mobile/config/router.dart';
import 'package:admin_menu_mobile/features/food/bloc/food_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:tiengviet/tiengviet.dart';
import '../../features/food/model/food_model.dart';
import '../../utils/utils.dart';
import '../../widgets/widgets.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<FoodScreen>
    with AutomaticKeepAliveClientMixin {
  var _isSearch = false;
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        floatingActionButton: _buildFloatingActionButton(),
        appBar: _buildAppbar(context),
        body: BlocBuilder<TextSearchCubit, String>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return SearchFoodView(textSearch: state);
            }));
  }

  @override
  bool get wantKeepAlive => true;

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        heroTag: 'addFood',
        backgroundColor: context.colorScheme.secondary,
        onPressed: () => context.push(RouteName.createFood),
        child: const Icon(Icons.add));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: _isSearch
            ? _buildSearch(context)
                .animate()
                .slideX(
                    begin: 0.3,
                    end: 0,
                    curve: Curves.easeInOutCubic,
                    duration: 500.ms)
                .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms)
            : AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                child: Text('Danh sách món',
                    style: context.titleStyleMedium!
                        .copyWith(fontWeight: FontWeight.bold))),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearch = !_isSearch;
                });
              },
              icon: Icon(
                  !_isSearch ? Icons.search : Icons.highlight_remove_sharp))
        ]);
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
  }
}

// _buildAppbar(BuildContext context) {
//   return EasySearchBar(
//       title: Text('Danh sách món',
//           style:
//               context.titleStyleMedium!.copyWith(fontWeight: FontWeight.bold)),
//       onSearch: (value) => context.read<TextSearchCubit>().textChanged(value));
// }

class SearchFoodView extends StatelessWidget {
  const SearchFoodView({super.key, required this.textSearch});

  final String textSearch;
  @override
  Widget build(BuildContext context) {
    return AfterSearchUI(text: textSearch)
        .animate()
        .slideX(
            begin: -0.1, end: 0, curve: Curves.easeInOutCubic, duration: 500.ms)
        .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms);
  }
}

class AfterSearchUI extends StatefulWidget {
  const AfterSearchUI({super.key, this.text});
  final String? text;

  @override
  State<AfterSearchUI> createState() => _AfterSearchUIState();
}

class _AfterSearchUIState extends State<AfterSearchUI> {
  @override
  Widget build(BuildContext context) {
    var text = widget.text;
    var loadingOrInitState = Center(
        child: SpinKitCircle(color: context.colorScheme.primary, size: 30));
    return BlocProvider(
        create: (context) => FoodBloc()..add(GetFoods()),
        child: BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
          return (switch (state.status) {
            FoodStatus.loading => loadingOrInitState,
            FoodStatus.initial => loadingOrInitState,
            FoodStatus.failure => Center(child: Text(state.error)),
            FoodStatus.success => _buildBody(state.foods, text!)
          });
        }));
  }

  _buildBody(List<Food> foods, String text) => ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: foods.length,
      itemBuilder: (context, i) {
        if (foods[i]
                .title
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            TiengViet.parse(foods[i].title.toString().toLowerCase())
                .contains(text.toLowerCase())) {
          return _buildItemSearch(context, foods[i]);
        }
        return const SizedBox();
      });

  Widget _buildItemSearch(BuildContext context, Food food) {
    return InkWell(
        onTap: () {
          context.push(RouteName.foodDetail, extra: food).then((value) {
            if (value is bool || value == true) {
              context.read<FoodBloc>().add(GetFoods());
            }
          });
        },
        child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding / 5),
            child: Card(
                borderOnForeground: false,
                child: SizedBox(
                    height: 80,
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

  Widget _buildImage(Food food) {
    return Container(
        margin: EdgeInsets.all(defaultPadding / 2),
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.3),
            image: DecorationImage(
                image: NetworkImage(food.image == null || food.image == ""
                    ? noImage
                    : food.image ?? ""),
                fit: food.isImageCrop == true ? BoxFit.cover : BoxFit.fill)));
  }

  Widget _buildCategory(BuildContext context, Food food) {
    return FittedBox(
        child: Text(food.category!, style: context.textStyleSmall!));
  }

  Widget _buildTitle(BuildContext context, Food food) {
    return FittedBox(
        child: Text(food.title!,
            style:
                context.textStyleSmall!.copyWith(fontWeight: FontWeight.bold)));
  }

  Widget _buildPrice(BuildContext context, Food food) {
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
                  style: context.textStyleSmall!.copyWith(
                      color: context.colorScheme.secondary,
                      fontWeight: FontWeight.bold))
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
