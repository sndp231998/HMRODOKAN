import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_auth.dart';
import 'package:hmrodokan/pages/admin/add_inventory.dart';
import 'package:hmrodokan/pages/admin/category.dart';
import 'package:hmrodokan/pages/admin/create_category.dart';
import 'package:hmrodokan/pages/admin/sales.dart';
import 'package:hmrodokan/pages/admin/user.dart';
import 'package:hmrodokan/pages/admin/inventory.dart';
import 'package:hmrodokan/pages/admin/user_create.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/utils.dart';
import 'package:provider/provider.dart';

import 'dashboard_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
  FirebaseAuthHelper authHelper = FirebaseAuthHelper();

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
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await authHelper.signOut();
                } catch (e) {
                  Utils().toastor(context, e.toString());
                }
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: _widgets[_currentIndex]["widget"],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (builder) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserCreate()));
                      },
                      leading: const Icon(Icons.people),
                      title: const Text('Add new users'),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddItemPage()));
                      },
                      leading: const Icon(Icons.add_box),
                      title: const Text('Add new product'),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CreateCategory()));
                      },
                      leading: const Icon(Icons.category),
                      title: const Text('Add new category'),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add_circle),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
