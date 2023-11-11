import 'package:flutter/material.dart';
import 'package:hmrodokan/pages/admin/add-inventory.dart';
import 'package:hmrodokan/pages/admin/category.dart';
import 'package:hmrodokan/pages/admin/user.dart';
import 'package:hmrodokan/pages/admin/inventory.dart';

import 'dashboard_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  void handleTap(int index) {
    // change the _currentIndex
    setState(() {
      _currentIndex = index;
    });
  }

  // list of pages to navigate
  final List _widgets = [
    {'widget': const DashboardScreen(), 'title': "Dashboard"},
    {'widget': const User(), 'title': "User"},
    {'widget': const AddItemPage(), 'title': "Add Item"},
    {'widget': const InventoryPage(), 'title': "Inventory"},
    {'widget': const Category(), 'title': "Category"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_widgets[_currentIndex]["title"]}',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: _widgets[_currentIndex]["widget"],
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
      floatingActionButton: PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              value: 'admin-users',
              child: ListTile(
                leading: Icon(Icons.people),
                title: Text('Add Users'),
              ),
            ),
            const PopupMenuItem(
              value: 'admin-inventory',
              child: ListTile(
                leading: Icon(Icons.add_box),
                title: Text('Add Inventory'),
              ),
            )
          ];
        },
        onSelected: (value) {},
        child: const Icon(Icons.add_circle),
      ),
    );
  }
}
