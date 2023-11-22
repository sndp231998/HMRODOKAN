import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hmrodokan/prefs.dart';

class UserProvider extends ChangeNotifier {
  Prefs prefs = Prefs();
  String role = '';

  // setter
  set setRole(String role) {
    this.role = role;
    prefs.setRole(role);
    notifyListeners();
  }

  // getter
  String get getCurrentRole => role;

  // login
  Future<void> loginUser(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception(e);
    }
  }

  // signout
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}
