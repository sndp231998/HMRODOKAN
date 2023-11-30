import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/product.dart';
import 'package:hmrodokan/pages/admin/product_view.dart';
import 'package:hmrodokan/utils.dart';

class AdminProduct extends StatelessWidget {
  final ProductModel products;
  AdminProduct({super.key, required this.products});
  final FirebaseFirestoreHelper firebaseFirestoreHelper =
      FirebaseFirestoreHelper();

  Future<void> handleDelete(BuildContext context) async {
    try {
      await firebaseFirestoreHelper.deleteProducts(products);
      if (context.mounted) Utils().toastor(context, 'Successfully removed');
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }
    if (context.mounted) Navigator.of(context).pop();
  }

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
              PopupMenuItem(
                value: 'View',
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pop();

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => ProductView(
                              product: products,
                              isEditing: false,
                            ))));
                  },
                  leading: const Icon(Icons.link),
                  title: const Text('View'),
                ),
              ),
              PopupMenuItem(
                value: 'Edit',
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: ((context) => ProductView(
                              isEditing: true,
                              product: products,
                            ))));
                  },
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit'),
                ),
              ),
              PopupMenuItem(
                value: 'Delete',
                child: ListTile(
                  onTap: () {
                    _showDialog(context);
                  },
                  leading: const Icon(Icons.delete),
                  title: const Text('Delete'),
                ),
              ),
            ];
          }),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete the product'),
            content: const Text('Are you sure to remove the product'),
            actions: [
              TextButton(
                  onPressed: () {
                    // call the delete method
                    handleDelete(context);
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel')),
            ],
          );
        });
  }
}
