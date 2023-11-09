import 'package:flutter/material.dart';
import 'package:hmrodokan/pages/counter/history.dart';
import 'package:hmrodokan/pages/counter/invoice.dart';
import 'package:hmrodokan/pages/home_screen.dart';

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
      title: 'Hmrodkan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        'invoice': (context) => const Invoice(),
        'history': (context) => const History(),
      },
      // setup routes here
    );
  }
}
