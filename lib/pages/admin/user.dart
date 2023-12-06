import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_auth.dart';
import 'package:hmrodokan/model/user.dart';
import 'package:hmrodokan/pages/admin/user_view.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:hmrodokan/utils.dart';
import 'package:provider/provider.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  FirebaseAuthHelper authHelper = FirebaseAuthHelper();

  List<UserModel> userList = [];
  bool isLoading = true;

  Future<void> listUser(BuildContext context) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    try {
      List<UserModel> fetchList = [];
      fetchList = await authHelper.listUsers(userProvider.getUser.storeId);
      setState(() {
        userList = fetchList;
      });
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteUser(String storeId, String uid) async {
    try {
      await authHelper.deleteUser(storeId, uid);
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
  void initState() {
    listUser(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    UserModel currentUser = userProvider.getUser;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return userList.isNotEmpty
        ? RefreshIndicator(
            onRefresh: () {
              return listUser(context);
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      // search box

                      // listing of users
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Fullname")),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Role")),
                            DataColumn(label: Text("Address")),
                            DataColumn(label: Text("Action")),
                          ],
                          rows: [
                            for (UserModel user in userList)
                              DataRow(
                                cells: [
                                  DataCell(Text(user.fullname)),
                                  DataCell(Text(user.email)),
                                  DataCell(
                                    Text(
                                      user.role,
                                    ),
                                  ),
                                  DataCell(Text(user.address)),
                                  DataCell(IconButton(
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
                                                    title: const Text('More'),
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
                                                    leading:
                                                        const Icon(Icons.edit),
                                                    title: const Text('Edit'),
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
                                                                    onPressed:
                                                                        () {
                                                                      deleteUser(
                                                                          currentUser
                                                                              .storeId,
                                                                          user.uid);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: const Text(
                                                                        'Yes')),
                                                                TextButton(
                                                                    onPressed:
                                                                        () {
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
                                                    leading: const Icon(
                                                        Icons.delete),
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
                ),
              ),
            ),
          )
        : const Center(child: Text('Please add users to view here'));
  }
}
