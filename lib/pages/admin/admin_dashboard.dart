import 'package:flutter/material.dart';
import 'package:hmrodokan/pages/admin/add_inventory.dart';
import 'package:hmrodokan/pages/admin/category.dart';
import 'package:hmrodokan/pages/admin/create_category.dart';
import 'package:hmrodokan/pages/admin/sales.dart';
import 'package:hmrodokan/pages/admin/user.dart';
import 'package:hmrodokan/pages/admin/inventory.dart';
import 'package:hmrodokan/pages/admin/user_create.dart';

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
    {'widget': const InventoryPage(), 'title': "Inventory"},
    {'widget': const Category(), 'title': "Category"},
    {'widget': const Sales(), 'title': "Sales"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          '${_widgets[_currentIndex]["title"]}',
        ),
        backgroundColor: Colors.green,
      ),
      body: _widgets[_currentIndex]["widget"],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory), label: 'Inventory'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Category'),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell_sharp),
            label: 'Sales',
          ),
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
            ),
            const PopupMenuItem(
              value: 'admin-category',
              child: ListTile(
                leading: Icon(Icons.category),
                title: Text('Add Category'),
              ),
            )
          ];
        },
        onSelected: (value) {
          if (value == 'admin-users') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UserCreate()));
          }
          if (value == 'admin-inventory') {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddItemPage()));
          }
          if (value == 'admin-category') {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateCategory()));
          }
        },
        child: const Icon(Icons.add_circle),
      ),
    );
  }
}
