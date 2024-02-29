import 'package:admin_menu_mobile/common/bloc/generic_bloc_state.dart';
import 'package:admin_menu_mobile/common/dialog/progress_dialog.dart';
import 'package:admin_menu_mobile/common/dialog/retry_dialog.dart';
import 'package:admin_menu_mobile/features/category/bloc/category_bloc.dart';
import 'package:admin_menu_mobile/features/food/model/food_model.dart';
import 'package:admin_menu_mobile/utils/app_alerts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:admin_menu_mobile/utils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/bloc/bloc_helper.dart';
import '../../features/food/bloc/food_bloc.dart';
import '../../widgets/widgets.dart';

class CreateOrUpdateFoodScreen extends StatelessWidget {
  const CreateOrUpdateFoodScreen(
      {super.key, required this.food, required this.mode});
  final Food? food;
  final Mode mode;
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => CategoryBloc()..add(FetchCategories())),
        ],
        child: Scaffold(
            appBar: _buildAppbar(context),
            body: UpdateFoodView(food: food!, mode: mode)));
  }

  _buildAppbar(BuildContext context) {
    return AppBar(
        title: Text(mode == Mode.update ? 'Cập nhật món ăn' : "Thêm món ăn",
            style: context.titleStyleMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true);
  }
}

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
  final _formKey = GlobalKey<FormState>();
  var _image = '';
  // ignore: prefer_typing_uninitialized_variables
  var _imageFile, _imageFile1, _imageFile2, _imageFile3;
  var _category = '';
  var _imageGallery1 = '';
  var _imageGallery2 = '';
  var _imageGallery3 = '';
  var _isDiscount = false;
  var _isLoading = false;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    initData();
    super.initState();
  }

  Future<String> _uploadImageFood() async {
    var image = '';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('food/${DateTime.now()}+"0"');
    UploadTask uploadTask = storageReference.putFile(_imageFile);
    await uploadTask.whenComplete(() async {
      var url = await storageReference.getDownloadURL();
      image = url.toString();
    });
    return image;
  }

  Future<String> _uploadImageFoodGallery1() async {
    var image = '';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('food/${DateTime.now()}+"1"');
    UploadTask uploadTask = storageReference.putFile(_imageFile1);
    await uploadTask.whenComplete(() async {
      var url = await storageReference.getDownloadURL();
      image = url.toString();
    });
    return image;
  }

  Future<String> _uploadImageFoodGallery2() async {
    var image = '';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('food/${DateTime.now()}+"2"');
    UploadTask uploadTask = storageReference.putFile(_imageFile2);
    await uploadTask.whenComplete(() async {
      var url = await storageReference.getDownloadURL();
      image = url.toString();
    });
    return image;
  }

  Future<String> _uploadImageFoodGallery3() async {
    var image = '';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('food/${DateTime.now()}+"3"');
    UploadTask uploadTask = storageReference.putFile(_imageFile3);
    await uploadTask.whenComplete(() async {
      var url = await storageReference.getDownloadURL();
      image = url.toString();
    });
    return image;
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
        if (widget.food.photoGallery!.isNotEmpty) {
          _imageGallery1 = widget.food.photoGallery![0] ?? '';
        }

        if (widget.food.photoGallery!.length > 1) {
          _imageGallery2 = widget.food.photoGallery![1] ?? '';
        }

        if (widget.food.photoGallery!.length > 2) {
          _imageGallery3 = widget.food.photoGallery![2] ?? '';
        }
      }
      _isDiscount = widget.food.isDiscount ?? false;
    }
  }

  @override
  void dispose() {
    _disController.dispose();
    _nameController.dispose();
    _priceCtrl.dispose();
    _discountController.dispose();
    super.dispose();
  }

  Future pickImage() async {
    var imagepicked = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (imagepicked != null) {
      setState(() {
        _imageFile = File(imagepicked.path);
      });
    } else {
      logger.d('No image selected!');
    }
  }

  Future<void> _pickImageGallery1() async {
    var imagepicked = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (imagepicked != null) {
      setState(() {
        _imageFile1 = File(imagepicked.path);
      });
    } else {
      logger.d('No image selected!');
    }
  }

  Future<void> _pickImageGallery2() async {
    var imagepicked = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (imagepicked != null) {
      setState(() {
        _imageFile2 = File(imagepicked.path);
      });
    } else {
      logger.d('No image selected!');
    }
  }

  Future<void> _pickImageGallery3() async {
    var imagepicked = await _imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (imagepicked != null) {
      setState(() {
        _imageFile3 = File(imagepicked.path);
      });
    } else {
      logger.d('No image selected!');
    }
  }

  Widget onSuccess(Food food) {
    return Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hình ảnh: (*)",
                        style: context.textStyleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: defaultPadding / 2),
                    _ImageFood(
                        image: _image,
                        imageFile: _imageFile,
                        onTap: () => pickImage()),
                    SizedBox(height: defaultPadding / 2),
                    Text("Tên món ăn: (*)",
                        style: context.textStyleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: defaultPadding / 2),
                    _NameFood(nameController: _nameController),
                    SizedBox(height: defaultPadding / 2),
                    Text("Gía bán: (*)",
                        style: context.textStyleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: defaultPadding / 2),
                    _PriceFood(priceCtrl: _priceCtrl),
                    SizedBox(height: defaultPadding / 2),
                    Text("Danh mục: (*)",
                        style: context.textStyleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: defaultPadding / 2),
                    _categories(),
                    SizedBox(height: defaultPadding / 2),
                    Text("Mô tả chi tiết:",
                        style: context.textStyleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: defaultPadding / 2),
                    _Description(_disController),
                    SizedBox(height: defaultPadding / 2),
                    Text("Album hình ảnh: (*)",
                        style: context.textStyleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: defaultPadding / 2),
                    _PhotoGallery(
                        image1: _imageGallery1,
                        image2: _imageGallery2,
                        image3: _imageGallery3,
                        imageGallery1: _imageFile1,
                        imageGallery2: _imageFile2,
                        imageGallery3: _imageFile3,
                        onTapImage1: () => _pickImageGallery1(),
                        onTapImage2: () => _pickImageGallery2(),
                        onTapImage3: () => _pickImageGallery3()),
                    SizedBox(height: defaultPadding / 2),
                    Text("Áp dụng khuyến mãi ? (*)",
                        style: context.textStyleMedium!
                            .copyWith(fontWeight: FontWeight.bold)),
                    SizedBox(height: defaultPadding / 2),
                    _Discount(
                        discountController: _discountController,
                        isDiscount: _isDiscount,
                        onChanged: (value) {
                          setState(() {
                            _isDiscount = value ?? false;
                          });
                        }),
                    SizedBox(height: defaultPadding / 2),
                    _buttonCreateOUpdateFood(),
                    SizedBox(height: defaultPadding / 2),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("(*): thông tin không được để trống.",
                          style: context.textStyleMedium!.copyWith(
                              fontStyle: FontStyle.italic,
                              color: context.colorScheme.error))
                    ]),
                    SizedBox(height: defaultPadding / 2)
                  ]
                      .animate(interval: 50.ms)
                      .slideX(
                          begin: -0.1,
                          end: 0,
                          curve: Curves.easeInOutCubic,
                          duration: 500.ms)
                      .fadeIn(curve: Curves.easeInOutCubic, duration: 500.ms)),
            )));
  }

  Widget _categories() {
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
                            _category == e.name
                                ? context.colorScheme.errorContainer
                                : context.colorScheme.primaryContainer)),
                    onPressed: () {
                      setState(() {
                        _category = e.name!;
                      });
                    },
                    child: Text(e.name!, style: context.textStyleSmall))))
            .toList());
  }

  Widget _buttonCreateOUpdateFood() {
    return Center(
        child: FilledButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.green)),
            onPressed: () async => widget.mode == Mode.create
                ? _handelCreateFood(widget.food)
                : _handleUpdateFood(widget.food),
            child: _isLoading
                ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: SpinKitCircle(color: Colors.white, size: 30))
                : Text(widget.mode == Mode.create ? 'Tạo món' : 'Cập nhật món',
                    style: context.textStyleMedium)));
  }

  void _handleUpdateFood(Food food) async {
    var toast = FToast()..init(context);
    var isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      // Update the food details
      food = food.copyWith(
        title: _nameController.text,
        price: num.parse(_priceCtrl.text),
        category: _category,
        description: _disController.text,
        photoGallery: [
          _imageGallery1,
          _imageGallery2,
          _imageGallery3,
        ],
        isDiscount: _isDiscount,
        discount: _isDiscount ? int.tryParse(_discountController.text) : 0,
      );

      if (_imageFile != null) {
        _image = await _uploadImageFood();
        food = food.copyWith(image: _image);
      }

      if (_imageFile1 != null) {
        _imageGallery1 = await _uploadImageFoodGallery1();
      }

      if (_imageFile2 != null) {
        _imageGallery2 = await _uploadImageFoodGallery2();
      }

      if (_imageFile3 != null) {
        _imageGallery3 = await _uploadImageFoodGallery3();
      }

      food = food.copyWith(
        photoGallery: [_imageGallery1, _imageGallery2, _imageGallery3],
      );

      // Perform the update operation
      updateFood(food);
    } else {
      toast.showToast(
          child:
              AppAlerts.errorToast(context, msg: 'Chưa nhập đầy đủ thông tin'));
    }
  }

  void _handelCreateFood(Food food) async {
    var toast = FToast()..init(context);
    var isValid = _formKey.currentState?.validate() ?? false;
    if (isValid &&
        _imageFile != null &&
        _imageFile1 != null &&
        _imageFile2 != null &&
        _imageFile3 != null &&
        _category.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      _image = await _uploadImageFood();
      _imageGallery1 = await _uploadImageFoodGallery1();
      _imageGallery2 = await _uploadImageFoodGallery2();
      _imageGallery3 = await _uploadImageFoodGallery3();
      var newFood = food.copyWith(
          image: _image,
          title: _nameController.text,
          price: num.parse(_priceCtrl.text.toString()),
          category: _category,
          description: _disController.text,
          photoGallery: [_imageGallery1, _imageGallery2, _imageGallery3],
          isDiscount: _isDiscount,
          discount: _isDiscount ? int.tryParse(_discountController.text) : 0);
      createFood(newFood);
      setState(() {
        _isLoading = false;
      });
    } else {
      toast.showToast(
          child:
              AppAlerts.errorToast(context, msg: 'Chưa nhập đầy đủ thông tin'));
    }
  }

  void updateFood(Food food) {
    context.read<FoodBloc>().add(FoodUpdated(food: food));

    showDialog(
        context: context,
        builder: (context) => BlocBuilder<FoodBloc, GenericBlocState<Food>>(
            buildWhen: (previous, current) =>
                context.read<FoodBloc>().operation == ApiOperation.update,
            builder: (context, state) {
              switch (state.status) {
                case Status.loading:
                  return const ProgressDialog(
                      descriptrion: 'Đang cập nhật món...', isProgressed: true);
                case Status.empty:
                  return const SizedBox();
                case Status.failure:
                  return RetryDialog(
                      title: 'Lỗi',
                      onRetryPressed: () => context
                          .read<FoodBloc>()
                          .add(FoodUpdated(food: food)));
                case Status.success:
                  return ProgressDialog(
                      descriptrion: 'Cập nhật thành công',
                      isProgressed: false,
                      onPressed: () {
                        pop(context, 3);
                      });
                default:
                  return const SizedBox();
              }
            }));
  }

  void createFood(Food food) {
    context.read<FoodBloc>().add(FoodCreated(food: food));
    showDialog(
        context: context,
        builder: (context) => BlocBuilder<FoodBloc, GenericBlocState<Food>>(
            buildWhen: (previous, current) =>
                context.read<FoodBloc>().operation == ApiOperation.create,
            builder: (context, state) => switch (state.status) {
                  Status.loading => const ProgressDialog(
                      descriptrion: 'Đang tạo món...', isProgressed: true),
                  Status.empty => const SizedBox(),
                  Status.failure => RetryDialog(
                      title: 'Lỗi',
                      onRetryPressed: () => context
                          .read<FoodBloc>()
                          .add(FoodCreated(food: food))),
                  Status.success => ProgressDialog(
                      descriptrion: 'Thành công',
                      isProgressed: false,
                      onPressed: () {
                        pop(context, 2);
                      })
                }));
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
          if (value!.isEmpty || !value.contains(RegExp(r'^[0-9]+$'))) {
            return 'Giá không hợp lệ';
          }
          return null;
        },
        onChanged: (text) => priceCtrl.text = text);
  }
}

class _Discount extends StatelessWidget {
  final TextEditingController discountController;
  final bool isDiscount;
  final Function(bool?)? onChanged;
  const _Discount(
      {required this.discountController,
      required this.isDiscount,
      required this.onChanged});
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
          onChanged: onChanged),
      Text('Áp dụng', style: context.textStyleSmall),
      Radio<bool>(
          value: false,
          activeColor: context.colorScheme.secondary,
          groupValue: isDiscount,
          onChanged: onChanged),
      Text('Không áp dụng', style: context.textStyleSmall)
    ]);
  }

  Widget _buildTextFeildDiscount(BuildContext context) {
    return CommonTextField(
        prefixIcon: const Icon(Icons.discount_rounded),
        controller: discountController,
        hintText: 'Giá khuyến mãi (0%-100%)',
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value!.isNotEmpty &&
              value.contains(RegExp(r'^[0-9]+$')) &&
              int.parse(value) < 100 &&
              isDiscount) {
            return null;
          }
          return 'Khuyễn mãi không hợp lệ';
        },
        onChanged: (value) => discountController.text = value);
  }
}

class _PhotoGallery extends StatelessWidget {
  final String image1, image2, image3;
  final dynamic imageGallery1, imageGallery2, imageGallery3;
  final Function()? onTapImage1, onTapImage2, onTapImage3;
  const _PhotoGallery(
      {required this.image1,
      required this.image2,
      required this.image3,
      required this.imageGallery1,
      required this.imageGallery2,
      required this.imageGallery3,
      required this.onTapImage1,
      required this.onTapImage2,
      required this.onTapImage3});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: _buildImageGallery(
              context: context,
              imageFile: imageGallery1,
              image: image1,
              onTap: onTapImage1)),
      SizedBox(width: defaultPadding / 2),
      Expanded(
          child: _buildImageGallery(
              context: context,
              imageFile: imageGallery2,
              image: image2,
              onTap: onTapImage2)),
      SizedBox(width: defaultPadding / 2),
      Expanded(
          child: _buildImageGallery(
              context: context,
              imageFile: imageGallery3,
              image: image3,
              onTap: onTapImage3))
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
  const _ImageFood(
      {required this.image, required this.imageFile, required this.onTap});
  final String image;
  final dynamic imageFile;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
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
        onChanged: (text) => nameController.text = text);
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
        onChanged: (text) => _disController.text = text);
  }
}
