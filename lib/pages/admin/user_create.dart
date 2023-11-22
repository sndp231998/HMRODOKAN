import 'package:flutter/material.dart';
import 'package:hmrodokan/components/back_home.dart';
import 'package:hmrodokan/model/user.dart';
import 'package:hmrodokan/utils.dart';

class UserCreate extends StatefulWidget {
  const UserCreate({super.key});

  @override
  State<UserCreate> createState() => _UserCreateState();
}

class _UserCreateState extends State<UserCreate> {
  String dropDownValue = 'counter';

  TextEditingController fullname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();

  final List _userRole = ['counter', 'admin'];

  Future<void> handleCreateUser(BuildContext context) async {
    String fullname_text = fullname.text;
    String email_text = email.text;
    String address_text = address.text;
    String contact_text = contact.text;
    String login_text = login.text;
    String password_text = password.text;
    if (fullname_text == '' ||
        email_text == '' ||
        address_text == '' ||
        contact_text == '' ||
        login_text == '' ||
        password_text == '') {
      return Utils().toastor(context, 'Some fields are empty');
    }
    try {
      UserModel user = UserModel(
          fullname: fullname_text,
          email: email_text,
          address: address_text,
          phonenumber: contact_text,
          isAdmin: dropDownValue == 'admin' ? true : false,
          loginId: login_text,
          password: password_text);
      await user.createNewUser(user);
      Utils().toastor(context, 'New User Added');
    } catch (e) {
      Utils().toastor(context, e.toString());
    }
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Create New User'),
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
