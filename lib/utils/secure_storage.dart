import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  Future<String> readSecureData(String key) async {
    String value = "";
    try {
      value = (await _storage.read(key: key)) ?? "";
    } catch (e) {
      print(e);
    }
    return value;
  }

  Future<void> deleteSecureData(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print(e);
    }
  }

  Future<void> writeSecureData(String key, String value) async {
    try {
      await _storage.write(
        key: key,
        value: value,
      );
    } catch (e) {
      print(e);
    }
  }
}
