part of 'food_bloc.dart';

sealed class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object> get props => [];
}

final class GetFoods extends FoodEvent {}

final class PickImageFood extends FoodEvent {}

final class PickImageFoodGallery1 extends FoodEvent {}

final class PickImageFoodGallery2 extends FoodEvent {}

final class PickImageFoodGallery3 extends FoodEvent {}

final class IsDiscountFoodChanged extends FoodEvent {
  final bool isDiscount;

  const IsDiscountFoodChanged({required this.isDiscount});
}

final class NameFoodChanged extends FoodEvent {
  final String nameFood;

  const NameFoodChanged({required this.nameFood});
}

final class CategoryFoodChanged extends FoodEvent {
  final String category;

  const CategoryFoodChanged({required this.category});
}

final class DescriptionFoodChanged extends FoodEvent {
  final String description;

  const DescriptionFoodChanged({required this.description});
}

final class DiscountFoodChanged extends FoodEvent {
  final String discount;

  const DiscountFoodChanged({required this.discount});
}

final class SubmitCreateFood extends FoodEvent {}

final class PriceFoodChanged extends FoodEvent {
  final String priceFood;

  const PriceFoodChanged({required this.priceFood});
}

final class ResetData extends FoodEvent {}

final class DeleteFood extends FoodEvent {
  final String idFood;

  const DeleteFood({required this.idFood});
}

final class ImageChanged extends FoodEvent {
  final String image;

  const ImageChanged({required this.image});
}

final class Image1Changed extends FoodEvent {
  final String image;

  const Image1Changed({required this.image});
}

final class Image2Changed extends FoodEvent {
  final String image;

  const Image2Changed({required this.image});
}

final class Image3Changed extends FoodEvent {
  final String image;

  const Image3Changed({required this.image});
}

final class UpdateFood extends FoodEvent {
  final String idFood;

  const UpdateFood({required this.idFood});
}
