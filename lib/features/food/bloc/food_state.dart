part of 'food_bloc.dart';

enum FoodStatus { initial, loading, success, failure }

class FoodState extends Equatable {
  const FoodState(
      {this.foods = const <Food>[],
      this.food,
      this.error = '',
      this.status = FoodStatus.initial,
      this.imageFile,
      this.nameFood = const NameFood.pure(),
      this.isValid = false,
      this.isDiscount = false,
      this.category = '',
      this.description = const DescriptionFood.pure(),
      this.imageGallery1,
      this.imageGallery2,
      this.imageGallery3,
      this.discount = const DiscountFood.pure(),
      this.priceFood = const PriceFood.pure(),
      this.imageFood = '',
      this.imageFood1 = '',
      this.imageFood2 = '',
      this.imageFood3 = '',
      this.isUpdateFood = false,
      this.isDeleteFood = false});
  final List<Food> foods;
  final Food? food;
  final String error;
  final FoodStatus status;
  final File? imageFile, imageGallery1, imageGallery2, imageGallery3;
  final NameFood nameFood;
  final String category;
  final DescriptionFood description;
  final bool isValid;
  final bool isUpdateFood;
  final bool isDeleteFood;
  final bool isDiscount;
  final DiscountFood discount;
  final PriceFood priceFood;
  final String imageFood, imageFood1, imageFood2, imageFood3;

  FoodState copyWith(
      {List<Food>? foods,
      Food? food,
      String? error,
      FoodStatus? status,
      File? imageFile,
      File? imageGallery1,
      File? imageGallery2,
      File? imageGallery3,
      NameFood? nameFood,
      bool? isValid,
      bool? isDiscount,
      bool? isUpdateFood,
      bool? isDeleteFood,
      String? category,
      DescriptionFood? description,
      DiscountFood? discount,
      PriceFood? priceFood,
      String? imageFood,
      String? imageFood1,
      String? imageFood2,
      String? imageFood3}) {
    return FoodState(
        status: status ?? this.status,
        foods: foods ?? this.foods,
        food: food ?? this.food,
        error: error ?? this.error,
        imageFile: imageFile ?? this.imageFile,
        imageGallery1: imageGallery1 ?? this.imageGallery1,
        imageGallery2: imageGallery2 ?? this.imageGallery2,
        imageGallery3: imageGallery3 ?? this.imageGallery3,
        nameFood: nameFood ?? this.nameFood,
        isValid: isValid ?? this.isValid,
        category: category ?? this.category,
        description: description ?? this.description,
        isDiscount: isDiscount ?? this.isDiscount,
        discount: discount ?? this.discount,
        priceFood: priceFood ?? this.priceFood,
        imageFood: imageFood ?? this.imageFood,
        imageFood1: imageFood1 ?? this.imageFood1,
        imageFood2: imageFood2 ?? this.imageFood2,
        imageFood3: imageFood3 ?? this.imageFood3,
        isUpdateFood: isUpdateFood ?? this.isUpdateFood,
        isDeleteFood: isDeleteFood ?? this.isDeleteFood);
  }

  @override
  List<Object> get props => [
        status,
        foods,
        food ?? Food(),
        error,
        imageFile ?? File(''),
        imageGallery1 ?? File(''),
        imageGallery2 ?? File(''),
        imageGallery3 ?? File(''),
        nameFood,
        category,
        description,
        isValid,
        isDiscount,
        discount,
        priceFood,
        imageFood,
        imageFood1,
        imageFood2,
        imageFood3,
        isUpdateFood,
        isDeleteFood
      ];
}
