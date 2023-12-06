import 'package:flutter/material.dart';
import 'package:hmrodokan/model/user.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
      uid: '',
      fullname: '',
      email: '',
      address: '',
      phonenumber: '',
      role: '',
      username: '',
      storeId: '');

  set setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // getter
  UserModel get getUser => _user;
}
