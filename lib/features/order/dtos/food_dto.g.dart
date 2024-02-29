// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodDtoImpl _$$FoodDtoImplFromJson(Map<String, dynamic> json) =>
    _$FoodDtoImpl(
      image: json['image'] as String?,
      isDiscount: json['isDiscount'] as bool?,
      id: json['id'] as String?,
      discount: json['discount'] as int?,
      isImageCrop: json['isImageCrop'] as bool?,
      price: json['price'] as num?,
      title: json['title'] as String?,
      timeOrder: json['timeOrder'] as int?,
      quantity: json['quantity'] as int?,
      totalPrice: json['totalPrice'] as num?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$$FoodDtoImplToJson(_$FoodDtoImpl instance) =>
    <String, dynamic>{
      'image': instance.image,
      'isDiscount': instance.isDiscount,
      'id': instance.id,
      'discount': instance.discount,
      'isImageCrop': instance.isImageCrop,
      'price': instance.price,
      'title': instance.title,
      'timeOrder': instance.timeOrder,
      'quantity': instance.quantity,
      'totalPrice': instance.totalPrice,
      'note': instance.note,
    };
