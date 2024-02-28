import 'dart:async';
import 'dart:io';
import 'package:admin_menu_mobile/features/food/data/food_repo.dart';
import 'package:admin_menu_mobile/utils/contants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:form_inputs/form_inputs.dart';
import '../model/food_model.dart';
part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc() : super(const FoodState()) {
    on<GetFoods>(_fetchFoods);
    on<PickImageFood>(_pickImageFood);
    on<PickImageFoodGallery1>(_pickImageFoodGallery1);
    on<PickImageFoodGallery2>(_pickImageFoodGallery2);
    on<PickImageFoodGallery3>(_pickImageFoodGallery3);
    on<NameFoodChanged>(_nameFoodChanged);
    on<CategoryFoodChanged>(_categoryChanged);
    on<DescriptionFoodChanged>(_desctriptionChanged);
    on<IsDiscountFoodChanged>(_isDisountChanged);
    on<DiscountFoodChanged>(_discountFoodChanged);
    on<PriceFoodChanged>(_priceFoodChanged);
    on<SubmitCreateFood>(_handleCreateFood);
    on<ResetData>(_resetData);
    on<DeleteFood>(_deleteFood);
    on<ImageChanged>(_imageChanged);
    on<Image1Changed>(_image1Changed);
    on<Image2Changed>(_image2Changed);
    on<Image3Changed>(_image3Changed);
    on<UpdateFood>(_updateFood);
    on<ResetStatusFood>(_resetStatusFood);
    on<GetFoodByID>(_getFoodByID);
  }

  FutureOr<void> _fetchFoods(GetFoods event, Emitter<FoodState> emit) async {
    emit(state.copyWith(status: FoodStatus.loading));
    try {
      var foods = await FoodRepo(
              foodRepository:
                  FoodRepository(firebaseFirestore: FirebaseFirestore.instance))
          .getFoods();
      emit(state.copyWith(status: FoodStatus.success, foods: foods));
    } catch (e) {
      emit(state.copyWith(status: FoodStatus.failure, error: e.toString()));
      logger.e(e);
    }
  }

  FutureOr<void> _pickImageFood(
      PickImageFood event, Emitter<FoodState> emit) async {
    var imagePicker = ImagePicker();
    // var imagepicked = await event.imagePicker
    //     .pickImage(source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    // emit(state.copyWith(status: FoodStatus.loading));
    var imagepicked = await imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (imagepicked != null) {
      emit(state.copyWith(imageFile: File(imagepicked.path)));
    } else {
      logger.d('No image selected!');
    }
  }

  FutureOr<void> _nameFoodChanged(
      NameFoodChanged event, Emitter<FoodState> emit) {
    final nameFood = NameFood.dirty(event.nameFood);
    emit(state.copyWith(
        nameFood: nameFood,
        isValid: state.isDiscount
            ? Formz.validate(
                [nameFood, state.discount, state.description, state.priceFood])
            : Formz.validate([nameFood, state.description, state.priceFood])));
  }

  FutureOr<void> _priceFoodChanged(
      PriceFoodChanged event, Emitter<FoodState> emit) {
    final price = PriceFood.dirty(event.priceFood);
    emit(state.copyWith(
        priceFood: price,
        isValid: state.isDiscount
            ? Formz.validate(
                [state.nameFood, state.discount, state.description, price])
            : Formz.validate([state.nameFood, state.description, price])));
  }

  FutureOr<void> _categoryChanged(
      CategoryFoodChanged event, Emitter<FoodState> emit) {
    emit(state.copyWith(
        category: event.category,
        isValid: state.isDiscount
            ? Formz.validate([
                state.discount,
                state.description,
                state.nameFood,
                state.priceFood
              ])
            : Formz.validate(
                [state.description, state.nameFood, state.priceFood])));
  }

  FutureOr<void> _desctriptionChanged(
      DescriptionFoodChanged event, Emitter<FoodState> emit) {
    final descriptionFood = DescriptionFood.dirty(event.description);
    emit(state.copyWith(
        description: descriptionFood,
        isValid: state.isDiscount
            ? Formz.validate([
                state.discount,
                descriptionFood,
                state.nameFood,
                state.priceFood
              ])
            : Formz.validate(
                [descriptionFood, state.nameFood, state.priceFood])));
  }

  FutureOr<void> _pickImageFoodGallery1(
      PickImageFoodGallery1 event, Emitter<FoodState> emit) async {
    var imagePicker = ImagePicker();
    var imagepicked = await imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (imagepicked != null) {
      emit(state.copyWith(imageGallery1: File(imagepicked.path)));
    } else {
      logger.d('No image selected!');
    }
  }

  FutureOr<void> _pickImageFoodGallery2(
      PickImageFoodGallery2 event, Emitter<FoodState> emit) async {
    var imagePicker = ImagePicker();
    var imagepicked = await imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (imagepicked != null) {
      emit(state.copyWith(imageGallery2: File(imagepicked.path)));
    } else {
      logger.d('No image selected!');
    }
  }

  FutureOr<void> _pickImageFoodGallery3(
      PickImageFoodGallery3 event, Emitter<FoodState> emit) async {
    var imagePicker = ImagePicker();
    var imagepicked = await imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (imagepicked != null) {
      emit(state.copyWith(imageGallery3: File(imagepicked.path)));
    } else {
      logger.d('No image selected!');
    }
  }

  FutureOr<void> _isDisountChanged(
      IsDiscountFoodChanged event, Emitter<FoodState> emit) {
    emit(state.copyWith(
        isDiscount: event.isDiscount,
        isValid: event.isDiscount
            ? Formz.validate([
                state.discount,
                state.description,
                state.nameFood,
                state.priceFood
              ])
            : Formz.validate(
                [state.description, state.nameFood, state.priceFood])));
  }

  FutureOr<void> _discountFoodChanged(
      DiscountFoodChanged event, Emitter<FoodState> emit) {
    final discountFood = DiscountFood.dirty(event.discount);
    emit(state.copyWith(
        discount: discountFood,
        isValid: state.isDiscount
            ? Formz.validate([
                discountFood,
                state.description,
                state.nameFood,
                state.priceFood
              ])
            : Formz.validate(
                [state.description, state.nameFood, state.priceFood])));
    logger.d(state.isValid);
  }

  FutureOr<String> _uploadImageFood() async {
    var image = '';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('food/${DateTime.now()}+"0"');
    UploadTask uploadTask = storageReference.putFile(state.imageFile!);
    await uploadTask.whenComplete(() async {
      var url = await storageReference.getDownloadURL();
      image = url.toString();
    });
    return image;
  }

  FutureOr<String> _uploadImageFoodGallery1() async {
    var image = '';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('food/${DateTime.now()}+"1"');
    UploadTask uploadTask = storageReference.putFile(state.imageGallery1!);
    await uploadTask.whenComplete(() async {
      var url = await storageReference.getDownloadURL();
      image = url.toString();
    });
    return image;
  }

  FutureOr<String> _uploadImageFoodGallery2() async {
    var image = '';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('food/${DateTime.now()}+"2"');
    UploadTask uploadTask = storageReference.putFile(state.imageGallery2!);
    await uploadTask.whenComplete(() async {
      var url = await storageReference.getDownloadURL();
      image = url.toString();
    });
    return image;
  }

  FutureOr<String> _uploadImageFoodGallery3() async {
    var image = '';
    Reference storageReference =
        FirebaseStorage.instance.ref().child('food/${DateTime.now()}+"3"');
    UploadTask uploadTask = storageReference.putFile(state.imageGallery3!);
    await uploadTask.whenComplete(() async {
      var url = await storageReference.getDownloadURL();
      image = url.toString();
    });
    return image;
  }

  FutureOr<void> _handleCreateFood(
      SubmitCreateFood event, Emitter<FoodState> emit) async {
    emit(state.copyWith(status: FoodStatus.loading));
    try {
      var imageFood = await _uploadImageFood();
      var imageGallery1 = await _uploadImageFoodGallery1();
      var imageGallery2 = await _uploadImageFoodGallery2();
      var imageGallery3 = await _uploadImageFoodGallery3();
      emit(state.copyWith(
          imageFood: imageFood,
          imageFood1: imageGallery1,
          imageFood2: imageGallery2,
          imageFood3: imageGallery3));
      var dataFood = {
        "category": state.category,
        "date": Timestamp.fromDate(DateTime.now()),
        "description": state.description.value,
        "id": DateTime.now().toString(),
        "image": imageFood,
        "isImageCrop": true,
        "isDiscount": state.isDiscount,
        "discount": state.isDiscount ? int.parse(state.discount.value) : 0,
        'createdAt': FieldValue.serverTimestamp(),
        'count': 0,
        "price": int.parse(state.priceFood.value),
        "title": state.nameFood.value,
        'photoGallery': [imageGallery1, imageGallery2, imageGallery3],
        "ratting": 4.5
      };
      await FoodRepo(
              foodRepository:
                  FoodRepository(firebaseFirestore: FirebaseFirestore.instance))
          .createFood(dataFood)
          .then((value) async {
        await FoodRepo(
                foodRepository: FoodRepository(
                    firebaseFirestore: FirebaseFirestore.instance))
            .updateFood(idFood: value.id, data: {'id': value.id});
      }).whenComplete(() {
        emit(state.copyWith(status: FoodStatus.success));
      });
    } catch (e) {
      emit(state.copyWith(status: FoodStatus.failure, error: e.toString()));
    }
  }

  FutureOr<void> _resetData(ResetData event, Emitter<FoodState> emit) {
    emit(const FoodState());
  }

  FutureOr<void> _deleteFood(DeleteFood event, Emitter<FoodState> emit) async {
    try {
      emit(state.copyWith(isDeleteFood: true, status: FoodStatus.loading));
      var deleted = await FoodRepo(
              foodRepository:
                  FoodRepository(firebaseFirestore: FirebaseFirestore.instance))
          .deleteFood(idFood: event.idFood);
      if (deleted) {
        emit(state.copyWith(status: FoodStatus.success));
        logger.d(state);
      } else {
        emit(state.copyWith(
            status: FoodStatus.failure, error: 'delete failure'));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(state.copyWith(status: FoodStatus.failure, error: e.toString()));
    }
  }

  FutureOr<void> _imageChanged(ImageChanged event, Emitter<FoodState> emit) {
    emit(state.copyWith(imageFood: event.image));
  }

  FutureOr<void> _image1Changed(Image1Changed event, Emitter<FoodState> emit) {
    emit(state.copyWith(imageFood1: event.image));
  }

  FutureOr<void> _image2Changed(Image2Changed event, Emitter<FoodState> emit) {
    emit(state.copyWith(imageFood2: event.image));
  }

  FutureOr<void> _image3Changed(Image3Changed event, Emitter<FoodState> emit) {
    emit(state.copyWith(imageFood3: event.image));
  }

  FutureOr<void> _updateFood(UpdateFood event, Emitter<FoodState> emit) async {
    emit(state.copyWith(status: FoodStatus.loading, isUpdateFood: true));
    var imageFood = '';
    var imageGallery1 = '';
    var imageGallery2 = '';
    var imageGallery3 = '';
    try {
      if (state.imageFile == null) {
        imageFood = state.imageFood;
      } else {
        imageFood = await _uploadImageFood();
      }
      if (state.imageGallery1 == null) {
        imageGallery1 = state.imageFood1;
      } else {
        imageGallery1 = await _uploadImageFoodGallery1();
      }
      if (state.imageGallery2 == null) {
        imageGallery2 = state.imageFood2;
      } else {
        imageGallery2 = await _uploadImageFoodGallery2();
      }
      if (state.imageGallery3 == null) {
        imageGallery3 = state.imageFood3;
      } else {
        imageGallery3 = await _uploadImageFoodGallery3();
      }

      emit(state.copyWith(
          imageFood: imageFood,
          imageFood1: imageGallery1,
          imageFood2: imageGallery2,
          imageFood3: imageGallery3));
      var dataFood = {
        "category": state.category,
        "date": Timestamp.fromDate(DateTime.now()),
        "description": state.description.value,
        "id": event.idFood,
        "image": imageFood,
        "isImageCrop": true,
        "isDiscount": state.isDiscount,
        "discount": state.isDiscount ? int.parse(state.discount.value) : 0,
        'createdAt': FieldValue.serverTimestamp(),
        'count': 0,
        "price": int.parse(state.priceFood.value),
        "title": state.nameFood.value,
        'photoGallery': [imageGallery1, imageGallery2, imageGallery3],
        "ratting": 4.5
      };
      await FoodRepo(
              foodRepository:
                  FoodRepository(firebaseFirestore: FirebaseFirestore.instance))
          .updateFood(idFood: event.idFood, data: dataFood);
      emit(state.copyWith(status: FoodStatus.success, isUpdateFood: false));
    } catch (e) {
      emit(state.copyWith(
          status: FoodStatus.failure,
          error: e.toString(),
          isUpdateFood: false));
    }
  }

  FutureOr<void> _resetStatusFood(
      ResetStatusFood event, Emitter<FoodState> emit) {
    emit(state.copyWith(status: FoodStatus.initial));
  }

  FutureOr<void> _getFoodByID(
      GetFoodByID event, Emitter<FoodState> emit) async {
    emit(state.copyWith(status: FoodStatus.loading));
    try {
      await emit.forEach(
          FoodRepo(
                  foodRepository: FoodRepository(
                      firebaseFirestore: FirebaseFirestore.instance))
              .getFoodByID(idFood: event.idFood),
          onData: (data) => state.copyWith(
              status: FoodStatus.success,
              food: data,
              category: data.category,
              nameFood: NameFood.dirty(data.title!),
              description: DescriptionFood.dirty(data.description!),
              imageFood: data.image,
              priceFood: PriceFood.dirty(data.price.toString()),
              isDiscount: data.isDiscount,
              imageFood1:
                  data.photoGallery != null && data.photoGallery!.isNotEmpty
                      ? data.photoGallery![0]
                      : '',
              imageFood2:
                  data.photoGallery != null && data.photoGallery!.isNotEmpty
                      ? data.photoGallery![1]
                      : '',
              imageFood3:
                  data.photoGallery != null && data.photoGallery!.isNotEmpty
                      ? data.photoGallery![2]
                      : '',
              discount: data.isDiscount!
                  ? DiscountFood.dirty(data.discount.toString())
                  : const DiscountFood.pure(),
              isValid: state.isDiscount
                  ? Formz.validate([
                      DiscountFood.dirty(data.discount.toString()),
                      DescriptionFood.dirty(data.description!),
                      NameFood.dirty(data.title!),
                      PriceFood.dirty(data.price.toString())
                    ])
                  : Formz.validate([
                      DescriptionFood.dirty(data.description!),
                      NameFood.dirty(data.title!),
                      PriceFood.dirty(data.price.toString())
                    ])),
          onError: (error, stackTrace) => state.copyWith(
              status: FoodStatus.failure, error: error.toString()));
    } catch (e) {
      emit(state.copyWith(status: FoodStatus.failure, error: e.toString()));
    }
  }
}
