// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FoodDto _$FoodDtoFromJson(Map<String, dynamic> json) {
  return _FoodDto.fromJson(json);
}

/// @nodoc
mixin _$FoodDto {
  String get foodID => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  String get note => throw _privateConstructorUsedError;
  num get totalPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FoodDtoCopyWith<FoodDto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodDtoCopyWith<$Res> {
  factory $FoodDtoCopyWith(FoodDto value, $Res Function(FoodDto) then) =
      _$FoodDtoCopyWithImpl<$Res, FoodDto>;
  @useResult
  $Res call({String foodID, int quantity, String note, num totalPrice});
}

/// @nodoc
class _$FoodDtoCopyWithImpl<$Res, $Val extends FoodDto>
    implements $FoodDtoCopyWith<$Res> {
  _$FoodDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodID = null,
    Object? quantity = null,
    Object? note = null,
    Object? totalPrice = null,
  }) {
    return _then(_value.copyWith(
      foodID: null == foodID
          ? _value.foodID
          : foodID // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as num,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodDtoImplCopyWith<$Res> implements $FoodDtoCopyWith<$Res> {
  factory _$$FoodDtoImplCopyWith(
          _$FoodDtoImpl value, $Res Function(_$FoodDtoImpl) then) =
      __$$FoodDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String foodID, int quantity, String note, num totalPrice});
}

/// @nodoc
class __$$FoodDtoImplCopyWithImpl<$Res>
    extends _$FoodDtoCopyWithImpl<$Res, _$FoodDtoImpl>
    implements _$$FoodDtoImplCopyWith<$Res> {
  __$$FoodDtoImplCopyWithImpl(
      _$FoodDtoImpl _value, $Res Function(_$FoodDtoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodID = null,
    Object? quantity = null,
    Object? note = null,
    Object? totalPrice = null,
  }) {
    return _then(_$FoodDtoImpl(
      foodID: null == foodID
          ? _value.foodID
          : foodID // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      note: null == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as num,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodDtoImpl implements _FoodDto {
  _$FoodDtoImpl(
      {this.foodID = '',
      this.quantity = 1,
      this.note = '',
      this.totalPrice = 0});

  factory _$FoodDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodDtoImplFromJson(json);

  @override
  @JsonKey()
  final String foodID;
  @override
  @JsonKey()
  final int quantity;
  @override
  @JsonKey()
  final String note;
  @override
  @JsonKey()
  final num totalPrice;

  @override
  String toString() {
    return 'FoodDto(foodID: $foodID, quantity: $quantity, note: $note, totalPrice: $totalPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodDtoImpl &&
            (identical(other.foodID, foodID) || other.foodID == foodID) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, foodID, quantity, note, totalPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodDtoImplCopyWith<_$FoodDtoImpl> get copyWith =>
      __$$FoodDtoImplCopyWithImpl<_$FoodDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodDtoImplToJson(
      this,
    );
  }
}

abstract class _FoodDto implements FoodDto {
  factory _FoodDto(
      {final String foodID,
      final int quantity,
      final String note,
      final num totalPrice}) = _$FoodDtoImpl;

  factory _FoodDto.fromJson(Map<String, dynamic> json) = _$FoodDtoImpl.fromJson;

  @override
  String get foodID;
  @override
  int get quantity;
  @override
  String get note;
  @override
  num get totalPrice;
  @override
  @JsonKey(ignore: true)
  _$$FoodDtoImplCopyWith<_$FoodDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
