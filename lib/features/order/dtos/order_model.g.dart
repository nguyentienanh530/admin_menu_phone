// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderModelImpl _$$OrderModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderModelImpl(
      id: json['id'] as String?,
      isPay: json['isPay'] as bool?,
      table: json['table'] as String?,
      dateOrder: json['dateOrder'] as String?,
      datePay: json['datePay'] as String?,
      date: json['date'] as String?,
      totalPrice: json['totalPrice'] as num?,
      orderFood: (json['order_food'] as List<dynamic>?)
          ?.map((e) => Food.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$OrderModelImplToJson(_$OrderModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isPay': instance.isPay,
      'table': instance.table,
      'dateOrder': instance.dateOrder,
      'datePay': instance.datePay,
      'date': instance.date,
      'totalPrice': instance.totalPrice,
      'order_food': instance.orderFood,
    };
