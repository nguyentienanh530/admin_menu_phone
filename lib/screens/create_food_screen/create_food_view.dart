// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_menu_mobile/features/category/bloc/category_bloc.dart';
import 'package:admin_menu_mobile/features/food/bloc/food_bloc.dart';
import 'package:admin_menu_mobile/utils/app_alerts.dart';
import 'package:admin_menu_mobile/widgets/common_text_field.dart';

import '../../utils/utils.dart';

class CreateFoodView extends StatelessWidget {
  CreateFoodView({super.key});
  final TextEditingController _disController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  void reset() {
    _disController.clear();
    _nameController.clear();
    _priceCtrl.clear();
    _discountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: context.sizeDevice.height,
        child: BlocListener<FoodBloc, FoodState>(
          listener: (context, state) {
            switch (state.status) {
              case FoodStatus.loading:
                AppAlerts.loadingDialog(context);
                break;
              case FoodStatus.failure:
                AppAlerts.failureDialog(context,
                    title: AppText.errorTitle,
                    desc: state.error, btnCancelOnPress: () {
                  // context.read<LoginCubit>().resetStatus();
                  context.pop();
                  context.pop();
                });
                break;
              case FoodStatus.success:
                AppAlerts.successDialog(context,
                    title: AppText.success,
                    desc: 'Tạo món thành công', btnOkOnPress: () {
                  context.read<FoodBloc>().add(ResetData());
                  reset();
                  context.pop();
                  context.pop();
                });
                break;
              default:
            }
          },
          child: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _ImageFood(),
                        SizedBox(height: defaultPadding / 2),
                        Text("Tên món ăn:",
                            style: context.textStyleMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: defaultPadding / 2),
                        _NameFood(nameController: _nameController),
                        SizedBox(height: defaultPadding / 2),
                        Text("Gía bán:",
                            style: context.textStyleMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: defaultPadding / 2),
                        _PriceFood(priceCtrl: _priceCtrl),
                        SizedBox(height: defaultPadding / 2),
                        Text("Danh mục:",
                            style: context.textStyleMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: defaultPadding / 2),
                        const _Categories(),
                        SizedBox(height: defaultPadding / 2),
                        Text("Mô tả chi tiết:",
                            style: context.textStyleMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: defaultPadding / 2),
                        _Description(_disController),
                        SizedBox(height: defaultPadding / 2),
                        Text("Album hình ảnh:",
                            style: context.textStyleMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: defaultPadding / 2),
                        _PhotoGallery(),
                        SizedBox(height: defaultPadding / 2),
                        Text("Áp dụng khuyến mãi ?",
                            style: context.textStyleMedium!
                                .copyWith(fontWeight: FontWeight.bold)),
                        SizedBox(height: defaultPadding / 2),
                        _Discount(_discountController),
                        SizedBox(height: defaultPadding / 2),
                        _ButtonCreateFood()
                      ]
                          .animate(interval: 50.ms)
                          .slideX(
                              begin: -0.1,
                              end: 0,
                              curve: Curves.easeInOutCubic,
                              duration: 500.ms)
                          .fadeIn(
                              curve: Curves.easeInOutCubic,
                              duration: 500.ms)))),
        ));
  }
}

class _PriceFood extends StatelessWidget {
  final TextEditingController priceCtrl;

  const _PriceFood({required this.priceCtrl});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
      return CommonTextField(
          prefixIcon: const Icon(Icons.price_change_outlined),
          hintText: 'Giá bán',
          controller: priceCtrl,
          keyboardType: TextInputType.number,
          errorText: state.priceFood.displayError != null
              ? 'Giá bán không hợp lệ'
              : null,
          onChanged: (text) =>
              context.read<FoodBloc>().add(PriceFoodChanged(priceFood: text)));
    });
  }
}

class _ButtonCreateFood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
      return state.isValid &&
              state.imageFile != null &&
              state.imageGallery1 != null &&
              state.imageGallery2 != null &&
              state.imageGallery3 != null
          ? Center(
              child: FilledButton.icon(
                  icon: const Icon(Icons.library_add_rounded),
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                  onPressed: () async {
                    context.read<FoodBloc>().add(SubmitCreateFood());
                  },
                  label: Text('Xác nhận thêm món',
                      style: context.textStyleMedium)))
          : Center(
              child: Text("Vui lòng nhập đầy đủ thông tin",
                  style: context.textStyleSmall));
    });
  }
}

class _Discount extends StatelessWidget {
  final TextEditingController _discountController;

  const _Discount(this._discountController);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
      return Column(children: [
        _buildDiscount(context, state.isDiscount),
        SizedBox(height: defaultPadding / 2),
        state.isDiscount
            ? _buildTextFeildDiscount(context, state)
            : const SizedBox()
      ]);
    });
  }

  Widget _buildDiscount(BuildContext context, bool isDiscount) {
    return Row(children: [
      Radio<bool>(
          value: true,
          groupValue: isDiscount,
          activeColor: context.colorScheme.secondary,
          onChanged: (value) => context
              .read<FoodBloc>()
              .add(IsDiscountFoodChanged(isDiscount: value!))),
      Text('Áp dụng', style: context.textStyleSmall),
      Radio<bool>(
          value: false,
          activeColor: context.colorScheme.secondary,
          groupValue: isDiscount,
          onChanged: (value) => context
              .read<FoodBloc>()
              .add(IsDiscountFoodChanged(isDiscount: value!))),
      Text('Không áp dụng', style: context.textStyleSmall)
    ]);
  }

  Widget _buildTextFeildDiscount(BuildContext context, FoodState state) {
    var discount = state.discount.isValid ? int.parse(state.discount.value) : 0;
    return CommonTextField(
        prefixIcon: const Icon(Icons.discount_rounded),
        controller: _discountController,
        hintText: 'Giá khuyến mãi (0%-100%)',
        keyboardType: TextInputType.number,
        errorText: discount > 100 || state.discount.displayError != null
            ? 'Khuyễn mãi không hợp lệ'
            : null,
        onChanged: (value) =>
            context.read<FoodBloc>().add(DiscountFoodChanged(discount: value)));
  }
}

class _PhotoGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
      return Row(children: [
        Expanded(
            child: _buildImageGallery(
                context: context,
                imageFile: state.imageGallery1,
                onTap: () =>
                    context.read<FoodBloc>().add(PickImageFoodGallery1()))),
        SizedBox(width: defaultPadding / 2),
        Expanded(
            child: _buildImageGallery(
                context: context,
                imageFile: state.imageGallery2,
                onTap: () =>
                    context.read<FoodBloc>().add(PickImageFoodGallery2()))),
        SizedBox(width: defaultPadding / 2),
        Expanded(
            child: _buildImageGallery(
                context: context,
                imageFile: state.imageGallery3,
                onTap: () =>
                    context.read<FoodBloc>().add(PickImageFoodGallery3())))
      ]);
    });
  }

  Widget _buildImageGallery(
      {required BuildContext context, File? imageFile, Function()? onTap}) {
    return GestureDetector(
        onTap: onTap,
        child: imageFile == null
            ? Container(
                height: context.sizeDevice.height * 0.15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius)),
                child: DottedBorder(
                    dashPattern: const [6, 6],
                    color: context.colorScheme.secondary,
                    strokeWidth: 1,
                    padding: EdgeInsets.all(defaultPadding),
                    radius: Radius.circular(defaultBorderRadius),
                    borderType: BorderType.RRect,
                    child: Center(
                        child: Icon(Icons.add,
                            size: 40, color: context.colorScheme.secondary))))
            : Container(
                height: context.sizeDevice.height * 0.15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    image: DecorationImage(
                        image: FileImage(imageFile), fit: BoxFit.fill))));
  }
}

class _ImageFood extends StatelessWidget {
  const _ImageFood({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(
        buildWhen: (previous, current) =>
            previous.imageFile != current.imageFile,
        builder: (context, state) {
          logger.d(state.imageFile);

          return GestureDetector(
              onTap: () {
                context.read<FoodBloc>().add(PickImageFood());
              },
              child: state.imageFile == null
                  ? Container(
                      height: 155,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadius)),
                      child: DottedBorder(
                          dashPattern: const [6, 6],
                          color: context.colorScheme.secondary,
                          strokeWidth: 1,
                          radius: Radius.circular(defaultBorderRadius),
                          borderType: BorderType.RRect,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                        height: 48,
                                        width: 48,
                                        decoration: BoxDecoration(
                                            color: context.colorScheme.primary,
                                            border: Border.all(
                                                color:
                                                    context.colorScheme.primary,
                                                width: 1),
                                            borderRadius: BorderRadius.circular(
                                                defaultBorderRadius)),
                                        child: Icon(Icons.add,
                                            color: context
                                                .colorScheme.secondary))),
                                SizedBox(height: defaultPadding / 2),
                                Text("Hình ảnh món ăn",
                                    style: context.textStyleSmall)
                              ])))
                  : Container(
                      height: 155,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(defaultBorderRadius),
                          image: DecorationImage(
                              image: FileImage(state.imageFile!),
                              fit: BoxFit.cover)),
                    ));
        });
  }
}

class _NameFood extends StatelessWidget {
  final TextEditingController nameController;

  const _NameFood({required this.nameController});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(
      builder: (context, state) {
        return CommonTextField(
            prefixIcon: const Icon(Icons.food_bank_rounded),
            hintText: 'Tên món ăn',
            controller: nameController,
            errorText: state.nameFood.displayError != null
                ? 'Tên món không được để trống'
                : null,
            onChanged: (text) =>
                context.read<FoodBloc>().add(NameFoodChanged(nameFood: text)));
      },
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories();

  @override
  Widget build(BuildContext context) {
    var categoryState = context.watch<CategoryBloc>().state;
    var category = context.watch<FoodBloc>().state;
    return Wrap(
        spacing: 4.0,
        runSpacing: 2.0,
        children: categoryState.categories
            .map((e) => SizedBox(
                height: 25,
                child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            category.category == e.name
                                ? context.colorScheme.errorContainer
                                : context.colorScheme.primaryContainer)),
                    onPressed: () {
                      context
                          .read<FoodBloc>()
                          .add(CategoryFoodChanged(category: e.name!));
                      context
                          .read<CategoryBloc>()
                          .add(CategoryChanged(category: e.name!));
                    },
                    child: Text(e.name!, style: context.textStyleSmall))))
            .toList());
  }
}

class _Description extends StatelessWidget {
  const _Description(this._disController);
  final TextEditingController _disController;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
      return CommonTextField(
          prefixIcon: const Icon(Icons.description_outlined),
          hintText: "Nhập thông tin",
          controller: _disController,
          errorText: state.description.displayError != null
              ? 'Mô tả không được để trống'
              : null,
          onChanged: (text) => context
              .read<FoodBloc>()
              .add(DescriptionFoodChanged(description: text)));
    });
  }
}
