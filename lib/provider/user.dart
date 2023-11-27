import 'package:flutter/material.dart';
import 'package:hmrodokan/model/user.dart';

class UserProvider extends ChangeNotifier {
  // Prefs prefs = Prefs();
  UserModel? _user;

  set setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // getter
  UserModel? get getUser => _user;
}
