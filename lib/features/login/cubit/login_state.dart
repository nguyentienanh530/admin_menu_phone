part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState(
      {this.status = FormzSubmissionStatus.initial, this.errorMessage});

  final FormzSubmissionStatus status;

  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];

  LoginState copyWith({FormzSubmissionStatus? status, String? errorMessage}) {
    return LoginState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}
