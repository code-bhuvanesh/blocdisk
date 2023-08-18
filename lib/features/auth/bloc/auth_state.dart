part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}




class UnAuthenticated extends AuthState {}

class Authenticated extends AuthState {}


class Logedout extends  AuthState {}