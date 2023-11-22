import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hmrodokan/pages/admin/admin_dashboard.dart';
import 'package:hmrodokan/pages/counter/counter_dashboard.dart';
import 'package:hmrodokan/pages/login.dart';

class AuthService extends StatelessWidget {
  const AuthService({super.key});

  @override
  Widget build(BuildContext context) {
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
          if (user.uid == 'admin') {
            return const AdminDashboard();
          }
          if (user.uid == 'counter') {
            return const CounterDashboard();
          }
        }
        return const AdminDashboard();
      },
    );
  }
}
