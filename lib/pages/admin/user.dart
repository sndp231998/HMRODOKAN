import 'package:flutter/material.dart';
import 'package:hmrodokan/components/table_head.dart';
import 'package:hmrodokan/firebase/firebase_auth.dart';
import 'package:hmrodokan/model/user.dart';
import 'package:hmrodokan/utils.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  FirebaseAuthHelper authHelper = FirebaseAuthHelper();

  List<UserModel> _userList = [];

  @override
  void initState() {
    super.initState();

    getUserList();
  }

  Future<void> getUserList() async {
    List<UserModel> userList = await authHelper.listUsers();

    setState(() {
      _userList = userList;
    });
  }

  Future<void> deleteUser(String uid) async {
    try {
      await authHelper.deleteUser(uid);
      await getUserList();
      if (context.mounted) {
        Utils().toastor(context, 'Successfully deleted');
      }
    } catch (e) {
      if (context.mounted) {
        Utils().toastor(context, e.toString());
      }
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_userList.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // search box

            // listing of users
            SingleChildScrollView(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(2), // Adjust column widths as needed
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(3),
                  4: FlexColumnWidth(1),
                },
                border: TableBorder.all(color: Colors.black26),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    children: const [
                      TableCell(
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Fullname'))),
                      TableCell(
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Email'))),
                      TableCell(
                          child: Padding(
                              padding: EdgeInsets.all(8), child: Text('Role'))),
                      TableCell(
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text('Address'))),
                      TableCell(
                          child: Padding(
                              padding: EdgeInsets.all(8), child: Text(''))),
                    ],
                  ),
                  for (UserModel user in _userList)
                    TableRow(
                      children: [
                        TableCell(
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(user.fullname))),
                        TableCell(
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(user.email))),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              user.role,
                              style: const TextStyle(
                                backgroundColor: Colors.black38,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(user.address))),
                        TableCell(
                            child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          children: [
                                            const ListTile(
                                              leading: Icon(Icons.details),
                                              title: Text('More'),
                                            ),
                                            const ListTile(
                                              leading: Icon(Icons.edit),
                                              title: Text('Edit'),
                                            ),
                                            ListTile(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            'Delete User'),
                                                        content: const Text(
                                                            'Are you sure to remove the user?'),
                                                        actions: [
                                                          TextButton(
                                                              onPressed: () {
                                                                deleteUser(
                                                                    user.uid);
                                                              },
                                                              child: const Text(
                                                                  'Yes')),
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: const Text(
                                                                  'Cancel')),
                                                        ],
                                                      );
                                                    });
                                              },
                                              leading: const Icon(Icons.delete),
                                              title: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(Icons.more_vert))),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return const Center(
      child: Text('Please add users to view here'),
    );
  }
}
