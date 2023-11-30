import 'package:flutter/material.dart';
import 'package:hmrodokan/components/admin_product.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/product.dart';
import 'package:hmrodokan/provider/products.dart';
import 'package:hmrodokan/provider/user.dart';
import 'package:provider/provider.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();

  @override
  Widget build(BuildContext context) {
    ProductsProvider productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return FutureBuilder(
        // make another changes here to filter out products
        future: firebaseFirestoreHelper.listProducts(
            productsProvider.getFilterValue, userProvider.getUser!.storeId),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return snapshot.data!.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: [
                      for (ProductModel products in snapshot.data!)
                        AdminProduct(products: products),
                    ],
                  ),
                )
              : const Center(
                  child: Text('Add Products to view'),
                );
        }));
  }
}
