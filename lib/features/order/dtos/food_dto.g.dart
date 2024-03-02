// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodDtoImpl _$$FoodDtoImplFromJson(Map<String, dynamic> json) =>
    _$FoodDtoImpl(
      foodID: json['foodID'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      note: json['note'] as String? ?? '',
      totalPrice: json['totalPrice'] as num? ?? 0,
    );

Map<String, dynamic> _$$FoodDtoImplToJson(_$FoodDtoImpl instance) =>
    <String, dynamic>{
      'foodID': instance.foodID,
      'quantity': instance.quantity,
      'note': instance.note,
      'totalPrice': instance.totalPrice,
    };
