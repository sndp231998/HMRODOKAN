import 'package:flutter/material.dart';
import 'package:hmrodokan/pages/admin/admin_dashboard.dart';
import 'package:hmrodokan/pages/counter/counter_dashboard.dart';
import 'package:hmrodokan/pages/forgetpassword.dart';

class Login extends StatefulWidget {
  final String userType; // route to different paths as admin & user

  const Login({super.key, required this.userType});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isAdminSelected = false;
  bool isCounterSelected = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _login(String userType) {
    String username = usernameController.text;
    String password = passwordController.text;

    // Development Logic

    if (userType == 'admin') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()));
    }

    if (userType == 'counter') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const CounterDashboard()));
    }
    // ... (rest of your logic)
  }

  // ... (rest of your code)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hmrodkan'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${widget.userType[0].toUpperCase()}${widget.userType.substring(1)} Login',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.green[600],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(
                  labelText: 'Login ID',
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
                    Text("Remember me"),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPassword()));
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            ),

            ElevatedButton(
              onPressed: () => _login(widget.userType),
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.black12),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
              ),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
