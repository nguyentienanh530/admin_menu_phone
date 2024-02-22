import 'package:formz/formz.dart';

/// Validation errors for the [Email] [FormzInput].
enum PriceFoodValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template email}
/// Form input for an email input.
/// {@endtemplate}
class PriceFood extends FormzInput<String, PriceFoodValidationError> {
  /// {@macro email}
  const PriceFood.pure() : super.pure('');

  /// {@macro email}
  const PriceFood.dirty([super.value = '']) : super.dirty();
  static final RegExp _regExp = RegExp(r'^[0-9]+$');
  @override
  PriceFoodValidationError? validator(String? value) {
    return _regExp.hasMatch(value ?? '')
        ? null
        : PriceFoodValidationError.invalid;
  }
}
