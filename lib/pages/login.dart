import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_auth.dart';
import 'package:hmrodokan/model/user.dart';
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

  String currentRole = 'counter';

  final BoxDecoration activeUserBorder = BoxDecoration(
      border: Border.all(
    color: Colors.black,
    width: 2,
  ));

  void toggleRole(String roleType) {
    setState(() {
      currentRole = roleType;
    });
  }

  void _login(BuildContext context) async {
    String email = usernameController.text;
    String password = passwordController.text;

    FirebaseAuthHelper authHelper = FirebaseAuthHelper();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    if (email == '' || password == '') {
      return Utils().toastor(context, 'Some fields are empty');
    }
    try {
      await authHelper.loginUser(email, password);
      await getCurrentUserDetails(userProvider);
      if (context.mounted) Utils().toastor(context, 'Successfully Logged In');
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }
  }

  Future<void> getCurrentUserDetails(UserProvider userProvider) async {
    FirebaseAuthHelper authHelper = FirebaseAuthHelper();

    UserModel? user = await authHelper.getUserInstance();

    if (user != null) {
      userProvider.setUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                // SizedBox(
                //   width: MediaQuery.of(context).size.width * 0.5,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       GestureDetector(
                //         onTap: () {
                //           if (currentRole != 'admin') {
                //             toggleRole('admin');
                //           }
                //         },
                //         child: Container(
                //           padding: const EdgeInsets.all(8),
                //           decoration:
                //               currentRole == 'admin' ? activeUserBorder : null,
                //           child: Column(
                //             children: [
                //               Image.asset(
                //                 'assets/images/admin.png',
                //                 height: 50,
                //                 width: 50,
                //               ),
                //               const Text(
                //                 'Admin',
                //                 style: TextStyle(fontWeight: FontWeight.w500),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //       const SizedBox(width: 20),
                //       GestureDetector(
                //         onTap: () {
                //           if (currentRole != 'counter') {
                //             toggleRole('counter');
                //           }
                //         },
                //         child: Container(
                //           padding: const EdgeInsets.all(8),
                //           decoration: currentRole == 'counter'
                //               ? activeUserBorder
                //               : null,
                //           child: Column(
                //             children: [
                //               Image.asset(
                //                 'assets/images/counter.png',
                //                 height: 50,
                //                 width: 50,
                //               ),
                //               const Text(
                //                 'Counter',
                //                 style: TextStyle(fontWeight: FontWeight.w500),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
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
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       value: false, // Set the initial value accordingly
                    //       onChanged: (value) {
                    //         // Handle checkbox state change here
                    //       },
                    //     ),
                    //     const Text("Remember me"),
                    //   ],
                    // ),
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
