import 'package:flutter/material.dart';

import 'login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          const Expanded(
              child: Center(
            child: Text(
              'Choose user type',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          )),
          Expanded(
            flex: 2,
            child: SizedBox(
              width: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login(
                                    userType: 'admin',
                                  )));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/admin.png',
                          height: 50,
                          width: 50,
                        ),
                        const Text(
                          'Admin Login',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login(
                                    userType: 'counter',
                                  )));
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/counter.png',
                          height: 50,
                          width: 50,
                        ),
                        const Text(
                          'Counter Login',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
