import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blocdisk/constants.dart';
import 'package:blocdisk/utils.dart';
import 'package:meta/meta.dart';

import '../../../model/user.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>(onLoginPressed);
  }
  FutureOr<void> onLoginPressed(
      LoginButtonPressed event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    var publicKey = event.publicKey;
    var privateKey = event.privateKey;

    var storage = SecureStorage();
    storage.writeSecureData(PUBLICKEY, publicKey);
    storage.writeSecureData(PRIVATEKEY, privateKey);
    User.instance.privateKey = privateKey;
    User.instance.publicKey = publicKey;
    emit(LoginSucessfull());
  }
}
