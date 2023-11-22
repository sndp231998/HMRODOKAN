import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_auth.dart';
import 'package:hmrodokan/model/user.dart';

class UserProvider extends ChangeNotifier {
  // Prefs prefs = Prefs();
  UserModel? _user;
  final FirebaseAuthHelper _authHelper = FirebaseAuthHelper();

  Future<void> setUser(String role) async {
    _user = await _authHelper.getUserInstance();
    notifyListeners();
  }

  // getter
  UserModel get getUser => _user!;
}
