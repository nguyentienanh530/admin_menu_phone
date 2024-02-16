part of 'food_bloc.dart';

sealed class FoodState extends Equatable {
  const FoodState();

  @override
  List<Object> get props => [];
}

final class FoodInitial extends FoodState {}

final class FoodInProgress extends FoodState {}

final class FoodSuccess extends FoodState {
  final List<FoodModel> foods;

  const FoodSuccess({required this.foods});
}

final class FoodFailue extends FoodState {
  final String error;

  const FoodFailue({required this.error});
}
