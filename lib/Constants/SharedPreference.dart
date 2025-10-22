import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  /// Adding an integer value
  static dynamic putInt(key, val) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    var res = prefs.setInt("$key", val);
    return res;
  }

  /// Adding an boolean value
  static dynamic putBool(key, val) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    var res = prefs.setBool("$key", val);
    return res;
  }

  /// Adding a string value
  static dynamic putString(key, val) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    var res = prefs.setString("$key", val);
    return res;
  }

  /// Adding a list or object
  /// Use import 'dart:convert'; for jsonEncode
  static dynamic putJson(key, val) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    var valString = jsonEncode(val);
    var res = prefs.setString("$key", valString);
    return res;
  }

  ///   ----------------------------- Get methods ----------------------------- ///

  /// Get integer value
  /// Argument [key]
  static dynamic getInt(key) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    int? res = prefs.getInt("$key");
    return res;
  }

  /// Get boolean value
  /// Argument [key]
  static dynamic getBool(key) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    bool? res = prefs.getBool("$key");
    return res;
  }

  /// Get string value
  /// Argument [key]
  static dynamic getString(key) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    String? res = prefs.getString("$key");
    return res;
  }

  /// Get list or object
  /// Use import 'dart:convert'; for jsonEncode
  /// Argument [key]
  static dynamic getJson(key) async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    String? jsonString = prefs.getString("$key");
    var res = jsonDecode(jsonString!);
    return res;
  }

  /// Clear data
  static Future reset() async {
    Future<SharedPreferences> prefs0 = SharedPreferences.getInstance();
    final SharedPreferences prefs = await prefs0;
    prefs.clear();
  }
}
