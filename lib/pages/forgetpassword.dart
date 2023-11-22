import 'package:flutter/material.dart';
import 'package:hmrodokan/pages/login.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  // Form Key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextForm Controller
  TextEditingController emailController = TextEditingController();

  // Form Validation
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() {
    if (_validateAndSave()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text("Hamro Dokan"),
      ),
      body: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  onSaved: (value) => emailController.text = value!,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _validateAndSubmit,
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: GestureDetector(
                    onTap: _navigateToSignIn,
                    child: RichText(
                      text: const TextSpan(
                        text: 'Have an account? ',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Goto SignIn Page
  void _navigateToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  }
}
