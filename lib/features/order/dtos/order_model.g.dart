// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrdersImpl _$$OrdersImplFromJson(Map<String, dynamic> json) => _$OrdersImpl(
      id: json['id'] as String?,
      isPay: json['isPay'] as bool?,
      table: json['table'] as String?,
      dateOrder: json['dateOrder'] as String?,
      datePay: json['datePay'] as String?,
      date: json['date'] as String?,
      totalPrice: json['totalPrice'] as num?,
      orderFood: (json['order_food'] as List<dynamic>?)
              ?.map((e) => FoodDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <FoodDto>[],
    );

Map<String, dynamic> _$$OrdersImplToJson(_$OrdersImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isPay': instance.isPay,
      'table': instance.table,
      'dateOrder': instance.dateOrder,
      'datePay': instance.datePay,
      'date': instance.date,
      'totalPrice': instance.totalPrice,
      'order_food': foodDtoListToJson(instance.orderFood),
    };
