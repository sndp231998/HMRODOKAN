import 'package:flutter/material.dart';
import 'package:hmrodokan/pages/forgetpassword.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/utils.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final BoxDecoration activeUserBorder = BoxDecoration(
      border: Border.all(
    color: Colors.black,
    width: 2,
  ));

  void _login(BuildContext context) async {
    String email = usernameController.text;
    String password = passwordController.text;

    final authService = Provider.of<UserProvider>(context, listen: false);
    if (email == '' || password == '') {
      return Utils().toastor(context, 'Some fields are empty');
    }
    try {
      if (authService.getCurrentRole == 'admin') {
        await authService.loginUser(email, password);
      }

      if (authService.getCurrentRole == 'counter') {}
    } catch (e) {
      return Utils().toastor(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<UserProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 80,
                ),
                Text(
                  'Hamrodokan Login',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (authService.getCurrentRole != 'admin') {
                            authService.setRole = 'admin';
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: authService.getCurrentRole == 'admin'
                              ? activeUserBorder
                              : null,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/admin.png',
                                height: 50,
                                width: 50,
                              ),
                              const Text(
                                'Admin',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          if (authService.getCurrentRole != 'counter') {
                            authService.setRole = 'counter';
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: authService.getCurrentRole == 'counter'
                              ? activeUserBorder
                              : null,
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/counter.png',
                                height: 50,
                                width: 50,
                              ),
                              const Text(
                                'Counter',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: authService.getCurrentRole == 'admin'
                          ? 'Email'
                          : 'Login ID',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                ),
                // Add a row for "Forgot Password?" link and checkbox
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: false, // Set the initial value accordingly
                          onChanged: (value) {
                            // Handle checkbox state change here
                          },
                        ),
                        const Text("Remember me"),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: () => _login(context),
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green),
                    foregroundColor: MaterialStatePropertyAll(Colors.white),
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
