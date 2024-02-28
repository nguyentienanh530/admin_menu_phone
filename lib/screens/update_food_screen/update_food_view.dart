import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_menu_mobile/features/food/model/food_model.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import '../../features/category/bloc/category_bloc.dart';
import '../../features/food/bloc/food_bloc.dart';
import '../../widgets/widgets.dart';

class UpdateFoodView extends StatefulWidget {
  const UpdateFoodView({super.key, required this.food, required this.mode});
  final Food food;
  final Mode mode;
  @override
  State<UpdateFoodView> createState() => _UpdateFoodViewState();
}

class _UpdateFoodViewState extends State<UpdateFoodView> {
  final TextEditingController _disController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  var _image = '';
  var _imageFile, _imageFile1, _imageFile2, _imageFile3;
  var _category = '';
  var _imageGallery1 = '';
  var _imageGallery2 = '';
  var _imageGallery3 = '';
  var _isDiscount = false;
  // var _discount = '';

  @override
  void initState() {
    initData();
    super.initState();
  }

  void initData() {
    if (!mounted) return;
    if (widget.mode == Mode.update) {
      _disController.text = widget.food.description ?? '';
      _nameController.text = widget.food.title ?? '';
      _priceCtrl.text = widget.food.price.toString();
      _discountController.text = widget.food.discount.toString();
      _image = widget.food.image ?? '';
      _category = widget.food.category ?? '';
      if (widget.food.photoGallery != null &&
          widget.food.photoGallery!.isNotEmpty) {
        _imageGallery1 = widget.food.photoGallery?[0] ?? '';
        _imageGallery2 = widget.food.photoGallery?[1] ?? '';
        _imageGallery3 = widget.food.photoGallery?[2] ?? '';
      }
      _isDiscount = widget.food.isDiscount ?? false;
    }
  }

  Future pickImage() async {
    final imagePicker = ImagePicker();
    var imagepicked = await imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (imagepicked != null) {
      setState(() {
        _imageFile = File(imagepicked.path);
      });
    } else {
      logger.d('No image selected!');
    }
  }

  Widget onSuccess(Food food) {
    return Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ImageFood(image: _image, imageFile: _imageFile),
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
                  _Categories(category: _category),
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
                  _PhotoGallery(
                      image1: _imageGallery1,
                      image2: _imageGallery2,
                      image3: _imageGallery3,
                      imageGallery1: _imageFile1,
                      imageGallery2: _imageFile2,
                      imageGallery3: _imageFile3),
                  SizedBox(height: defaultPadding / 2),
                  Text("Áp dụng khuyến mãi ?",
                      style: context.textStyleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: defaultPadding / 2),
                  _Discount(
                      discountController: _discountController,
                      isDiscount: _isDiscount),
                  SizedBox(height: defaultPadding / 2),
                  _ButtonCreateFood(idFood: food.id!)
                ]
                    .animate(interval: 50.ms)
                    .slideX(
                        begin: -0.1,
                        end: 0,
                        curve: Curves.easeInOutCubic,
                        duration: 500.ms)
                    .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms))));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: context.sizeDevice.height, child: onSuccess(widget.food));
  }
}

class _PriceFood extends StatelessWidget {
  final TextEditingController priceCtrl;

  const _PriceFood({required this.priceCtrl});

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        prefixIcon: const Icon(Icons.price_change_outlined),
        hintText: 'Giá bán',
        controller: priceCtrl,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isEmpty || value.contains(RegExp(r'^[0-9]+$'))) {
            return 'Giá không hợp lệ';
          }
          return null;
        },
        onChanged: (text) =>
            context.read<FoodBloc>().add(PriceFoodChanged(priceFood: text)));
  }
}

class _ButtonCreateFood extends StatelessWidget {
  final String idFood;

  const _ButtonCreateFood({required this.idFood});
  @override
  Widget build(BuildContext context) {
    var state = context.watch<FoodBloc>().state;

    return state.isValid && state.imageFood != ''
        // state.imageFood1 != '' &&
        // state.imageFood2 != '' &&
        // state.imageFood3 != ''
        ? Center(
            child: FilledButton.icon(
                icon: const Icon(Icons.update),
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green)),
                onPressed: () async {
                  context.read<FoodBloc>().add(UpdateFood(idFood: idFood));
                },
                label: Text('Cập nhật món', style: context.textStyleMedium)))
        : Center(
            child: Text("Vui lòng nhập đầy đủ thông tin",
                style: context.textStyleSmall));
  }
}

class _Discount extends StatelessWidget {
  final TextEditingController discountController;
  final bool isDiscount;
  const _Discount({required this.discountController, required this.isDiscount});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildDiscount(context),
      SizedBox(height: defaultPadding / 2),
      isDiscount ? _buildTextFeildDiscount(context) : const SizedBox()
    ]);
  }

  Widget _buildDiscount(BuildContext context) {
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

  Widget _buildTextFeildDiscount(BuildContext context) {
    return CommonTextField(
        prefixIcon: const Icon(Icons.discount_rounded),
        controller: discountController,
        hintText: 'Giá khuyến mãi (0%-100%)',
        keyboardType: TextInputType.number,
        // errorText: discount > 100 || state.discount.displayError != null
        //     ? 'Khuyễn mãi không hợp lệ'
        //     : null,
        onChanged: (value) =>
            context.read<FoodBloc>().add(DiscountFoodChanged(discount: value)));
  }
}

class _PhotoGallery extends StatelessWidget {
  final String image1, image2, image3;
  final dynamic imageGallery1, imageGallery2, imageGallery3;
  const _PhotoGallery(
      {required this.image1,
      required this.image2,
      required this.image3,
      required this.imageGallery1,
      required this.imageGallery2,
      required this.imageGallery3});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: _buildImageGallery(
              context: context,
              imageFile: imageGallery1,
              image: image1,
              onTap: () =>
                  context.read<FoodBloc>().add(PickImageFoodGallery1()))),
      SizedBox(width: defaultPadding / 2),
      Expanded(
          child: _buildImageGallery(
              context: context,
              imageFile: imageGallery2,
              image: image2,
              onTap: () =>
                  context.read<FoodBloc>().add(PickImageFoodGallery2()))),
      SizedBox(width: defaultPadding / 2),
      Expanded(
          child: _buildImageGallery(
              context: context,
              imageFile: imageGallery3,
              image: image3,
              onTap: () =>
                  context.read<FoodBloc>().add(PickImageFoodGallery3())))
    ]);
  }

  Widget _buildImageGallery(
      {required BuildContext context,
      File? imageFile,
      Function()? onTap,
      String? image}) {
    return GestureDetector(
        onTap: onTap,
        child: imageFile == null
            ? _buildImage(context, image!)
            : Container(
                height: context.sizeDevice.height * 0.15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    image: DecorationImage(
                        image: FileImage(imageFile), fit: BoxFit.fill))));
  }

  Widget _buildImage(BuildContext context, String image) {
    return image == ''
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
                    image: NetworkImage(image), fit: BoxFit.cover)),
          );
  }
}

class _ImageFood extends StatelessWidget {
  const _ImageFood({required this.image, required this.imageFile});
  final String image;
  final dynamic imageFile;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.read<FoodBloc>().add(PickImageFood());
        },
        child: imageFile == null
            ? _buildImage(context)
            : Container(
                height: 155,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(defaultBorderRadius),
                    image: DecorationImage(
                        image: FileImage(imageFile!), fit: BoxFit.cover))));
  }

  Widget _buildImage(BuildContext context) {
    return image == ''
        ? Container(
            height: 155,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius)),
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
                                      color: context.colorScheme.primary,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(
                                      defaultBorderRadius)),
                              child: Icon(Icons.add,
                                  color: context.colorScheme.secondary))),
                      SizedBox(height: defaultPadding / 2),
                      Text("Hình ảnh món ăn", style: context.textStyleSmall)
                    ])))
        : Container(
            height: 155,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(defaultBorderRadius),
                image: DecorationImage(
                    image: NetworkImage(image), fit: BoxFit.cover)),
          );
  }
}

class _NameFood extends StatelessWidget {
  final TextEditingController nameController;

  const _NameFood({required this.nameController});

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
        prefixIcon: const Icon(Icons.food_bank_rounded),
        hintText: 'Tên món ăn',
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Tên không được để trống';
          }
          return null;
        },
        onChanged: (text) =>
            context.read<FoodBloc>().add(NameFoodChanged(nameFood: text)));
  }
}

class _Categories extends StatelessWidget {
  const _Categories({required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    var categoryState = context.watch<CategoryBloc>().state;

    return Wrap(
        spacing: 4.0,
        runSpacing: 2.0,
        children: categoryState.categories
            .map((e) => SizedBox(
                height: 25,
                child: FilledButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            category == e.name
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
    return CommonTextField(
        prefixIcon: const Icon(Icons.description_outlined),
        hintText: "Nhập thông tin",
        controller: _disController,
        onChanged: (text) => context
            .read<FoodBloc>()
            .add(DescriptionFoodChanged(description: text)));
  }
}
