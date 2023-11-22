import 'package:flutter/material.dart';

class Utils {
  // Toastor
  void toastor(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
