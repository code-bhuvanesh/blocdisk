part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}


class AppStarted extends AuthEvent {}

class ReadUser extends AuthEvent {}

class AuthLogin extends AuthEvent {
  final User user;

  AuthLogin(this.user);

}



class AuthLogout extends AuthEvent {}