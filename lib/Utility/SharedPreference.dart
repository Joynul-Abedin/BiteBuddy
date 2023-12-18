import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._internal();
  late SharedPreferences _prefs;

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Setter with key and value
  setStringValue(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Getter with key
  String getStringValue(String key, String defaultValue) {
    return _prefs.getString(key) ?? defaultValue;
  }

  // Setter with key and value
  setBoolValue(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  // Getter with key
  bool getBoolValue(String key, bool defaultValue) {
    return _prefs.getBool(key) ?? defaultValue;
  }

  clear() async {
    await _prefs.clear();
  }
}
