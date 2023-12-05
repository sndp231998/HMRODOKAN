import 'dart:math';

import 'package:flutter/material.dart';

class Utils {
  // Toastor
  void toastor(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // random Number generator
  String generateRandomString({int length = 10}) {
    // const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    const chars = '0123456789';
    final random = Random();
    return String.fromCharCodes(
      List.generate(
        length,
        (index) => chars.codeUnitAt(
          random.nextInt(chars.length),
        ),
      ),
    );
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}
