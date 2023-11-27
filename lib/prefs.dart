import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const currentUserInfo = 'USER';

  static Future<void> setUser(String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(currentUserInfo, value);
    } catch (e) {
      print('Error setting user: $e');
    }
  }

  static Future<String> getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString(currentUserInfo) ?? '';
    } catch (e) {
      print('Error getting user: $e');
      return ''; // Return a default value or handle the error accordingly
    }
  }

  static Future<void> clearUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing: $e');
    }
  }
}
