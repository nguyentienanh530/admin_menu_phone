part of 'food_bloc.dart';

enum FoodStatus { initial, loading, success, failure }

class FoodState extends Equatable {
  const FoodState({
    this.foods = const <FoodModel>[],
    this.error = '',
    this.status = FoodStatus.initial,
    this.imageFile,
    this.imageName = '',
    this.nameFood = const NameFood.pure(),
    this.isValid = false,
    this.isDiscount = false,
    this.category = '',
    this.description = const DescriptionFood.pure(),
    this.imageGallery1,
    this.imageGallery2,
    this.imageGallery3,
    this.imageNameGallery1 = '',
    this.imageNameGallery2 = '',
    this.imageNameGallery3 = '',
    this.discount = const DiscountFood.pure(),
  });
  final List<FoodModel> foods;
  final String error;
  final FoodStatus status;
  final File? imageFile, imageGallery1, imageGallery2, imageGallery3;
  final String imageName,
      imageNameGallery1,
      imageNameGallery2,
      imageNameGallery3;
  final NameFood nameFood;
  final String category;
  final DescriptionFood description;
  final bool isValid;
  final bool isDiscount;
  final DiscountFood discount;

  FoodState copyWith(
      {List<FoodModel>? foods,
      String? error,
      FoodStatus? status,
      File? imageFile,
      imageNameGallery1,
      imageNameGallery2,
      imageNameGallery3,
      String? imageName,
      imageGallery1,
      imageGallery2,
      imageGallery3,
      NameFood? nameFood,
      bool? isValid,
      bool? isDiscount,
      String? category,
      DescriptionFood? description,
      DiscountFood? discount}) {
    return FoodState(
        status: status ?? this.status,
        foods: foods ?? this.foods,
        error: error ?? this.error,
        imageFile: imageFile ?? this.imageFile,
        imageGallery1: imageGallery1 ?? this.imageGallery1,
        imageGallery2: imageGallery2 ?? this.imageGallery2,
        imageGallery3: imageGallery3 ?? this.imageGallery3,
        imageName: imageName ?? this.imageName,
        imageNameGallery1: imageNameGallery1 ?? this.imageNameGallery1,
        imageNameGallery2: imageNameGallery2 ?? this.imageNameGallery2,
        imageNameGallery3: imageNameGallery3 ?? this.imageNameGallery3,
        nameFood: nameFood ?? this.nameFood,
        isValid: isValid ?? this.isValid,
        category: category ?? this.category,
        description: description ?? this.description,
        isDiscount: isDiscount ?? this.isDiscount,
        discount: discount ?? this.discount);
  }

  @override
  List<Object> get props => [
        status,
        foods,
        error,
        imageName,
        imageNameGallery1,
        imageNameGallery2,
        imageNameGallery3,
        imageFile ?? File(''),
        imageGallery1 ?? File(''),
        imageGallery2 ?? File(''),
        imageGallery3 ?? File(''),
        nameFood,
        category,
        description,
        isValid,
        isDiscount,
        discount
      ];
}
