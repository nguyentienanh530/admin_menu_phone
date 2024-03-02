import 'package:freezed_annotation/freezed_annotation.dart';
import 'food_dto.dart';
part 'order_model.freezed.dart';
part 'order_model.g.dart';

List<Map<String, dynamic>> foodDtoListToJson(List<FoodDto> foods) {
  return foods.map((food) => food.toJson()).toList();
}

// enum OrdersStatus { isWanting, isNew, isPaymented }

@freezed
class Orders with _$Orders {
  factory Orders(
      {final String? id,
      final String? status,
      final String? tableID,
      final String? orderTime,
      final String? payTime,
      final num? totalPrice,
      // ignore: invalid_annotation_target
      @JsonKey(toJson: foodDtoListToJson)
      @Default(<FoodDto>[])
      List<FoodDto> foods}) = _Orders;

  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);
}
