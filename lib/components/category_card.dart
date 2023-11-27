import 'package:flutter/material.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/category.dart';
import 'package:hmrodokan/utils.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const CategoryCard({super.key, required this.category});

  Future<void> handleDelete(
      BuildContext context, CategoryModel category) async {
    FirebaseFirestoreHelper firestoreHelper = FirebaseFirestoreHelper();
    try {
      await firestoreHelper.deleteCategories(category);
      if (context.mounted) Utils().toastor(context, 'Deleted Successfully');
    } catch (e) {
      if (context.mounted) Utils().toastor(context, e.toString());
    }
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 200,
      // height: 200,
      margin: const EdgeInsets.all(5),
      // padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Colors.black12,
            width: 1.0,
          )),
      child: Stack(
        children: [
          // if (!category.isPrivate)
          // more button

          // name of category
          Positioned(
            top: 1,
            left: 1,
            right: 1,
            bottom: 1,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    category.imageUrl,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    category.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ]),
          ),

          if (!category.isPrivate)
            Positioned(
              top: 0,
              right: 0,
              // width: 200,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const Text('Edit');
                          });
                    },
                    child: const Icon(
                      Icons.edit,
                      // size: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Delete Category'),
                              content: const Text(
                                  'Are you sure want to remove category?'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      handleDelete(context, category);
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
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                      // size: 18,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
