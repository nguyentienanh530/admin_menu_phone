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
