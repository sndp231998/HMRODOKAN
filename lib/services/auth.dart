import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hmrodokan/pages/admin/admin_dashboard.dart';
import 'package:hmrodokan/pages/counter/counter_dashboard.dart';
import 'package:hmrodokan/pages/login.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:provider/provider.dart';

class AuthService extends StatelessWidget {
  const AuthService({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<UserProvider>(context);

    final currentRole = authService.getCurrentRole;
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          if (currentRole == 'admin') {
            return const AdminDashboard();
          }
          if (currentRole == 'counter') {
            return const CounterDashboard();
          }
        }
        return const Login();
      },
    );
  }
}
