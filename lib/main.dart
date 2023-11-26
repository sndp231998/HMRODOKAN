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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

Future<void> getCurrentUserDetails(BuildContext context) async {
  UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          getCurrentUserDetails(context);
          return const AuthService();
        },
      ),
      routes: {
        'invoice': (context) => const Invoice(),
        'history': (context) => const History(),
      },
    );
  }
}
