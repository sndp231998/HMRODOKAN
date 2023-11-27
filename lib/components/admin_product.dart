import 'package:flutter/material.dart';
import 'package:hmrodokan/model/product.dart';

class AdminProduct extends StatelessWidget {
  final ProductModel products;
  const AdminProduct({super.key, required this.products});

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  products.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                Text(
                  'Quantity: ${products.quantity}pc',
                  style: const TextStyle(
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
