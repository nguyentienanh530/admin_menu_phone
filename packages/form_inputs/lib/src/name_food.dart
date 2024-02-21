import 'package:formz/formz.dart';

/// Validation errors for the [Email] [FormzInput].
enum NameFoodValidationError {
  /// Generic invalid error.
  invalid
}

/// {@template email}
/// Form input for an email input.
/// {@endtemplate}
class NameFood extends FormzInput<String, NameFoodValidationError> {
  /// {@macro email}
  const NameFood.pure() : super.pure('');

  /// {@macro email}
  const NameFood.dirty([super.value = '']) : super.dirty();

  @override
  NameFoodValidationError? validator(String? value) {
    return value != '' ? null : NameFoodValidationError.invalid;
  }
}
