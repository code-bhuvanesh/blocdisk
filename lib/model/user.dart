// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blocdisk/constants.dart';

import '../utils.dart';

class User {
  static final User instance = User._();

  String publicKey = "";
  String privateKey = "";
  User._() {
    loadDefaults();
  }
  void loadDefaults() async {
    var u = await SecureStorage().readSecureData(PUBLICKEY);
    if (u.isNotEmpty) {
      publicKey = u;
    }
    u = await SecureStorage().readSecureData(PRIVATEKEY);
    if (u.isNotEmpty) {
      privateKey = u;
    }
  }
}
