import 'package:flutter/material.dart';

class AdminProvider extends ChangeNotifier {
  int _currentIndex = 0;

  set setCurrentIndex(int index) {
    _currentIndex = index;

    notifyListeners();
  }

  get getCurrentIndex => _currentIndex;
}
