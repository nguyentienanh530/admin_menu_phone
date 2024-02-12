part of 'register_cubit.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.isValid = false,
    this.isShowPassword = false,
    this.errorMessage,
  });

  final Email email;
  final Password password;
  final bool isShowPassword;
  final FormzSubmissionStatus status;
  final bool isValid;
  final String? errorMessage;

  @override
  List<Object?> get props =>
      [email, password, status, isValid, errorMessage, isShowPassword];

  RegisterState copyWith(
      {Email? email,
      Password? password,
      FormzSubmissionStatus? status,
      bool? isValid,
      bool? isShowPassword,
      String? errorMessage}) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      isShowPassword: isShowPassword ?? this.isShowPassword,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
