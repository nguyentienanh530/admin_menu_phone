import 'dart:async';

import 'dart:io';

import 'package:admin_menu_mobile/features/food/data/food_repo.dart';
import 'package:admin_menu_mobile/utils/contants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_repository/food_repository.dart';
import 'package:formz/formz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:form_inputs/form_inputs.dart';
import '../data/food_model.dart';
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
      emit(state.copyWith(
          status: FoodStatus.success,
          imageFile: File(imagepicked.path),
          imageName: File(imagepicked.path).path));
    } else {
      logger.d('No image selected!');
    }
  }

  FutureOr<void> _nameFoodChanged(
      NameFoodChanged event, Emitter<FoodState> emit) {
    final nameFood = NameFood.dirty(event.nameFood);
    emit(state.copyWith(
        nameFood: nameFood,
        isValid:
            Formz.validate([nameFood, state.discount, state.description]) &&
                state.imageFile != null &&
                state.imageGallery1 != null &&
                state.imageGallery2 != null &&
                state.imageGallery3 != null));
  }

  FutureOr<void> _categoryChanged(
      CategoryFoodChanged event, Emitter<FoodState> emit) {
    emit(state.copyWith(
        category: event.category,
        isValid: Formz.validate(
                [state.discount, state.description, state.nameFood]) &&
            state.imageFile != null &&
            state.imageGallery1 != null &&
            state.imageGallery2 != null &&
            state.imageGallery3 != null));
  }

  FutureOr<void> _desctriptionChanged(
      DescriptionFoodChanged event, Emitter<FoodState> emit) {
    final descriptionFood = DescriptionFood.dirty(event.description);
    emit(state.copyWith(
        description: descriptionFood,
        isValid:
            Formz.validate([state.discount, descriptionFood, state.nameFood]) &&
                state.imageFile != null &&
                state.imageGallery1 != null &&
                state.imageGallery2 != null &&
                state.imageGallery3 != null));
  }

  FutureOr<void> _pickImageFoodGallery1(
      PickImageFoodGallery1 event, Emitter<FoodState> emit) async {
    var imagePicker = ImagePicker();
    var imagepicked = await imagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 500, maxWidth: 500);
    if (imagepicked != null) {
      emit(state.copyWith(
          isValid: Formz.validate(
                  [state.discount, state.description, state.nameFood]) &&
              state.imageFile != null &&
              state.imageGallery1 != null &&
              state.imageGallery2 != null &&
              state.imageGallery3 != null,
          status: FoodStatus.success,
          imageGallery1: File(imagepicked.path),
          imageNameGallery1: File(imagepicked.path).path));
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
      emit(state.copyWith(
          isValid: Formz.validate(
                  [state.discount, state.description, state.nameFood]) &&
              state.imageFile != null &&
              state.imageGallery1 != null &&
              state.imageGallery2 != null &&
              state.imageGallery3 != null,
          status: FoodStatus.success,
          imageGallery2: File(imagepicked.path),
          imageNameGallery2: File(imagepicked.path).path));
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
      emit(state.copyWith(
          isValid: Formz.validate(
                  [state.discount, state.description, state.nameFood]) &&
              state.imageFile != null &&
              state.imageGallery1 != null &&
              state.imageGallery2 != null &&
              state.imageGallery3 != null,
          status: FoodStatus.success,
          imageGallery3: File(imagepicked.path),
          imageNameGallery3: File(imagepicked.path).path));
    } else {
      logger.d('No image selected!');
    }
  }

  FutureOr<void> _isDisountChanged(
      IsDiscountFoodChanged event, Emitter<FoodState> emit) {
    emit(state.copyWith(
      isDiscount: event.isDiscount,
      isValid:
          Formz.validate([state.discount, state.description, state.nameFood]) &&
              state.imageFile != null &&
              state.imageGallery1 != null &&
              state.imageGallery2 != null &&
              state.imageGallery3 != null,
    ));
  }

  FutureOr<void> _discountFoodChanged(
      DiscountFoodChanged event, Emitter<FoodState> emit) {
    final discountFood = DiscountFood.dirty(event.discount);
    emit(state.copyWith(
        discount: discountFood,
        isValid:
            Formz.validate([discountFood, state.description, state.nameFood]) &&
                state.imageFile != null &&
                state.imageGallery1 != null &&
                state.imageGallery2 != null &&
                state.imageGallery3 != null));
    logger.d(state.isValid);
  }
}
