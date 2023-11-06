import 'package:flutter/material.dart';

import '../login.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 70),
            child: Text(
              'Hmrodkan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: 300,
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue[300]),
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login(
                                          userType: 'admin',
                                        )));
                          },
                          child: const Text(
                            "Admin Portal",
                            style: TextStyle(fontSize: 17),
                          )),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.green[300]),
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login(
                                          userType: 'counter',
                                        )));
                          },
                          child: const Text(
                            "Counter Portal",
                            style: TextStyle(fontSize: 17),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
