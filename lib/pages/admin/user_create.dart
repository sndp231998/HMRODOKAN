import 'package:flutter/material.dart';

class UserCreate extends StatefulWidget {
  const UserCreate({super.key});

  @override
  State<UserCreate> createState() => _UserCreateState();
}

class _UserCreateState extends State<UserCreate> {
  String dropDownValue = 'counter';

  final List _userRole = ['counter', 'admin'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            children: [
              const TextField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(labelText: 'Enter Fullname'),
              ),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Enter Email'),
              ),
              const TextField(
                keyboardType: TextInputType.streetAddress,
                decoration: InputDecoration(labelText: 'Enter Address'),
              ),
              const TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
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
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
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
              const TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Set Login ID',
                ),
              ),
              const TextField(
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: 'Set Password',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {},
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.green),
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Create New User'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
