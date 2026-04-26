import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureLocalStorage {
  late FlutterSecureStorage _flutterSecureStorage;

  factory SecureLocalStorage() {
    return SecureLocalStorage._init();
  }

  SecureLocalStorage._init() {
    _flutterSecureStorage = _createSecureStorage();
  }

  FlutterSecureStorage _createSecureStorage() {
    checkIfFirstTime();
    return const FlutterSecureStorage();
  }

/*
Read value
*/
  Future<void> checkIfFirstTime() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('first_time') ?? true) {
        FlutterSecureStorage storage = _flutterSecureStorage;
        await storage.deleteAll();
        prefs.setBool('first_time', false);
      }
    } catch (_) {
      checkIfFirstTime();
    }
  }

  Future<String?> get(String key) async {
    try {
      return await _flutterSecureStorage.read(key: key);
    } catch (e) {
      return null;
    }
  }

/*
Write value
*/
  Future<bool> set(String key, String value) async {
    try {
      await _flutterSecureStorage.write(key: key, value: value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> delete(String key) async {
    await _flutterSecureStorage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _flutterSecureStorage.deleteAll();
  }
}
