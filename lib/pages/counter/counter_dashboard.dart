import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_auth.dart';
import 'package:hmrodokan/pages/counter/create_bill.dart';
import 'package:hmrodokan/pages/counter/history.dart';
// import 'package:hmrodokan/pages/counter/inventory.dart';
import 'package:hmrodokan/utils.dart';

class CounterDashboard extends StatefulWidget {
  const CounterDashboard({super.key});

  @override
  State<CounterDashboard> createState() => _CounterDashboardState();
}

class _CounterDashboardState extends State<CounterDashboard> {
  int _currentIndex = 0;
  FirebaseAuthHelper authHelper = FirebaseAuthHelper();

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateBill()),
                  );
                },
                child: Container(
                  height: 130,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.blueGrey,
                          Colors.green,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.black26,
                        width: 1.0,
                      )),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'New Bill',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Icon(
                          Icons.shop,
                          size: 50,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    try {
                      await authHelper.signOut();
                    } catch (e) {
                      if (context.mounted) {
                        Utils().toastor(context, e.toString());
                      }
                    }
                  },
                  child: const Text('Sign Out'))
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black26,
          currentIndex: 0,
          onTap: (value) {
            setState(() {
              _currentIndex = value;
              // if (_currentIndex == 1) {
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => const Inventory()));
              // }
              if (_currentIndex == 1) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const History()));
              }
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.inventory), label: 'Inventory'),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: 'History'),
          ]),
    );
  }
}
