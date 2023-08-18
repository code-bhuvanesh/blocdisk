import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:blocdisk/constants.dart';
import 'package:meta/meta.dart';

import '../../../model/user.dart';
import '../../../utils/secure_storage.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>(appStarted);
    on<LogoutEvent>(logout);
  }

  SecureStorage secureStorage = SecureStorage();
  Future<FutureOr<void>> appStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    var publicKey = await secureStorage.readSecureData(PUBLICKEY);
    var privateKey = await secureStorage.readSecureData(PRIVATEKEY);

    if (publicKey.isNotEmpty || privateKey.isNotEmpty) {
      User.instance.privateKey = privateKey;
      User.instance.publicKey = publicKey;

      emit(Authenticated());
    } else {
      emit(UnAuthenticated());
    }
  }

  Future<void> logout(LogoutEvent event, Emitter<AuthState> emit) async {
    await secureStorage.deleteSecureData(PUBLICKEY);
    await secureStorage.deleteSecureData(PRIVATEKEY);
    emit(Logedout());
  }
}
