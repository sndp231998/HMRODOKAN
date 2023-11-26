import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hmrodokan/model/user.dart';
import 'package:hmrodokan/pages/admin/admin_dashboard.dart';
import 'package:hmrodokan/pages/counter/counter_dashboard.dart';
import 'package:hmrodokan/pages/login.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:provider/provider.dart';

class AuthService extends StatelessWidget {
  const AuthService({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            UserModel? user = userProvider.getUser;
            if (snapshot.data != null) {
              if (user != null) {
                if (user.role == 'admin') {
                  return const AdminDashboard();
                }
                if (user.role == 'counter') {
                  return const CounterDashboard();
                }
              }
            }
            return const Login();
          },
        );
      },
    );
  }
}
