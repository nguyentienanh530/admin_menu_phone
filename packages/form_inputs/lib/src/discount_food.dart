import 'package:formz/formz.dart';

/// Validation errors for the [Email] [FormzInput].
enum DiscountFoodValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template email}
/// Form input for an email input.
/// {@endtemplate}
class DiscountFood extends FormzInput<String, DiscountFoodValidationError> {
  /// {@macro email}
  const DiscountFood.pure() : super.pure('');

  /// {@macro email}
  const DiscountFood.dirty([super.value = '']) : super.dirty();
  static final RegExp _regExp = RegExp(r'^[0-9]+$');
  @override
  DiscountFoodValidationError? validator(String? value) {
    return _regExp.hasMatch(value ?? '')
        ? null
        : DiscountFoodValidationError.invalid;
  }
}
