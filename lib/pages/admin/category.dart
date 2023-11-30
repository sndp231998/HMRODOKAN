import 'package:flutter/material.dart';
import 'package:hmrodokan/components/category_card.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/category.dart';
import 'package:hmrodokan/provider/products.dart';
import 'package:provider/provider.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();

  @override
  void initState() {
    super.initState();

    resetProductFilter();
  }

  void resetProductFilter() {
    ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    productsProvider.setFilterValue = '';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebaseFirestoreHelper.listCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data!.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.count(crossAxisCount: 2, children: [
                    for (CategoryModel category in snapshot.data!)
                      CategoryCard(
                        category: category,
                      ),
                  ]),
                )
              : (const Center(
                  child: Text('Add some categories to view here'),
                ));
        });
  }
}
