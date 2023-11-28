import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_auth.dart';
import 'package:hmrodokan/firebase_options.dart';
import 'package:hmrodokan/model/user.dart';
import 'package:hmrodokan/pages/counter/history.dart';
import 'package:hmrodokan/pages/counter/invoice.dart';
import 'package:hmrodokan/prefs.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize UserProvider before runApp
  UserProvider userProvider = UserProvider();
  await getCurrentUserDetails(userProvider);

  runApp(
    MultiProvider(
      providers: [
        // Use ChangeNotifierProvider.value to provide an existing instance
        ChangeNotifierProvider.value(value: userProvider),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> getCurrentUserDetails(UserProvider userProvider) async {
  FirebaseAuthHelper authHelper = FirebaseAuthHelper();
  String userData = await Prefs.getUser();
  if (userData.isNotEmpty) {
    userProvider.setUser = UserModel.fromJson(userData);
  } else {
    UserModel? user = await authHelper.getUserInstance();

    if (user != null) {
      await Prefs.setUser(user.toJson());
      userProvider.setUser = user;
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: const AuthService(),
      routes: {
        'invoice': (context) => const Invoice(),
        'history': (context) => const History(),
      },
    );
  }
}
