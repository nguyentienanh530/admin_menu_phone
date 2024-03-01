import 'package:freezed_annotation/freezed_annotation.dart';
import 'food_dto.dart';
part 'order_model.freezed.dart';
part 'order_model.g.dart';

List<Map<String, dynamic>> foodDtoListToJson(List<FoodDto> foods) {
  return foods.map((food) => food.toJson()).toList();
}

@freezed
class Orders with _$Orders {
  factory Orders(
      {final String? id,
      final bool? isPay,
      final String? table,
      final String? dateOrder,
      final String? datePay,
      final String? date,
      final num? totalPrice,
      // ignore: invalid_annotation_target
      @JsonKey(name: 'order_food', toJson: foodDtoListToJson)
      @Default(<FoodDto>[])
      List<FoodDto> orderFood}) = _Orders;

  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);
}
