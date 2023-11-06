import 'package:flutter/material.dart';
import 'package:hmrodokan/pages/admin/add-inventory.dart';
import 'package:hmrodokan/pages/admin/category.dart';
import 'package:hmrodokan/pages/admin/counter.dart';
import 'package:hmrodokan/pages/admin/inventory.dart';

import '../../components/dashboard_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 1;

  void handleTap(int index) {
    // change the _currentIndex
    setState(() {
      _currentIndex = index;
    });
  }

  // list of pages to navigate
  final List<Widget> _widgets = <Widget>[
    const DashboardScreen(),
    const Counter(),
    const AddInventory(),
    const Inventory(),
    const Category()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: _widgets[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Counter'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: '',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory), label: 'Inventory'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Category'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: handleTap,
      ),
    );
  }
}
