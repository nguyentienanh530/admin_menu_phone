import 'package:freezed_annotation/freezed_annotation.dart';
import 'food_dto.dart';
part 'order_model.freezed.dart';
part 'order_model.g.dart';

@freezed
class Orders with _$Orders {
  const factory Orders(
      {final String? id,
      final bool? isPay,
      final String? table,
      final String? dateOrder,
      final String? datePay,
      final String? date,
      final num? totalPrice,
      @JsonKey(name: 'order_food') final List<FoodDto>? orderFood}) = _Orders;

  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);
}
