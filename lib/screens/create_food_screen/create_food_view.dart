import 'dart:io';
import 'package:admin_menu_mobile/features/category/bloc/category_bloc.dart';
import 'package:admin_menu_mobile/features/category/dtos/category_model.dart';
import 'package:admin_menu_mobile/features/food/bloc/food_bloc.dart';
import 'package:admin_menu_mobile/widgets/common_text_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:admin_menu_mobile/utils/contants.dart';
import 'package:admin_menu_mobile/utils/extensions.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CreateFoodView extends StatelessWidget {
  const CreateFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: context.sizeDevice.height,
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
                      _NameFood(),
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
                      _Description(),
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
                      _Discount(),
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
                            curve: Curves.easeInOutCubic, duration: 500.ms)))));
  }
}

class _ButtonCreateFood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
      return state.isValid
          ? Center(
              child: FilledButton.icon(
                  icon: const Icon(Icons.library_add_rounded),
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green)),
                  onPressed: () {},
                  label: Text('Xác nhận thêm món',
                      style: context.textStyleMedium)))
          : Center(
              child: Text("Vui lòng nhập đầy đủ thông tin",
                  style: context.textStyleSmall));
    });
  }
}

class _Discount extends StatelessWidget {
  final TextEditingController _discountController = TextEditingController();
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
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBloc, FoodState>(
      builder: (context, state) {
        return CommonTextField(
            prefixIcon: const Icon(Icons.food_bank_rounded),
            hintText: 'Tên món ăn',
            controller: _nameController,
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
    success(List<CategoryModel> categories, String category) {
      context
          .read<FoodBloc>()
          .add(CategoryFoodChanged(category: categories.first.name!));
      return Container(
          height: 60,
          decoration: BoxDecoration(
              // color: secondaryColor,
              borderRadius: BorderRadius.circular(defaultBorderRadius),
              border: Border.all(color: context.colorScheme.primary, width: 1)),
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          alignment: Alignment.center,
          child: DropdownButton(
              borderRadius: BorderRadius.circular(defaultBorderRadius),
              // dropdownColor: context.colorScheme.primary,
              value: category,
              underline: Container(),
              isDense: true,
              style: context.textStyleSmall,
              icon: const Icon(Icons.arrow_drop_down),
              isExpanded: true,
              items: categories.map((e) {
                return DropdownMenuItem(
                    value: e.name,
                    child:
                        Text(e.name.toString(), style: context.textStyleSmall));
              }).toList(),
              onChanged: (String? newValue) {
                context
                    .read<FoodBloc>()
                    .add(CategoryFoodChanged(category: newValue!));
                context
                    .read<CategoryBloc>()
                    .add(CategoryChanged(category: newValue));
              }));
    }

    var loadingOrInitState = Center(
        child: SpinKitCircle(color: context.colorScheme.primary, size: 30));
    return BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
      return (switch (state.status) {
        CategoryStatus.loading => loadingOrInitState,
        CategoryStatus.initial => loadingOrInitState,
        CategoryStatus.failure => Center(child: Text(state.errorMessage)),
        CategoryStatus.success => success(state.categories, state.category)
      });
    });
  }
}

class _Description extends StatelessWidget {
  _Description();
  final TextEditingController _disController = TextEditingController();
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
