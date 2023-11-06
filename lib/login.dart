import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  final String userType; // route to different paths as admin & user

  const Login({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Text("Place your code here and create logic for two types of users"),
    );
  }
}

// From here admin will log in to admin dashboard and similarlly counter to counter dashboard