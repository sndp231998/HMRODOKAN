import 'package:flutter/material.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({Key? key}) : super(key: key);

  @override
  _FirstpageState createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage> {
  bool isAdminSelected = false;
  bool isCounterSelected = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _login() {
    String username = usernameController.text;
    String password = passwordController.text;

    if (isAdminSelected &&
        username == "your_admin_username" &&
        password == "your_admin_password") {
      _showGreeting("Admin");
    } else if (isCounterSelected &&
        username == "your_counter_username" &&
        password == "your_counter_password") {
      _showGreeting("Counter");
    } else {
      _showErrorDialog();
    }
  }

  void _showGreeting(String userType) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Hello $userType"),
          content: Text("Please fill out the form below."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Login Error"),
          content: Text("Invalid username or password."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chapagain Store Enterprises pvt. ltd'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Choose Account Type",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(height: 50),
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isAdminSelected = true;
                      isCounterSelected = false;
                    });
                  },
                  child: Container(
                    decoration: isAdminSelected
                        ? BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          )
                        : null,
                    child: Image.network(
                        'https://thumbs.dreamstime.com/t/admin-icon-trendy-design-style-isolated-white-background-vector-simple-modern-flat-symbol-web-site-mobile-logo-app-135742404.jpg',
                        width: 30,
                        height: 30),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      isCounterSelected = true;
                      isAdminSelected = false;
                    });
                  },
                  child: Container(
                    decoration: isCounterSelected
                        ? BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          )
                        : null,
                    child: Image.network(
                        "https://icon-library.com/images/counter-icon/counter-icon-16.jpg",
                        width: 30,
                        height: 30),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
