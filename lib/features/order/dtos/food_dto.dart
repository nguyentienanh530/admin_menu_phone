import 'package:freezed_annotation/freezed_annotation.dart';
part 'food_dto.freezed.dart';
part 'food_dto.g.dart';

@freezed
class FoodDto with _$FoodDto {
  factory FoodDto({
    final String? image,
    final bool? isDiscount,
    final String? id,
    final int? discount,
    final bool? isImageCrop,
    final num? price,
    final String? title,
    final int? timeOrder,
    final int? quantity,
    final num? totalPrice,
    final String? note,
  }) = _FoodDto;

  factory FoodDto.fromJson(Map<String, dynamic> json) =>
      _$FoodDtoFromJson(json);
}
