import 'package:flutter/material.dart';

class ProductsProvider extends ChangeNotifier {
  String _filterValue = '';

  set setFilterValue(String filterValue) {
    _filterValue = filterValue;

    notifyListeners();
  }

  // getter
  String get getFilterValue => _filterValue;
}
