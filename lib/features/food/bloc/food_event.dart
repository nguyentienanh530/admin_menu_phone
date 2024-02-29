part of 'food_bloc.dart';

sealed class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object> get props => [];
}

final class FoodsFetched extends FoodEvent {}

final class GetFoodByID extends FoodEvent {
  final String idFood;

  const GetFoodByID({required this.idFood});
}

final class ResetData extends FoodEvent {}

final class DeleteFood extends FoodEvent {
  final String foodID;

  const DeleteFood({required this.foodID});
}

final class FoodCreated extends FoodEvent {
  final Food food;

  const FoodCreated({required this.food});
}

final class FoodUpdated extends FoodEvent {
  final Food food;

  const FoodUpdated({required this.food});
}
