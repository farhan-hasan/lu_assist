import 'package:lu_assist/src/core/utils/logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceManager {
  late SharedPreferences _preferences;

  init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> insertValue<T>({required String key, required T data}) async {
    if (data is int) {
      return await _preferences.setInt(key, data);
    } else if (data is String) {
      return await _preferences.setString(key, data);
    } else if (data is bool) {
      return await _preferences.setBool(key, data);
    } else if (data is double) {
      return await _preferences.setDouble(key, data);
    } else if (data is List<String>) {
      return await _preferences.setStringList(key, data);
    } else {
      debug("${data.runtimeType} is not supported");
      return false;
    }
  }

  T? getValue<T>({required String key}) {
    final data = _preferences.get(key);
    if (data is T) {
      return data;
    } else {
      debug("${data.runtimeType} is not a subtype of $T");
      return null;
    }
  }
}
