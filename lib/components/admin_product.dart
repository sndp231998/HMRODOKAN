import 'package:flutter/material.dart';

class AdminProduct extends StatelessWidget {
  const AdminProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black38,
        width: 1.0,
      ))),
      child: Row(
        children: [
          // image
          Image.asset(
            'assets/images/samayang.jpeg',
            width: 80,
          ),

          const SizedBox(
            width: 10,
          ),

          // product name plus qty
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Authentic Samayang Noodles',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  'Quantity: 1000pc',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          // more actions
          PopupMenuButton(itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: 'View',
                child: ListTile(
                  leading: Icon(Icons.link),
                  title: Text('View'),
                ),
              ),
              const PopupMenuItem(
                value: 'Edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                ),
              ),
              const PopupMenuItem(
                value: 'Delete',
                child: ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Delete'),
                ),
              ),
            ];
          }),
        ],
      ),
    );
  }
}
