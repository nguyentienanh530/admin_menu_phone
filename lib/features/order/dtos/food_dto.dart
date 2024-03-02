import 'package:freezed_annotation/freezed_annotation.dart';
part 'food_dto.freezed.dart';
part 'food_dto.g.dart';

@freezed
class FoodDto with _$FoodDto {
  factory FoodDto(
      {@Default('') String foodID,
      @Default(1) int quantity,
      @Default('') String note,
      @Default(0) num totalPrice}) = _FoodDto;

  factory FoodDto.fromJson(Map<String, dynamic> json) =>
      _$FoodDtoFromJson(json);
}
