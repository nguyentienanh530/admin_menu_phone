// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Orders _$OrdersFromJson(Map<String, dynamic> json) {
  return _Orders.fromJson(json);
}

/// @nodoc
mixin _$Orders {
  String? get id => throw _privateConstructorUsedError;
  bool? get isPay => throw _privateConstructorUsedError;
  String? get table => throw _privateConstructorUsedError;
  String? get dateOrder => throw _privateConstructorUsedError;
  String? get datePay => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  num? get totalPrice =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'order_food', toJson: foodDtoListToJson)
  List<FoodDto> get orderFood => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrdersCopyWith<Orders> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrdersCopyWith<$Res> {
  factory $OrdersCopyWith(Orders value, $Res Function(Orders) then) =
      _$OrdersCopyWithImpl<$Res, Orders>;
  @useResult
  $Res call(
      {String? id,
      bool? isPay,
      String? table,
      String? dateOrder,
      String? datePay,
      String? date,
      num? totalPrice,
      @JsonKey(name: 'order_food', toJson: foodDtoListToJson)
      List<FoodDto> orderFood});
}

/// @nodoc
class _$OrdersCopyWithImpl<$Res, $Val extends Orders>
    implements $OrdersCopyWith<$Res> {
  _$OrdersCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? isPay = freezed,
    Object? table = freezed,
    Object? dateOrder = freezed,
    Object? datePay = freezed,
    Object? date = freezed,
    Object? totalPrice = freezed,
    Object? orderFood = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      isPay: freezed == isPay
          ? _value.isPay
          : isPay // ignore: cast_nullable_to_non_nullable
              as bool?,
      table: freezed == table
          ? _value.table
          : table // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOrder: freezed == dateOrder
          ? _value.dateOrder
          : dateOrder // ignore: cast_nullable_to_non_nullable
              as String?,
      datePay: freezed == datePay
          ? _value.datePay
          : datePay // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as num?,
      orderFood: null == orderFood
          ? _value.orderFood
          : orderFood // ignore: cast_nullable_to_non_nullable
              as List<FoodDto>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrdersImplCopyWith<$Res> implements $OrdersCopyWith<$Res> {
  factory _$$OrdersImplCopyWith(
          _$OrdersImpl value, $Res Function(_$OrdersImpl) then) =
      __$$OrdersImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      bool? isPay,
      String? table,
      String? dateOrder,
      String? datePay,
      String? date,
      num? totalPrice,
      @JsonKey(name: 'order_food', toJson: foodDtoListToJson)
      List<FoodDto> orderFood});
}

/// @nodoc
class __$$OrdersImplCopyWithImpl<$Res>
    extends _$OrdersCopyWithImpl<$Res, _$OrdersImpl>
    implements _$$OrdersImplCopyWith<$Res> {
  __$$OrdersImplCopyWithImpl(
      _$OrdersImpl _value, $Res Function(_$OrdersImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? isPay = freezed,
    Object? table = freezed,
    Object? dateOrder = freezed,
    Object? datePay = freezed,
    Object? date = freezed,
    Object? totalPrice = freezed,
    Object? orderFood = null,
  }) {
    return _then(_$OrdersImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      isPay: freezed == isPay
          ? _value.isPay
          : isPay // ignore: cast_nullable_to_non_nullable
              as bool?,
      table: freezed == table
          ? _value.table
          : table // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOrder: freezed == dateOrder
          ? _value.dateOrder
          : dateOrder // ignore: cast_nullable_to_non_nullable
              as String?,
      datePay: freezed == datePay
          ? _value.datePay
          : datePay // ignore: cast_nullable_to_non_nullable
              as String?,
      date: freezed == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as String?,
      totalPrice: freezed == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as num?,
      orderFood: null == orderFood
          ? _value._orderFood
          : orderFood // ignore: cast_nullable_to_non_nullable
              as List<FoodDto>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrdersImpl implements _Orders {
  _$OrdersImpl(
      {this.id,
      this.isPay,
      this.table,
      this.dateOrder,
      this.datePay,
      this.date,
      this.totalPrice,
      @JsonKey(name: 'order_food', toJson: foodDtoListToJson)
      final List<FoodDto> orderFood = const <FoodDto>[]})
      : _orderFood = orderFood;

  factory _$OrdersImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrdersImplFromJson(json);

  @override
  final String? id;
  @override
  final bool? isPay;
  @override
  final String? table;
  @override
  final String? dateOrder;
  @override
  final String? datePay;
  @override
  final String? date;
  @override
  final num? totalPrice;
// ignore: invalid_annotation_target
  final List<FoodDto> _orderFood;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'order_food', toJson: foodDtoListToJson)
  List<FoodDto> get orderFood {
    if (_orderFood is EqualUnmodifiableListView) return _orderFood;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orderFood);
  }

  @override
  String toString() {
    return 'Orders(id: $id, isPay: $isPay, table: $table, dateOrder: $dateOrder, datePay: $datePay, date: $date, totalPrice: $totalPrice, orderFood: $orderFood)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrdersImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isPay, isPay) || other.isPay == isPay) &&
            (identical(other.table, table) || other.table == table) &&
            (identical(other.dateOrder, dateOrder) ||
                other.dateOrder == dateOrder) &&
            (identical(other.datePay, datePay) || other.datePay == datePay) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            const DeepCollectionEquality()
                .equals(other._orderFood, _orderFood));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      isPay,
      table,
      dateOrder,
      datePay,
      date,
      totalPrice,
      const DeepCollectionEquality().hash(_orderFood));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OrdersImplCopyWith<_$OrdersImpl> get copyWith =>
      __$$OrdersImplCopyWithImpl<_$OrdersImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrdersImplToJson(
      this,
    );
  }
}

abstract class _Orders implements Orders {
  factory _Orders(
      {final String? id,
      final bool? isPay,
      final String? table,
      final String? dateOrder,
      final String? datePay,
      final String? date,
      final num? totalPrice,
      @JsonKey(name: 'order_food', toJson: foodDtoListToJson)
      final List<FoodDto> orderFood}) = _$OrdersImpl;

  factory _Orders.fromJson(Map<String, dynamic> json) = _$OrdersImpl.fromJson;

  @override
  String? get id;
  @override
  bool? get isPay;
  @override
  String? get table;
  @override
  String? get dateOrder;
  @override
  String? get datePay;
  @override
  String? get date;
  @override
  num? get totalPrice;
  @override // ignore: invalid_annotation_target
  @JsonKey(name: 'order_food', toJson: foodDtoListToJson)
  List<FoodDto> get orderFood;
  @override
  @JsonKey(ignore: true)
  _$$OrdersImplCopyWith<_$OrdersImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
