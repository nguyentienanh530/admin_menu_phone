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

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  String? get id => throw _privateConstructorUsedError;
  bool? get isPay => throw _privateConstructorUsedError;
  String? get table => throw _privateConstructorUsedError;
  String? get dateOrder => throw _privateConstructorUsedError;
  String? get datePay => throw _privateConstructorUsedError;
  String? get date => throw _privateConstructorUsedError;
  num? get totalPrice => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_food')
  List<Food>? get orderFood => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
          OrderModel value, $Res Function(OrderModel) then) =
      _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call(
      {String? id,
      bool? isPay,
      String? table,
      String? dateOrder,
      String? datePay,
      String? date,
      num? totalPrice,
      @JsonKey(name: 'order_food') List<Food>? orderFood});
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

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
    Object? orderFood = freezed,
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
      orderFood: freezed == orderFood
          ? _value.orderFood
          : orderFood // ignore: cast_nullable_to_non_nullable
              as List<Food>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
          _$OrderModelImpl value, $Res Function(_$OrderModelImpl) then) =
      __$$OrderModelImplCopyWithImpl<$Res>;
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
      @JsonKey(name: 'order_food') List<Food>? orderFood});
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
      _$OrderModelImpl _value, $Res Function(_$OrderModelImpl) _then)
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
    Object? orderFood = freezed,
  }) {
    return _then(_$OrderModelImpl(
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
      orderFood: freezed == orderFood
          ? _value._orderFood
          : orderFood // ignore: cast_nullable_to_non_nullable
              as List<Food>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl(
      {this.id,
      this.isPay,
      this.table,
      this.dateOrder,
      this.datePay,
      this.date,
      this.totalPrice,
      @JsonKey(name: 'order_food') final List<Food>? orderFood})
      : _orderFood = orderFood;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

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
  final List<Food>? _orderFood;
  @override
  @JsonKey(name: 'order_food')
  List<Food>? get orderFood {
    final value = _orderFood;
    if (value == null) return null;
    if (_orderFood is EqualUnmodifiableListView) return _orderFood;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, isPay: $isPay, table: $table, dateOrder: $dateOrder, datePay: $datePay, date: $date, totalPrice: $totalPrice, orderFood: $orderFood)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
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
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(
      this,
    );
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel(
          {final String? id,
          final bool? isPay,
          final String? table,
          final String? dateOrder,
          final String? datePay,
          final String? date,
          final num? totalPrice,
          @JsonKey(name: 'order_food') final List<Food>? orderFood}) =
      _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

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
  @override
  @JsonKey(name: 'order_food')
  List<Food>? get orderFood;
  @override
  @JsonKey(ignore: true)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
