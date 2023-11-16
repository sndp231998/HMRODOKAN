import 'package:flutter/material.dart';
import 'package:hmrodokan/components/table_body.dart';
import 'package:hmrodokan/components/table_head.dart';

class User extends StatefulWidget {
  const User({super.key});

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // search box

          // listing of users
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              const TableRow(children: [
                TableHead(tableData: 'ID'),
                TableHead(tableData: 'Fullname'),
                TableHead(tableData: 'Email'),
                TableHead(tableData: 'Role'),
                TableHead(tableData: 'Address'),
                TableHead(tableData: ''),
              ]),
              TableRow(children: [
                const TableCell(child: Text('123')),
                const TableCell(child: Text('alex')),
                const TableCell(child: Text('alex@a.xom')),
                const TableCell(
                    child: Text(
                  'Admin',
                  style: TextStyle(
                    backgroundColor: Colors.black38,
                    color: Colors.white,
                  ),
                )),
                const TableCell(child: Text('alex address')),
                TableCell(
                  child: PopupMenuButton(onSelected: (value) {
                    if (value == 'more') {}
                    if (value == 'edit') {}
                    if (value == 'delete') {}
                  }, itemBuilder: ((context) {
                    return [
                      const PopupMenuItem(
                          value: 'more',
                          textStyle: TextStyle(fontSize: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.details,
                              size: 20,
                            ),
                            title: Text('More'),
                          )),
                      const PopupMenuItem(
                          value: 'edit',
                          textStyle: TextStyle(fontSize: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.edit,
                              size: 20,
                            ),
                            title: Text('Edit'),
                          )),
                      const PopupMenuItem(
                          value: 'delete',
                          textStyle: TextStyle(fontSize: 10),
                          child: ListTile(
                            leading: Icon(
                              Icons.delete,
                              size: 20,
                            ),
                            title: Text('Delete'),
                          )),
                    ];
                  })),
                ),
              ])
            ],
          )
        ],
      ),
    );
  }
}
