import 'package:flutter/material.dart';
import 'package:hmrodokan/components/back_home.dart';
import 'package:hmrodokan/firebase/firebase_auth.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/utils.dart';
import 'package:provider/provider.dart';

class UserCreate extends StatefulWidget {
  const UserCreate({super.key});

  @override
  State<UserCreate> createState() => _UserCreateState();
}

class _UserCreateState extends State<UserCreate> {
  String dropDownValue = 'counter';
  bool isSaving = false;

  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();

  final List _userRole = ['counter', 'admin'];
  FirebaseAuthHelper authHelper = FirebaseAuthHelper();

  void toggleIsSaving(bool value) {
    setState(() {
      isSaving = value;
    });
  }

  Future<void> handleCreateUser(BuildContext context) async {
    toggleIsSaving(true);

    String storeId =
        Provider.of<UserProvider>(context, listen: false).getUser.storeId;
    String fullnameText = fullname.text;
    String emailText = email.text;
    String addressText = address.text;
    String contactText = contact.text;
    String loginText = login.text;
    String passwordText = password.text;
    if (fullnameText == '' ||
        emailText == '' ||
        addressText == '' ||
        contactText == '' ||
        loginText == '' ||
        passwordText == '') {
      return Utils().toastor(context, 'Some fields are empty');
    }
    try {
      await authHelper.createNewUser(
          email: emailText,
          storeId: storeId,
          username: loginText,
          fullname: fullnameText,
          password: passwordText,
          role: dropDownValue,
          address: addressText,
          phonenumber: contactText);
      fullname.text = '';
      email.text = '';
      address.text = '';
      contact.text = '';
      login.text = '';
      password.text = '';
      if (context.mounted) Utils().toastor(context, 'New User Added');
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }
    toggleIsSaving(false);
  }

  @override
  void dispose() {
    fullname.dispose();
    email.dispose();
    address.dispose();
    contact.dispose();
    login.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new User'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Column(
              children: [
                TextField(
                  controller: fullname,
                  keyboardType: TextInputType.name,
                  decoration:
                      const InputDecoration(labelText: 'Enter Fullname'),
                ),
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Enter Email'),
                ),
                TextField(
                  controller: address,
                  keyboardType: TextInputType.streetAddress,
                  decoration: const InputDecoration(labelText: 'Enter Address'),
                ),
                TextField(
                  controller: contact,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Enter Contact Number',
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text(
                      'Select User Role:',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    DropdownButton(
                        value: dropDownValue,
                        items: _userRole.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            dropDownValue = value!;
                          });
                        }),
                  ],
                ),
                TextField(
                  controller: login,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Set Login ID',
                  ),
                ),
                TextField(
                  controller: password,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    labelText: 'Set Password',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    handleCreateUser(context);
                  },
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.green),
                      foregroundColor: MaterialStatePropertyAll(Colors.white)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: isSaving
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Create New User'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const IntrinsicWidth(child: BackHome()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
