import 'package:flutter/material.dart';
import 'package:hmrodokan/components/table_head.dart';
import 'package:hmrodokan/firebase/firebase_auth.dart';
import 'package:hmrodokan/model/user.dart';
import 'package:hmrodokan/pages/admin/user_view.dart';
import 'package:hmrodokan/utils.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  FirebaseAuthHelper authHelper = FirebaseAuthHelper();

  Future<void> deleteUser(String uid) async {
    try {
      await authHelper.deleteUser(uid);
      // await getUserList();
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
    return FutureBuilder(
        future: authHelper.listUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // search box

                      // listing of users
                      SingleChildScrollView(
                        child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: const {
                            0: FlexColumnWidth(
                                2), // Adjust column widths as needed
                            1: FlexColumnWidth(3),
                            2: FlexColumnWidth(2),
                            3: FlexColumnWidth(3),
                            4: FlexColumnWidth(1),
                          },
                          border: TableBorder.all(color: Colors.black26),
                          children: [
                            TableRow(
                              decoration:
                                  BoxDecoration(color: Colors.grey[200]),
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
                                        padding: EdgeInsets.all(8),
                                        child: Text('Role'))),
                                TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text('Address'))),
                                TableCell(
                                    child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Text(''))),
                              ],
                            ),
                            for (UserModel user in snapshot.data!)
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
                                                      ListTile(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();

                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          UserView(
                                                                            isEditing:
                                                                                false,
                                                                            user:
                                                                                user,
                                                                          )));
                                                        },
                                                        leading: const Icon(
                                                            Icons.details),
                                                        title:
                                                            const Text('More'),
                                                      ),
                                                      ListTile(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();

                                                          Navigator.of(context).push(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          UserView(
                                                                            isEditing:
                                                                                true,
                                                                            user:
                                                                                user,
                                                                          )));
                                                        },
                                                        leading: const Icon(
                                                            Icons.edit),
                                                        title:
                                                            const Text('Edit'),
                                                      ),
                                                      ListTile(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      'Delete User'),
                                                                  content:
                                                                      const Text(
                                                                          'Are you sure to remove the user?'),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          deleteUser(
                                                                              user.uid);
                                                                        },
                                                                        child: const Text(
                                                                            'Yes')),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: const Text(
                                                                            'Cancel')),
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        leading: const Icon(
                                                            Icons.delete),
                                                        title: const Text(
                                                            'Delete'),
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
                )
              : const Center(child: Text('Please add users to view here'));
        });
  }
}
