import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_auth.dart';
import 'package:hmrodokan/model/user.dart';
import 'package:hmrodokan/utils.dart';

class UserView extends StatefulWidget {
  final bool isEditing;
  final UserModel user;
  const UserView({super.key, required this.isEditing, required this.user});

  @override
  State<UserView> createState() => _UserViewState();
}

InputDecoration viewDecoration =
    const InputDecoration(border: InputBorder.none);

InputDecoration editDecoration =
    const InputDecoration(border: OutlineInputBorder());

TextStyle headerText = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);

class _UserViewState extends State<UserView> {
  final List _userRole = ['counter', 'admin'];
  late String dropDownValue;
  bool isSaving = false;

  late TextEditingController fullnameController =
      TextEditingController(text: widget.user.fullname);
  late TextEditingController emailController =
      TextEditingController(text: widget.user.email);
  late TextEditingController addressController =
      TextEditingController(text: widget.user.address);
  late TextEditingController phoneNumberController =
      TextEditingController(text: widget.user.phonenumber);

  void toggleDropDown(String value) {
    setState(() {
      dropDownValue = value;
    });
  }

  void toggleIsSaving(bool value) {
    setState(() {
      isSaving = value;
    });
  }

  Future<void> handleEdit(BuildContext context) async {
    toggleIsSaving(true);

    String fullnameText = fullnameController.text;
    String emailText = emailController.text;
    String addressText = addressController.text;
    String phoneNumberText = phoneNumberController.text;

    if (fullnameText.isEmpty ||
        emailText.isEmpty ||
        addressText.isEmpty ||
        phoneNumberText.isEmpty ||
        dropDownValue.isEmpty) {
      return Utils().toastor(context, 'Some fields are empty');
    }

    FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper();

    try {
      UserModel editedUser = UserModel(
          uid: widget.user.uid,
          fullname: fullnameText,
          email: emailText,
          address: addressText,
          phonenumber: phoneNumberText,
          role: dropDownValue,
          username: widget.user.username,
          storeId: widget.user.storeId);
      await firebaseAuthHelper.editUser(editedUser);
      if (context.mounted) Utils().toastor(context, 'Successfully edited');
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }

    toggleIsSaving(false);
  }

  @override
  void initState() {
    super.initState();

    toggleDropDown(widget.user.role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_outlined)),
        title: Text(widget.isEditing ? 'Edit User' : 'View User'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green[900],
                foregroundColor: Colors.white,
                child: Text(
                  widget.user.fullname[0].toUpperCase(),
                  style: headerText,
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Fullname',
                    style: headerText,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    // width: 300,
                    child: TextField(
                        controller: fullnameController,
                        readOnly: !widget.isEditing,
                        decoration:
                            widget.isEditing ? editDecoration : viewDecoration),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: headerText,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    // width: 300,
                    child: TextField(
                        controller: emailController,
                        readOnly: !widget.isEditing,
                        decoration:
                            widget.isEditing ? editDecoration : viewDecoration),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Address',
                    style: headerText,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    // width: 300,
                    child: TextField(
                        controller: addressController,
                        readOnly: !widget.isEditing,
                        decoration:
                            widget.isEditing ? editDecoration : viewDecoration),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Phone Number',
                    style: headerText,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    // width: 300,
                    child: TextField(
                        controller: phoneNumberController,
                        readOnly: !widget.isEditing,
                        decoration:
                            widget.isEditing ? editDecoration : viewDecoration),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Role',
                    style: headerText,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    // width: 300,
                    child: DropdownButton(
                        value: dropDownValue,
                        items: _userRole.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: widget.isEditing
                            ? (String? value) => toggleDropDown(value!)
                            : null),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              if (widget.isEditing)
                ElevatedButton(
                    onPressed: () {
                      // handle edit
                      handleEdit(context);
                    },
                    child: isSaving
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
