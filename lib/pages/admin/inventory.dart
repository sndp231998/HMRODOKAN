import 'package:flutter/material.dart';
import 'package:hmrodokan/components/admin_product.dart';
import 'package:hmrodokan/firebase/firebase_firestore.dart';
import 'package:hmrodokan/model/product.dart';
import 'package:hmrodokan/utils.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<ProductModel> _products = [];

  Future<void> getProductsList() async {
    FirebaseFirestoreHelper firebaseFirestoreHelper = FirebaseFirestoreHelper();
    List<ProductModel> productList =
        await firebaseFirestoreHelper.listProducts();
    setState(() {
      _products = productList;
    });
  }

  @override
  void initState() {
    super.initState();

    getProductsList();
  }

  @override
  Widget build(BuildContext context) {
    return _products.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: [
                for (ProductModel products in _products)
                  AdminProduct(products: products),
              ],
            ),
          )
        : const Center(
            child: Text('Add Products to view'),
          );
  }
}
