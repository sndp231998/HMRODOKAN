import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase_options.dart';
import 'package:hmrodokan/pages/counter/history.dart';
import 'package:hmrodokan/pages/counter/invoice.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserProvider userRoleProvider = UserProvider();

  Future<void> changeCurrentRole() async {
    userRoleProvider.setRole = await userRoleProvider.prefs.getRole();
  }

  @override
  void initState() {
    changeCurrentRole();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => userRoleProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hmrodkan',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const AuthService(),
        routes: {
          'invoice': (context) => const Invoice(),
          'history': (context) => const History(),
        },
        // setup routes here
      ),
    );
  }
}
