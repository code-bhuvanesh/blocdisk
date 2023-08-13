part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String publicKey;
  final String privateKey;

  LoginButtonPressed({
    required this.publicKey,
    required this.privateKey,
  });
}
