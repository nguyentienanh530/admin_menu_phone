part of 'user_bloc.dart';

sealed class UserEvent {}

final class UserCreated extends UserEvent {
  final User user;

  UserCreated({required this.user});
}

final class UpdateToken extends UserEvent {
  final String userID;
  final String token;

  UpdateToken({required this.userID, required this.token});
}

final class UserFecthed extends UserEvent {
  final String userID;

  UserFecthed({required this.userID});
}
