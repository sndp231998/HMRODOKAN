import 'package:flutter/material.dart';
import 'package:hmrodokan/pages/counter.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyForm(),
      home: const Counter(),
      // routes: {
      //   //'AddItem': (context) => AddItemPage(),
      //   'AddItem2': (context) => MyForm(),
      // },
    );
  }
}
