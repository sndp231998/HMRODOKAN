import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static const userRole = 'ROLE';

  setRole(String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userRole, role);
  }

  Future<String> getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userRole) ?? '';
  }
}
