import 'package:formz/formz.dart';

/// Validation errors for the [Email] [FormzInput].
enum DescriptionFoodValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template email}
/// Form input for an email input.
/// {@endtemplate}
class DescriptionFood
    extends FormzInput<String, DescriptionFoodValidationError> {
  /// {@macro email}
  const DescriptionFood.pure() : super.pure('');

  /// {@macro email}
  const DescriptionFood.dirty([super.value = '']) : super.dirty();

  @override
  DescriptionFoodValidationError? validator(String? value) {
    return value != '' ? null : DescriptionFoodValidationError.invalid;
  }
}
